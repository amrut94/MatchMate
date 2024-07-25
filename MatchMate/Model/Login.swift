//
//  Login.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 25/07/24.
//

import Foundation
struct Login : Codable {
    let uuid : String?

    enum CodingKeys: String, CodingKey {

        case uuid = "uuid"
    }
    
    init(uuid: String?) {
        self.uuid = uuid
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
    }

}
