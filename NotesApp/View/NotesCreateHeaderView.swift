//
//  NotesCreateHeaderView.swift
//  NotesApp
//
//  Created by Lana Fernando S on 9/12/22.
//

import UIKit

class NotesCreateHeaderView: UIView {

  private var backButton = AppNavbarButton()
  var attachBtn = AppNavbarButton()
  var saveBtn = AppNavbarButton()

  var delegate: NotesCreateProtocol?

  override init(frame: CGRect) {
    super.init(frame: .zero)
    backgroundColor = .clear
    configureHeaderView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configureHeaderView() {
    addSubview(backButton)
    backButton.setButtonImage(withSymbol: "chevron.backward")
    backButton.addTarget(self, action: #selector(onbackButtonClicked), for: .touchUpInside)
    
    addSubview(attachBtn)
    attachBtn.setButtonImage(withSymbol: "doc.text.image")
    attachBtn.addTarget(self, action: #selector(onAttachedClicked), for: .touchUpInside)

    addSubview(saveBtn)
    saveBtn.setTitle("Save", for: .normal)
    saveBtn.addTarget(self, action: #selector(onSaveClicked), for: .touchUpInside)

    backButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
      backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      backButton.heightAnchor.constraint(equalToConstant: 45),
      backButton.widthAnchor.constraint(equalToConstant: 45)
    ])

    saveBtn.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      saveBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.0),
      saveBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
      saveBtn.heightAnchor.constraint(equalToConstant: 45),
      saveBtn.widthAnchor.constraint(equalToConstant: 60)
    ])

    attachBtn.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      attachBtn.trailingAnchor.constraint(equalTo: saveBtn.leadingAnchor, constant: -10.0),
      attachBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
      attachBtn.heightAnchor.constraint(equalToConstant: 45),
      attachBtn.widthAnchor.constraint(equalToConstant: 50)
    ])
  }

  @objc private func onAttachedClicked() {
    delegate?.onClickedAttach()
  }

  @objc private func onSaveClicked() {
    delegate?.onClickedSave()
  }

  @objc private func onbackButtonClicked() {
    delegate?.onClickedBack()
  }
}
