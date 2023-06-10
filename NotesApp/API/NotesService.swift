//
//  NotesService.swift
//  NotesApp
//
//  Created by Lana Fernando S on 9/12/22.
//

import Foundation
import Combine
import UIKit

enum NotesServiceError: Error {
  case urlRequest
}

final class NotesService {

  func get() -> AnyPublisher<[NotesModel], Error> {
    var sessionDataTask: URLSessionDataTask?

    let onSubscription: (Subscription) -> Void = { _ in sessionDataTask?.resume() }
    let onCancel: () -> Void = { sessionDataTask?.cancel() }
    return Future<[NotesModel], Error> { [weak self] promise in
      guard let urlRequest = self?.getURLRequest() else {
        promise(.failure(NotesServiceError.urlRequest))
        return
      }
      sessionDataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
        guard let data = data else {
          if let error = error {
            promise(.failure(error))
          }
          return
        }
        do {
          let notes = try JSONDecoder().decode([NotesModel].self, from: data)
          promise(.success(notes))
        } catch {
          promise(.failure(NotesServiceError.urlRequest))
        }
      }
    }
    .handleEvents(receiveSubscription: onSubscription,  receiveCancel: onCancel)
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
  }

  class func getImage(withImageUrlString imageUrlString: String, completionHandler: @escaping (UIImage?) -> Void) {
    guard let url = URL(string: imageUrlString) else {
        completionHandler(nil)
        return
    }
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            return
        }
        if let _ = error {
            DispatchQueue.main.async {
                completionHandler(nil)
            }
            return
        }
        let image = UIImage(data: data)
        completionHandler(image)
    }
    task.resume()
  }

  private func getURLRequest() -> URLRequest? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "raw.githubusercontent.com"
    components.path = "/RishabhRaghunath/JustATest/master/notes"
    guard let url = components.url else { return nil }
    var urlRequest = URLRequest(url: url)
   // urlRequest.timeoutInterval = 10.0
    urlRequest.httpMethod = "GET"
    return urlRequest
  }
}
