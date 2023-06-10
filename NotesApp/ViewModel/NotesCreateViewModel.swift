//
//  NotesCreateViewModel.swift
//  NotesApp
//
//  Created by Lana Fernando S on 9/17/22.
//

import Foundation
import Combine

class NotesCreateViewModel {
  @Published var title: String = ""

  var isInputValid: AnyPublisher<Bool, Never> {
    return $title.map { $0.count > 0 }.map { $0 }.eraseToAnyPublisher()
  }
}
