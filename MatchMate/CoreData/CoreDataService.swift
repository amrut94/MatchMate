//
//  CoreDataService.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 25/07/24.
//

import Foundation
import CoreData
import SwiftUI

/// Protocol defining the core data service interface.
protocol CoreDataService {
    func saveProfiles(_ profiles: [Profile]) async throws
    func fetchProfiles(page: Int, results: Int) async throws -> [Profile]?
    func fetchMatchProfiles(page: Int, results: Int) async throws -> [Profile]?
    func updateProfileStatus(id: String, status: Bool) async throws
}

/// Implementation of the CoreDataService protocol.
class CoreDataServiceImpl: CoreDataService {
    
    private let context: NSManagedObjectContext
    
    /// Initializes the service with the provided NSManagedObjectContext.
    /// - Parameter context: The managed object context to be used by the service.
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    /// Saves an array of Profile objects into the Core Data context.
    /// - Parameter profiles: The array of Profile objects to be saved.
    /// - Throws: An error if the save operation fails.
    func saveProfiles(_ profiles: [Profile]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            context.perform {
                for profile in profiles {
                    let profileEntity = ProfileModel(context: self.context)
                    profileEntity.update(from: profile, context: self.context)
                }
                do {
                    try self.context.save()
                    continuation.resume(returning: ())
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Fetches a paginated list of Profile objects from the Core Data context.
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - results: The number of results per page.
    /// - Returns: An array of Profile objects or nil if no profiles are found.
    /// - Throws: An error if the fetch operation fails.
    func fetchProfiles(page: Int, results: Int) async throws -> [Profile]? {
        try await withCheckedThrowingContinuation { continuation in
            context.perform {
                let fetchRequest: NSFetchRequest<ProfileModel> = ProfileModel.fetchRequest()
                fetchRequest.fetchOffset = (page - 1) * results
                fetchRequest.fetchLimit = results
                do {
                    let profileEntity = try self.context.fetch(fetchRequest)
                    let profiles = profileEntity.map { $0.toDomainModel() }
                    continuation.resume(returning: profiles)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /// Fetches a paginated list of matched Profile objects from the Core Data context.
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - results: The number of results per page.
    /// - Returns: An array of Profile objects or nil if no profiles are found.
    /// - Throws: An error if the fetch operation fails.
    func fetchMatchProfiles(page: Int, results: Int) async throws -> [Profile]? {
        try await withCheckedThrowingContinuation { continuation in
            context.perform {
                let fetchRequest: NSFetchRequest<ProfileModel> = ProfileModel.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "isAccepted == %@", NSNumber(value: true))
                fetchRequest.fetchOffset = (page - 1) * results
                fetchRequest.fetchLimit = results
                do {
                    let profileEntity = try self.context.fetch(fetchRequest)
                    let profiles = profileEntity.map { $0.toDomainModel() }
                    continuation.resume(returning: profiles)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /// Updates the status of a Profile object in the Core Data context.
    /// - Parameters:
    ///   - id: The unique identifier of the Profile to be updated.
    ///   - status: The new status to be set.
    /// - Throws: An error if the update operation fails.
    func updateProfileStatus(id: String, status: Bool) async throws {
        try await context.perform {
            let fetchRequest: NSFetchRequest<ProfileModel> = ProfileModel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            do {
                let profiles = try self.context.fetch(fetchRequest)
                if let profileObject = profiles.first {
                    profileObject.isAccepted = NSNumber(value: status)
                    try self.context.save()
                    
                } else {
                    throw NetworkError.noDataFound
                }
            } catch {
                self.context.rollback()
                throw error
            }
        }
    }
}
