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
    private var pageNumber: Int = 1
    private let pageSize = 10
    
    private let repository: ProfileRepositoryProtocol
    
    // Dependency injection of ProfileRepositoryProtocol, default is ProfileRepository
    init(repository: ProfileRepositoryProtocol = ProfileRepository()) {
        self.repository = repository
    }
    
    
    // Fetch Profiles Data from the repository and handle the response
    func fetchProfilesData() async {
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
            print(error)
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = "Failed to load profiles: \(error.localizedDescription)"
            }
        }
    }
}
