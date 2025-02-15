import Foundation
struct Dob : Codable {
	let date : String?
	let age : Int?

	enum CodingKeys: String, CodingKey {

		case date = "date"
		case age = "age"
	}

    init(date : String?, age : Int?) {
        self.date = date
        self.age = age
    }

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		date = try values.decodeIfPresent(String.self, forKey: .date)
		age = try values.decodeIfPresent(Int.self, forKey: .age)
	}

}
