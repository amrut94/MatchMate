//
//  NewMatchesViewModel.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 24/07/24.
//

import Foundation
class NewMatchesViewModel: ObservableObject {
    @Published var profiles: [Profile] = []
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    
    private var pageNumber: Int = 1
    private let pageSize = 25
    
    private let repository: ProfileRepositoryProtocol
    private let type: MatchType
    
    /// Dependency injection of ProfileRepositoryProtocol, default is ProfileRepository
    /// - Parameters:
    ///   - repository: The repository for fetching profiles, default is ProfileRepository.
    ///   - type: The type of match (all or specific match type).
    init(repository: ProfileRepositoryProtocol = ProfileRepository(), type: MatchType) {
        self.repository = repository
        self.type = type
    }
    
    
    // Fetch Profiles Data from the repository and handle the response
    func fetchProfilesData() async {
        pageNumber = 1
        DispatchQueue.main.async { [weak self] in
            self?.profiles = []
        }
        if type == .all {
            await fetchAllProfileData()
        } else {
            await fetchMatchProfileData()
        }
    }

    /// Load more profile data for pagination
    func loadMoreData() async {
        if type == .all {
            await fetchAllProfileData()
        } else {
            await fetchMatchProfileData()
        }
    }
    
    /// Fetch all profile data from the repository
    private func fetchAllProfileData() async {
        do {
            let profileResponse = try await repository.getProfilesData(page: pageNumber, size: pageSize)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                if let profileResponse {
                    if profiles.count < pageSize {
                        profiles = profileResponse
                    } else {
                        profiles.append(contentsOf: profileResponse)
                    }
                    pageNumber += 1
                    
                }
            }
        } catch (let error) {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = "Failed to load profiles: \(error.localizedDescription)"
            }
        }
    }
    
    /// Fetch match profile data from the repository
    private func fetchMatchProfileData() async {
        do {
            let profileResponse = try await repository.fetchMatchProfiles(page: pageNumber, results: pageSize)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                if let profileResponse {
                    pageNumber += 1
                    profiles.append(contentsOf: profileResponse)
                }
            }
        } catch (let error) {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = "Failed to load profiles: \(error.localizedDescription)"
            }
        }
    }
    
    /// Update the status of a profile
    /// - Parameters:
    ///   - index: The index of the profile in the profiles array.
    ///   - status: The new status to set.
    func upateProfileStatus(index: Int, status: Bool) {
        guard let id = profiles[index].login?.uuid else {
            return
        }
        Task {
            do {
                try await repository.updateProfileStatus(id: id, status: status)
                DispatchQueue.main.async { [weak self] in
                    self?.profiles[index].isAccepted = status
                }
            }
            catch (let error) {
                DispatchQueue.main.async { [weak self] in
                    self?.errorMessage = "Failed to load profiles: \(error.localizedDescription)"
                    self?.showAlert = true
                }
            }
        }
    }
}
