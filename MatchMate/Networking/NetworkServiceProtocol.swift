//
//  NetworkServiceProtocol.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 24/07/24.
//

import Foundation

// Protocol defining the contract for the API Service
protocol NetworkServiceProtocol {
    // Generic function to fetch data from a given URL, returns a Decoded Model
    func fetchProfileData<T: Decodable>(from url: String, method: HTTPMethod, params: [String: String]?) async throws -> T
}
