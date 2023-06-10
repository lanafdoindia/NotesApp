//
//  ViewController.swift
//  NotesApp
//
//  Created by Lana Fernando S on 9/12/22.
//

import UIKit
import Combine

class HomeViewController: BaseViewController {

  fileprivate var collectionView: UICollectionView!
  fileprivate var createButton = UIButton()
  fileprivate var titleLabel = UILabel()

  fileprivate let viewModel = NotesViewModel()
  private var bindings = Set<AnyCancellable>()

  override func viewDidLoad() {
    super.viewDidLoad()
    setSubscription()
    viewModel.fetchNotes()
    addSubView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  private func addSubView() {
    let notesLayout = NotesLayout.init()
    notesLayout.delegate = self
    collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: notesLayout)
    collectionView.backgroundColor = .clear
    collectionView.dataSource = self
    collectionView.delegate = self
    view.addSubview(titleLabel)
    view.addSubview(collectionView)
    view.addSubview(createButton)
    collectionView.register(NotesCollectionViewCell.self, forCellWithReuseIdentifier: NotesCollectionViewCell.identifier)
    configureView()
    setConstraints()
  }

  func configureView() {
    titleLabel.attributedText = NSAttributedString(string: "Notes", attributes: [.font: UIFont.systemFont(ofSize: 35, weight: .semibold), .foregroundColor: UIColor.white])
    createButton.setImage(UIImage(systemName: "plus"), for: .normal)
    createButton.layer.cornerRadius = 25
    createButton.tintColor = .white
    createButton.backgroundColor = .black
    createButton.addTarget(self, action: #selector(onCreateClick), for: .touchUpInside)
  }

  @objc private func onCreateClick() {
    self.navigationController?.pushViewController(NotesCreateViewController(), animated: false)
  }

  private func setConstraints() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    createButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15.0),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5.0),

      collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0),
      collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:  0),
      collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),

      createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15.0),
      createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15.0),
      createButton.heightAnchor.constraint(equalToConstant: 50.0),
      createButton.widthAnchor.constraint(equalToConstant: 50.0)
    ])
  }

  private func setSubscription() {
    CoreDataService.instance.$notes.receive(on: DispatchQueue.main).sink { [weak self] _ in
      //self?.collectionView.collectionViewLayout.invalidateLayout()
      if let layout = self?.collectionView.collectionViewLayout as? NotesLayout {
        layout.isRefresh = true
      }
      self?.collectionView.reloadData()
    }.store(in: &bindings)
  }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return CoreDataService.instance.notes.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotesCollectionViewCell.identifier, for: indexPath) as! NotesCollectionViewCell
    cell.model = CoreDataService.instance.notes[indexPath.item]
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
    return CGSize(width: itemSize, height: itemSize)
  }
}

extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedNote = CoreDataService.instance.notes[indexPath.item]
    self.navigationController?.pushViewController(NotesViewController(noteId: selectedNote.id ?? "", currentIndex: indexPath.item), animated: false)
  }
}

extension HomeViewController: NotesLayoutDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
      let note = CoreDataService.instance.notes[indexPath.item]
      return CGFloat( 50 + (note.title?.count ?? 1) *  (note.image != nil ? 4 : 6))
  }
}

