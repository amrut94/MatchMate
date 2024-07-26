import Foundation

struct Profile : Codable {
    let gender : String?
    let name : Name?
    let location : Location?
    let dob : Dob?
    let phone : String?
    let cell : String?
    let picture : Picture?
    let login : Login?
    var isAccepted: Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case gender = "gender"
        case name = "name"
        case location = "location"
        case dob = "dob"
        case phone = "phone"
        case cell = "cell"
        case picture = "picture"
        case login = "login"
    }
    
    init(gender: String?,
         name: Name?,
         location: Location?,
         dob: Dob?,
         phone: String?,
         cell: String?,
         picture: Picture?,
         login: Login?,
         isAccepted: Bool?) {
        self.gender = gender
        self.name = name
        self.location = location
        self.dob = dob
        self.phone = phone
        self.cell = cell
        self.picture = picture
        self.login = login
        self.isAccepted = isAccepted
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        name = try values.decodeIfPresent(Name.self, forKey: .name)
        location = try values.decodeIfPresent(Location.self, forKey: .location)
        dob = try values.decodeIfPresent(Dob.self, forKey: .dob)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        cell = try values.decodeIfPresent(String.self, forKey: .cell)
        picture = try values.decodeIfPresent(Picture.self, forKey: .picture)
        login = try values.decodeIfPresent(Login.self, forKey: .login)
    }
}
