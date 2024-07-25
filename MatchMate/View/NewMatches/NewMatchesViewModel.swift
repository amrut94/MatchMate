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
    
    // Dependency injection of ProfileRepositoryProtocol, default is ProfileRepository
    init(repository: ProfileRepositoryProtocol = ProfileRepository(), type: MatchType) {
        self.repository = repository
        self.type = type
    }
    
    
    // Fetch Profiles Data from the repository and handle the response
    func fetchProfilesData() async {
        if type == .all {
            await fetchAllProfileData()
        } else {
            await fetchMatchProfileData()
        }
    }
    
    private func fetchAllProfileData() async {
        do {
            let profileResponse = try await repository.getProfilesData(page: pageNumber, size: pageSize)
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
    
    
    func upateProfileStatus(index: Int, status: Bool) {
        guard let id = profiles[index].login?.uuid else {
            return
        }
        profiles[index].isAccepted = status
        Task {
            do {
                try await repository.updateProfileStatus(id: id, status: status)
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
