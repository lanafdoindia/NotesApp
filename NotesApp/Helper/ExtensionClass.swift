//
//  ExtensionClass.swift
//  NotesApp
//
//  Created by Lana Fernando S on 9/15/22.
//

import Foundation
import UIKit
import Combine

extension String {
    func getDateStringFromUTC() -> String {
      let date = Date(timeIntervalSince1970: Double(self) ?? 0.0)

        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
        dateFormatter.dateStyle = .medium

        return dateFormatter.string(from: date)
    }
}

class AppNavbarButton: UIButton {

  override init(frame: CGRect) {
    super.init(frame: .zero)
    backgroundColor = .gray.withAlphaComponent(0.4)
    tintColor = .white
    layer.cornerRadius = 10.0
  }

  func setButtonImage(withSymbol: String) {
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
    let largeBoldImage = UIImage(systemName: withSymbol, withConfiguration: largeConfig)
    setImage(largeBoldImage, for: .normal)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UIColor {
    static var random: UIColor {
      return .init(hue: .random(in: 0...1), saturation: 0.4, brightness: 1, alpha: 0.6)
    }
}

extension UITextField {
  var textPublisher: AnyPublisher<String, Never> {
    NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self).compactMap { $0.object as? UITextField }.compactMap(\.text).eraseToAnyPublisher()
  }
}

extension UIButton {
  var isEnabledButton: Bool {
    get {
      isEnabled
    } set {
      alpha = newValue ? 1.0 : 0.5
      isEnabled = newValue
    }
  }
}
