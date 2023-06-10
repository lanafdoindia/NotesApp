//
//  NotesViewModel.swift
//  NotesApp
//
//  Created by Lana Fernando S on 9/12/22.
//

import Foundation
import Combine
import CoreData

class NotesViewModel {
  enum Section { case notes}
  
  @Published private(set) var notes: [Notes] = []

  private let notesService = NotesService()
  private var bindings = Set<AnyCancellable>()

  func fetchNotes() {
    let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
    do {
      let notesDetails = try CoreDataService.instance.context.fetch(fetchRequest)
      if notesDetails.count == 0 {
        let notesCompletionHander: (Subscribers.Completion<Error>) -> Void = { completion in
        }
        let notesValueHandler: ([NotesModel]) -> Void = { [weak self] notes in
          for note in notes {
            let coreNoteData = Notes(context: CoreDataService.instance.context)
            coreNoteData.id = note.id
            coreNoteData.title = note.title
            coreNoteData.body = note.body
            coreNoteData.archived = note.archived
            coreNoteData.image = note.image
            coreNoteData.created_time = "\(note.created_time)"
            CoreDataService.instance.saveContext()
          }
          self?.fetchNotes()
        }
        notesService.get().sink(receiveCompletion: notesCompletionHander, receiveValue: notesValueHandler).store(in: &bindings)
      } else {
        CoreDataService.instance.notes = notesDetails.sorted(by: { Double($0.created_time ?? "0") ?? 0 > Double($1.created_time ?? "0") ?? 0 })
      }
    } catch let error as NSError {
      print("Core Data Fetch error: \(error.localizedDescription)")
    }
  }
}
