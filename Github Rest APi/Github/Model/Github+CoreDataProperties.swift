//
//  Github+CoreDataProperties.swift
//  Github Rest APi
//
//  Created by Inderpreet Singh on 04/03/24.
//
//

import Foundation
import CoreData


extension Github {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Github> {
        return NSFetchRequest<Github>(entityName: "Github")
    }

    @NSManaged public var users: Data?
    @NSManaged public var token: String?

}

extension Github : Identifiable {

}
