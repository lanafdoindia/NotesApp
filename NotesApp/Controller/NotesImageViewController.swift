//
//  NotesImageViewController.swift
//  NotesApp
//
//  Created by Lana Fernando S on 9/14/22.
//

import UIKit

class NotesImageViewController: BaseViewController {

  var backButton = AppNavbarButton()
  var scrollView = UIScrollView()
  var previewImage = UIImageView()

  var imageTrailingConstr: NSLayoutConstraint!
  var imageLeadingConstr: NSLayoutConstraint!
  var imageTopConstr: NSLayoutConstraint!
  var imageBottomConstr: NSLayoutConstraint!
  var imageHeightConstr: NSLayoutConstraint!

  var imageData: [(noteId: String, imageData: Data)] = []
  var noteId: String
  var currentIndex = 0
  var currentImage: UIImage
  var imageHeight: CGFloat = 250

  init(noteId: String, currentImage: UIImage) {
    self.noteId = noteId
    self.currentImage = currentImage
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    imageData = CoreDataService.instance.getAllImage()
    currentIndex = imageData.firstIndex { $0.noteId == noteId } ?? 0
    configureView()
    setGesture()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    //scaleForImageSize(view.bounds.size)
    //updateImageConstraints(view.bounds.size)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    //scaleForImageSize(view.bounds.size)
    //updateImageConstraints(view.bounds.size)
  }

  private func configureView() {
    backButton.setButtonImage(withSymbol: "chevron.backward")
    backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    view.addSubview(backButton)
    scrollView.addSubview(previewImage)
    view.addSubview(scrollView)
    //scrollView.contentLayoutGuide = UILayoutGuide.
    previewImage.contentMode = .scaleToFill
    setConstraint()
    previewImage.image = currentImage
    previewImage.frame = CGRect(x: self.previewImage.frame.origin.x, y: self.previewImage.frame.origin.y, width: currentImage.size.width, height: currentImage.size.height)
  }

  private func setConstraint() {

    backButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
      backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25.0),
      backButton.heightAnchor.constraint(equalToConstant: 35),
      backButton.widthAnchor.constraint(equalToConstant: 35)
    ])

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
    ])

    previewImage.translatesAutoresizingMaskIntoConstraints = false
    imageTopConstr = previewImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0)
    imageBottomConstr = previewImage.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
    imageLeadingConstr = previewImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0)
    imageTrailingConstr = previewImage.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
    //imageCenterConstr = previewImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)

    NSLayoutConstraint.activate([
      previewImage.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -30),
      previewImage.heightAnchor.constraint(equalToConstant: 250.0),
      //imageTopConstr,
      //imageBottomConstr,
      imageLeadingConstr,
      imageTrailingConstr
    ])
  }

  @objc func backButtonPressed() {
    navigationController?.popViewController(animated: false)
  }

  private func setGesture() {
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
    swipeRight.direction = UISwipeGestureRecognizer.Direction.right
    self.view.addGestureRecognizer(swipeRight)

    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
    swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
    self.view.addGestureRecognizer(swipeLeft)

  }

  @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction
      {
      case UISwipeGestureRecognizer.Direction.right:
        if currentIndex > 0 {
          currentIndex -= 1
          setImage()
        }
      case UISwipeGestureRecognizer.Direction.left:
        if currentIndex < imageData.count - 1 {
          currentIndex += 1
          setImage()
        }
      default:
        break
      }
    }
  }

  private func setImage() {
    if imageData.count > 0 {
      previewImage.image = UIImage(data: imageData[currentIndex].imageData)
    }
  }

  private func scaleForImageSize(_ size: CGSize) {
    let widthScale = size.width / previewImage.bounds.width
    let heightScale = size.height / imageHeight
    let minScale = min(widthScale, heightScale)
    scrollView.minimumZoomScale = minScale
    scrollView.zoomScale = minScale
    scrollView.maximumZoomScale = minScale * 4
  }

  private func updateImageConstraints(_ size: CGSize) {
    let yOffset = max(0,(size.height - imageHeight) / 2)
    imageTopConstr.constant = yOffset
    imageBottomConstr.constant = yOffset

    let xOffset = max(0, (size.width - previewImage.frame.width) / 2)
    imageLeadingConstr.constant = xOffset
    imageTrailingConstr.constant = xOffset

    let contentHeight = yOffset * 2 + imageHeight
    view.layoutIfNeeded()
    self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: contentHeight)
  }
}
