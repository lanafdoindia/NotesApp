//
//  NotesCollectionViewLayout.swift
//  NotesApp
//
//  Created by Lana Fernando S on 9/14/22.
//

import UIKit

protocol NotesLayoutDelegate: AnyObject {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class NotesLayout: UICollectionViewLayout {

  weak var delegate: NotesLayoutDelegate?

  public var isRefresh = false
  private var numberOfColumns = 2
  private let cellPadding: CGFloat = 6

  private var cache: [UICollectionViewLayoutAttributes] = []

  private var contentHeight: CGFloat = 0

  private var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }

  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }

  override func prepare() {
    guard
      cache.isEmpty == true || isRefresh,
      let collectionView = collectionView
      else {
        return
    }
//    let columnWidth = contentWidth / CGFloat(numberOfColumns)
//    var xOffset: [CGFloat] = []
//    for column in 0..<numberOfColumns {
//      xOffset.append(CGFloat(column) * columnWidth)
 //   }
    numberOfColumns = 2
    cache = []
    isRefresh = false
    var column = 0
    var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)

    //var column = 0
    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      let isImageAvailable = CoreDataService.instance.notes[item].image != nil
      if isImageAvailable {
        numberOfColumns = 1
        column = 0
      } else {
        numberOfColumns = 2
      }

      let columnWidth = contentWidth / CGFloat(numberOfColumns)
      var xOffset: [CGFloat] = []
      for column in 0..<numberOfColumns {
        xOffset.append(CGFloat(column) * columnWidth)
      }

      let indexPath = IndexPath(item: item, section: 0)

      let photoHeight = delegate?.collectionView(
        collectionView,
        heightForPhotoAtIndexPath: indexPath) ?? 180
      let height = cellPadding * 2 + photoHeight
      let frame = CGRect(x: xOffset[column],
                         y: yOffset[column],
                         width: columnWidth,
                         height: height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)

      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] = yOffset[column] + height
      if isImageAvailable {
        yOffset[1] = yOffset[0]
      }

      column = column < (numberOfColumns - 1) ? (column + 1) : 0
    }
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

    // Loop through the cache and look for items in the rect
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
}
