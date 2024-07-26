
import Foundation
struct ProfileResult  : Codable {
	let results : [Profile]?
	let info : Info?

	enum CodingKeys: String, CodingKey {

		case results = "results"
		case info = "info"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		results = try values.decodeIfPresent([Profile].self, forKey: .results)
		info = try values.decodeIfPresent(Info.self, forKey: .info)
	}

}
