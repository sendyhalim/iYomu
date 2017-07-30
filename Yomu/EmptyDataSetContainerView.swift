//
//  EmptyDataSetView.swift
//  Yomu
//
//  Created by Sendy Halim on 7/30/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit

class EmptyDataSetContainerView: UIView {
  private var _emptyView: UIView?

  var collectionView: UICollectionView?
  var emptyView: UIView? {
    get {
      return _emptyView
    }

    set {
      _emptyView?.removeFromSuperview()
      _emptyView = newValue
      _emptyView!.frame = frame
      _emptyView!.isHidden = true
      addSubview(_emptyView!)
    }
  }

  func showEmptyDataSetView() {
    collectionView?.isHidden = true
    emptyView?.isHidden = false
  }

  func hideEmptyDataSetView() {
    collectionView?.isHidden = false
    emptyView?.isHidden = true
  }
}
