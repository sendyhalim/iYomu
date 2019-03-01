import Foundation
import UIKit

protocol ZoomableCollectionViewLayoutDelegate: class {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
    ) -> CGSize
}

class ZoomableCollectionViewLayout: UICollectionViewFlowLayout {
  weak var delegate: ZoomableCollectionViewLayoutDelegate?

  let cellPadding: CGFloat = 8
  var contentSize: CGSize = .zero
  var cellLayoutAttributes = [UICollectionViewLayoutAttributes]()

  override var collectionViewContentSize: CGSize {
    return contentSize
  }

  override func prepare() {
    guard
      let collectionView = collectionView,
      let delegate = delegate else {
        return
    }

    contentSize = .zero

    var totalWidth: CGFloat = 0
    var totalHeight: CGFloat = 0

    // Clean up previous attributes
    // TODO: Perhaps we could do caching in the future?
    cellLayoutAttributes = []

    for index in 0 ..< collectionView.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(row: index, section: 0)
      let size = delegate.collectionView(collectionView, layout: self, sizeForItemAt: indexPath)

      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      let frame = CGRect(x: 0, y: totalHeight, width: size.width, height: size.height)
      attributes.frame = frame.insetBy(dx: cellPadding, dy: cellPadding)
      cellLayoutAttributes.append(attributes)

      totalWidth = max(totalWidth, size.width)
      totalHeight = totalHeight + size.height
    }

    contentSize = CGSize(width: totalWidth, height: totalHeight)
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return cellLayoutAttributes.filter { attribute in
      return attribute.frame.intersects(rect)
    }
  }
}
