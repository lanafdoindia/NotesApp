//
//  BaseViewController.swift
//  NotesApp
//
//  Created by Lana Fernando S on 9/17/22.
//

import UIKit

class BaseViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .darkGray.withAlphaComponent(0.4)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setNeedsStatusBarAppearanceUpdate()
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
}
