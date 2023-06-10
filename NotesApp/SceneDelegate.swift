//
//  SceneDelegate.swift
//  NotesApp
//
//  Created by Lana Fernando S on 9/12/22.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let vc = HomeViewController()
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = UINavigationController(rootViewController: vc)
    self.window = window
    let statusBar = UIView(frame: window.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
    statusBar.backgroundColor = .black
    statusBar.tintColor = .purple
    window.addSubview(statusBar)
    window.makeKeyAndVisible()
  }

  func sceneDidDisconnect(_ scene: UIScene) {
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
  }

  func sceneWillResignActive(_ scene: UIScene) {
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
//    let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
//    do {
//      let notesDetails = try CoreDataService.instance.context.fetch(fetchRequest)
//      for notesDetail in notesDetails {
//        CoreDataService.instance.context.delete(notesDetail)
//      }
//      CoreDataService.instance.saveContext()
//    } catch let error as NSError {
//      print("Core data delete error:\(error.localizedDescription)")
//    }
  }
}

