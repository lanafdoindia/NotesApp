//
//  CoreDataService.swift
//  NotesApp
//
//  Created by Lana Fernando S on 9/12/22.
//

import Foundation
import CoreData
import UIKit

class CoreDataService {

  static let instance : CoreDataService = CoreDataService()

  @Published var notes: [Notes] = []

  init() {

  }

  var context : NSManagedObjectContext{
    return persistentContainer.viewContext;
  }

  // MARK: - Core Data stack

  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "NotesApp")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  // MARK: - Core Data Saving support

  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }

  func addData(title: String, body: String, attachment: UIImage?) {
    let noteId = matches(for: "[0-9]+$", in: notes.first?.id ?? "").first ?? 0
    let createdTime = NSDate().timeIntervalSince1970
    let noteData = Notes(context: self.context)
    noteData.id = "NID\(noteId + 1)"
    noteData.title = title
    noteData.body = body
    noteData.created_time = "\(createdTime)"
    if let attachment = attachment {
      noteData.image = "Local Image"
      noteData.image_data = attachment.jpegData(compressionQuality: 0.5)
    }
    self.saveContext()
    self.notes.insert(noteData, at: 0)
  }

  func updateNote(withNoteId noteId: String, image: UIImage) {
    let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id = %@", noteId)
    do {
      let notesDetails = try self.context.fetch(fetchRequest)
      if notesDetails.count > 0, let note = notesDetails.first {
        note.image_data = image.jpegData(compressionQuality: 0.5)
        self.saveContext()
      }
    } catch let error as NSError {
      print("Core Data error log: \(error.localizedDescription)")
    }
  }

  func getNote(withNoteId noteId: String) -> Notes? {
    let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id = %@", noteId)
    do {
      let notesDetails = try self.context.fetch(fetchRequest)
      if notesDetails.count > 0, let note = notesDetails.first {
        return note
      }
    } catch let error as NSError {
      print("Core Data error log: \(error.localizedDescription)")
    }
    return nil
  }

  func getAllImage() -> [(noteId: String, imageData: Data)] {
    let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
    do {
      let notesDetails = try self.context.fetch(fetchRequest)
      return notesDetails.compactMap {
        guard let id = $0.id, let imageData = $0.image_data else {
          return nil
        }
        return (id, imageData)
      }
    } catch let error as NSError {
      print("Core Data error log: \(error.localizedDescription)")
    }
    return []
  }

  func getAllNotes() -> [Notes] {
    let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
    do {
      let notesDetails = try self.context.fetch(fetchRequest)
      return notesDetails
    } catch let error as NSError {
      print("Core Data error log: \(error.localizedDescription)")
    }
    return []
  }

  func matches(for regex: String, in text: String) -> [Int] {

      do {
          let regex = try NSRegularExpression(pattern: regex)
          let results = regex.matches(in: text,
                                      range: NSRange(text.startIndex..., in: text))
          return results.map {
            Int(text[Range($0.range, in: text)!]) ?? 0
          }
      } catch let error {
          print("invalid regex: \(error.localizedDescription)")
          return []
      }
  }
}
