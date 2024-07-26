//
//  NewMatchesViewModelTest.swift
//  MatchMateTests
//
//  Created by AMRUT WAGHMARE on 26/07/24.
//

import XCTest
@testable import MatchMate

final class NewMatchesViewModelTest: XCTestCase {
    
    var viewModel: NewMatchesViewModel?
    var mockRepository: MockProfileRepository?
    
    override func setUp() {
        super.setUp()
        mockRepository = MockProfileRepository()
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testFetchAllProfilesDataSuccess() async {
        // Given
        guard let mockRepository else {
            XCTFail("Repository is nil ")
            return
        }
        let expectedProfiles = [Profile(gender: "male", name: nil, location: nil, dob: nil, phone: "123", cell: "123", picture: nil, login: Login(uuid: "123"), isAccepted: true)]
        mockRepository.profilesData = expectedProfiles
        viewModel = NewMatchesViewModel(repository: mockRepository, type: .all)
        // When
        Task {
            await viewModel?.fetchProfilesData()
            
            // Then
            XCTAssertEqual(viewModel?.profiles.count, expectedProfiles.count)
            XCTAssertNil(viewModel?.errorMessage)
        }
    }
    
    func testFetchAllProfilesDataFailure() async {
        // Given
        guard let mockRepository else {
            XCTFail("Repository is nil ")
            return
        }
        let expectedError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load profiles"])
        mockRepository.error = expectedError
        viewModel = NewMatchesViewModel(repository: mockRepository, type: .all)
        
        // When
        Task {
            await viewModel?.fetchProfilesData()
            
            // Then
            XCTAssertTrue(viewModel?.profiles.isEmpty ?? false)
            XCTAssertEqual(viewModel?.errorMessage, "Failed to load profiles: Failed to load profiles")
        }
    }
    
    
    func testUpdateProfileStatusSuccess() async {
        // Given
        guard let mockRepository else {
            XCTFail("Repository is nil ")
            return
        }
        let profile = Profile(gender: "male", name: nil, location: nil, dob: nil, phone: "123", cell: "123", picture: nil, login: Login(uuid: "123"), isAccepted: false)
        viewModel = NewMatchesViewModel(repository: mockRepository, type: .all)
        viewModel?.profiles = [profile]
        
        // When
        viewModel?.upateProfileStatus(index: 0, status: true)
        
        // Then
        XCTAssertTrue(viewModel?.profiles[0].isAccepted ?? false)
        XCTAssertNil(viewModel?.errorMessage)
    }
}

// Mock implementation of ProfileRepositoryProtocol
class MockProfileRepository: ProfileRepositoryProtocol {
    
    var profilesData: [Profile]?
    var matchProfiles: [Profile]?
    var error: Error?
    
    func getProfilesData(page: Int, size: Int) async throws -> [MatchMate.Profile]? {
        if let error = error {
            throw error
        }
        return profilesData ?? []
    }
    
    func fetchMatchProfiles(page: Int, results: Int) async throws -> [MatchMate.Profile]? {
        if let error = error {
            throw error
        }
        return matchProfiles ?? []
    }
    
    func updateProfileStatus(id: String, status: Bool) async throws {
        if let error = error {
            throw error
        }
    }
}
