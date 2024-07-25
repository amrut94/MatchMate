//
//  Profile+CoreDataProperties.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 25/07/24.
//
//

import Foundation
import CoreData


extension ProfileModel {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileModel> {
        return NSFetchRequest<ProfileModel>(entityName: "ProfileModel")
    }
    
    @NSManaged public var cell: String?
    @NSManaged public var gender: String?
    @NSManaged public var id: String?
    @NSManaged public var phone: String?
    @NSManaged public var age: Int32
    @NSManaged public var dob: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var state: String?
    @NSManaged public var title: String?
    @NSManaged public var first: String?
    @NSManaged public var last: String?
    @NSManaged public var large: String?
    @NSManaged public var medium: String?
    @NSManaged public var thumbnail: String?
    
}

extension ProfileModel : Identifiable {
    func update(from profile: Profile, context: NSManagedObjectContext) {
        self.id = profile.login?.uuid
        self.cell = profile.cell
        self.gender = profile.gender
        self.phone = profile.phone
        self.age = Int32(profile.dob?.age ?? 0)
        self.dob = profile.dob?.date
        self.city = profile.location?.city
        self.country = profile.location?.country
        self.state = profile.location?.state
        self.title = profile.name?.title
        self.first = profile.name?.first
        self.last = profile.name?.last
        self.large = profile.picture?.large
        self.medium = profile.picture?.medium
        self.thumbnail = profile.picture?.thumbnail
    }
    
    func toDomainModel() -> Profile {
        return Profile(
            gender: gender,
            name: Name(
                title: title,
                first: first,
                last: last),
            location: Location(
                city: city,
                state: state,
                country: country),
            dob: Dob(
                date: dob,
                age: Int(age)),
            phone: phone,
            cell: cell,
            picture: Picture(
                large: large,
                medium: medium,
                thumbnail: thumbnail),
            login: Login(uuid: id))
    }
}
