//
//  CoreDataService.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 25/07/24.
//

import Foundation
import CoreData
import SwiftUI

protocol CoreDataService {
    func saveProfiles(_ profiles: [Profile]) async throws
    func fetchProfiles(page: Int, results: Int) async throws -> [Profile]?
}

class CoreDataServiceImpl: CoreDataService {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    
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
    
}