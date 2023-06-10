//
//  NotesModel.swift
//  NotesApp
//
//  Created by Lana Fernando S on 9/12/22.
//

import Foundation

struct NotesModel: Decodable, Hashable {
  let id: String
  let archived: Bool
  let title: String
  let body: String
  let created_time: Int
  let image: String?
}
