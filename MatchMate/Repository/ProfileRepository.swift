//
//  ProfileRepository.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 24/07/24.
//

import Foundation

// Protocol defining the contract for the Profiles Repository
protocol ProfileRepositoryProtocol {
    // Function to get candidate profile, returns an array of Profile objects or an error
    func getProfilesData(page: Int, size: Int) async throws -> [Profile]?
    func updateProfileStatus(id: String, status: Bool) async throws
    func fetchMatchProfiles(page: Int, results: Int) async throws -> [Profile]?
}

// Implementation of the ProfileRepositoryProtocol
class ProfileRepository: ProfileRepositoryProtocol {
    
    private let apiService: NetworkServiceProtocol
    private let coreDataService: CoreDataService
    
    // Dependency injection of NetworkServiceProtocol, default is NetworkService
    init(apiService: NetworkServiceProtocol = NetworkService(), 
         coreDataService: CoreDataService = CoreDataServiceImpl(context: CoreDataManager.shared.context)) {
        self.apiService = apiService
        self.coreDataService = coreDataService
    }
    
    /// Fetch profiles from the API using the injected API service.
    /// - Parameters:
    ///   - page: The page number for pagination.
    ///   - size: The number of results per page.
    /// - Returns: An array of Profile objects or nil if no profiles are found.
    /// - Throws: An error if the fetch operation fails.
    func getProfilesData(page: Int, size: Int) async throws -> [Profile]? {
        do {
            let profileResult: ProfileResult = try await apiService.fetchProfileData(
                from: APIEndPoint.baseURL,
                method: .get,
                params: [APIConstant.results : "\(size)",
                         APIConstant.page: "\(page)"]
            )
            guard let profiles = profileResult.results else {
                throw NetworkError.noDataFound
            }
            try await coreDataService.saveProfiles(profiles)
           return try await fetchDataFromLocal(page: page, size: size)
        } catch {
            return try await fetchDataFromLocal(page: page, size: size)
        }
    }
    
    /// Fetch profiles from local storage.
    /// - Parameters:
    ///   - page: The page number for pagination.
    ///   - size: The number of results per page.
    /// - Returns: An array of Profile objects or nil if no profiles are found.
    /// - Throws: An error if the fetch operation fails.
    private func fetchDataFromLocal(page: Int, size: Int) async throws -> [Profile]? {
        do {
            return try await coreDataService.fetchProfiles(page: page, results: size)
        } catch {
            throw error
        }
    }
    
    /// Update the status of a profile in local storage.
    /// - Parameters:
    ///   - id: The unique identifier of the profile.
    ///   - status: The new status to be set.
    /// - Throws: An error if the update operation fails.
    func updateProfileStatus(id: String, status: Bool) async throws {
        do {
            try await coreDataService.updateProfileStatus(id: id, status: status)
        } catch {
            throw error
        }
    }
 
    /// Fetch matched profiles from local storage.
    /// - Parameters:
    ///   - page: The page number for pagination.
    ///   - results: The number of results per page.
    /// - Returns: An array of Profile objects or nil if no profiles are found.
    /// - Throws: An error if the fetch operation fails.
    func fetchMatchProfiles(page: Int, results: Int) async throws -> [Profile]? {
        do {
            return try await coreDataService.fetchMatchProfiles(page: page, results: results)
        } catch {
            throw error
        }
    }
}
