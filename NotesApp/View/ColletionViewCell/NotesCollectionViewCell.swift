//
//  NotesCollectionViewCell.swift
//  NotesApp
//
//  Created by Lana Fernando S on 9/12/22.
//

import UIKit

class NotesCollectionViewCell: UICollectionViewCell {
  static let identifier = "NotesCollectionViewCell"

  var titleLabel = UILabel()
  var createdDateLabel = UILabel()

  var model: Notes? {
    didSet {
      setData()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: .zero)
    contentView.backgroundColor = .random
    addSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func addSubviews() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(createdDateLabel)
    configureView()
    setConstraints()
  }

  private func configureView() {
    contentView.layer.cornerRadius = 5.0
    titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
    titleLabel.numberOfLines = 0
  }

  private func setConstraints() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0)
    ])

    createdDateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      createdDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0),
      createdDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15.0),
      createdDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      createdDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0)
    ])
  }

  private func setData() {
    if let model = model {
      titleLabel.text = model.title ?? ""
      createdDateLabel.text = model.created_time?.getDateStringFromUTC()
      if let imageURL = model.image, model.image_data == nil {
        NotesService.getImage(withImageUrlString: imageURL) { downloadImage in
          guard let downloadImage = downloadImage else {
            return
          }
          CoreDataService.instance.updateNote(withNoteId: model.id ?? "", image: downloadImage)
        }
      }
    }
  }
}
