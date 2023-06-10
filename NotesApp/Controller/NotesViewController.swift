//
//  NotesViewController.swift
//  NotesApp
//
//  Created by Lana Fernando S on 9/13/22.
//

import UIKit

class NotesViewController: BaseViewController {

  var backButton = AppNavbarButton()
  var attachedImage: UIImageView!
  var contentLabel = UILabel()

  let noteId: String
  let currentIndex: Int
  var note: Notes?

  init(noteId: String, currentIndex: Int) {
    self.noteId = noteId
    self.currentIndex = currentIndex
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    note = CoreDataService.instance.getNote(withNoteId: noteId)
    addSubView()
  }

  private func addSubView() {
    view.addSubview(contentLabel)
    view.addSubview(backButton)
    if isContainsAttachment {
      attachedImage = UIImageView()
      view.addSubview(attachedImage)
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
      attachedImage.isUserInteractionEnabled = true
      attachedImage.addGestureRecognizer(tapGestureRecognizer)
    }
    setConstraints()
    configureView()
  }

  private func setConstraints() {
    backButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
      backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25.0),
      backButton.heightAnchor.constraint(equalToConstant: 35),
      backButton.widthAnchor.constraint(equalToConstant: 35)
    ])

    if isContainsAttachment {
      attachedImage.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        attachedImage.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
        attachedImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        attachedImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        attachedImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/5),
      ])
    }

    contentLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contentLabel.topAnchor.constraint(equalTo: isContainsAttachment ? attachedImage.bottomAnchor : backButton.bottomAnchor, constant: 15.0),
      contentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5.0),
      contentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5.0),
      //contentLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 5.0),
    ])
  }

  private func configureView() {
    backButton.setButtonImage(withSymbol: "chevron.backward")
    backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    guard let note = note else {
      return
    }
    do {
      contentLabel.textColor = .white
      let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold)]
      let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
      //let thirdAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

      let firstString = NSMutableAttributedString(string: "\(note.title ?? "")\n\n", attributes: firstAttributes)
      let secondString = NSAttributedString(string: "\(note.created_time?.getDateStringFromUTC() ?? "")\n\n", attributes: secondAttributes)
      let thirdString = try NSAttributedString(markdown: note.body ?? "")//NSAttributedString(string: note.body ?? "", attributes: thirdAttributes))

      firstString.append(secondString)
      firstString.append(thirdString)
      contentLabel.attributedText = firstString
      contentLabel.numberOfLines = 0

      if isContainsAttachment, let imageData = note.image_data {
        attachedImage.image = UIImage(data: imageData)
      }
    } catch {

    }
  }

  private var isContainsAttachment: Bool {
    guard let note = note else {
      return false
    }
    return note.image != nil
  }

  @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
    navigationController?.pushViewController(NotesImageViewController(noteId: noteId, currentImage: attachedImage.image!), animated: false)
  }

  @objc func backButtonPressed() {
    navigationController?.popViewController(animated: false)
  }
}
