import Foundation
struct Location : Codable {
    let city : String?
    let state : String?
    let country : String?
    
    enum CodingKeys: String, CodingKey {
        
        case city = "city"
        case state = "state"
        case country = "country"
    }
    
    init(city : String?,
         state : String?,
         country : String?) {
        self.city = city
        self.state = state
        self.country = country
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        country = try values.decodeIfPresent(String.self, forKey: .country)
    }
}
