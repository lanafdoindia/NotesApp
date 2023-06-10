//
//  NotesCreateViewController.swift
//  NotesApp
//
//  Created by Lana Fernando S on 9/12/22.
//

import UIKit
import Combine

protocol NotesCreateProtocol {
  func onClickedAttach()
  func onClickedSave()
  func onClickedBack()
}

class NotesCreateViewController: BaseViewController {

  private var titleTxt = UITextField()
  private var bodyTxt = UITextView()

  private var viewModel = NotesCreateViewModel()
  private var headerView = NotesCreateHeaderView()

  var selectedImage: UIImage?

  private var bindings = Set<AnyCancellable>()

  override func viewDidLoad() {
    super.viewDidLoad()
    addSubView()
  }

  private func addSubView() {
    view.addSubview(titleTxt)
    view.addSubview(bodyTxt)
    configureHeaderView()
    configureView()
    setConstraints()
    setupSubscription()
  }

  private func setupSubscription() {
    //headerView.saveBtn.isEnabled = false
    titleTxt.textPublisher.receive(on: DispatchQueue.main).assign(to: \.title, on: viewModel).store(in: &bindings)
    viewModel.isInputValid.receive(on: DispatchQueue.main).assign(to: \.isEnabledButton, on: headerView.saveBtn).store(in: &bindings)
  }
  
  private func configureView() {
    titleTxt.translatesAutoresizingMaskIntoConstraints = false
    titleTxt.attributedPlaceholder = NSAttributedString(
        string: "Title",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
    )
    titleTxt.textColor = .white
    titleTxt.font = titleTxt.font?.withSize(30.0)
    bodyTxt.translatesAutoresizingMaskIntoConstraints = false
    bodyTxt.backgroundColor = .clear
    bodyTxt.textColor = .white
    bodyTxt.text = "Type something..."
    bodyTxt.textColor = UIColor.lightGray
    bodyTxt.delegate = self
  }

  private func configureHeaderView() {
    view.addSubview(headerView)
    headerView.delegate = self

    headerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5.0),
      headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5.0),
      headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5.0),
      headerView.heightAnchor.constraint(equalToConstant: 60)
    ])
  }

  private func setConstraints() {
    NSLayoutConstraint.activate([
      titleTxt.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15.0),
      titleTxt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.0),
      titleTxt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5.0),

      bodyTxt.topAnchor.constraint(equalTo: titleTxt.bottomAnchor, constant: 5.0),
      bodyTxt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.0),
      bodyTxt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5.0),
      bodyTxt.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 5.0),
    ])
  }
}

extension NotesCreateViewController: NotesCreateProtocol {
  func onClickedAttach() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: false)
  }

  func onClickedSave() {
    CoreDataService.instance.addData(title: titleTxt.text ?? "", body: bodyTxt.text, attachment: selectedImage)
    self.navigationController?.popViewController(animated: false)
  }

  func onClickedBack() {
    navigationController?.popViewController(animated: false)
  }
}

extension NotesCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    self.selectedImage = image
    headerView.attachBtn.tintColor = .green
    dismiss(animated: true)
  }
}

extension NotesCreateViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.textColor == UIColor.lightGray {
          textView.text = nil
          textView.textColor = UIColor.white
      }
  }
}
