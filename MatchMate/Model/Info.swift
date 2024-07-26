import Foundation
struct Info : Codable {
	let results : Int?
	let page : Int?

	enum CodingKeys: String, CodingKey {

		case results = "results"
		case page = "page"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		results = try values.decodeIfPresent(Int.self, forKey: .results)
		page = try values.decodeIfPresent(Int.self, forKey: .page)
	}

}
