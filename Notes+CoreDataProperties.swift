//
//  Notes+CoreDataProperties.swift
//  NotesApp
//
//  Created by Lana Fernando S on 9/12/22.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var id: String?
    @NSManaged public var archived: Bool
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var created_time: String?
    @NSManaged public var image: String?
    @NSManaged public var image_data: Data?

}

extension Notes : Identifiable {

}
