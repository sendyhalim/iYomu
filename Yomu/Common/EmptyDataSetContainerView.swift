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
  private var _loadingView: UIView?

  var collectionView: UICollectionView?
  var loadingView: UIView? {
    get {
      return _loadingView
    }

    set {
      _loadingView?.removeFromSuperview()
      _loadingView = newValue
      _loadingView!.frame = frame
      _loadingView!.isHidden = true
      addSubview(_loadingView!)
    }
  }

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
    loadingView?.isHidden = true
    emptyView?.isHidden = false
  }

  func showCollectionView() {
    collectionView?.isHidden = false
    loadingView?.isHidden = true
    emptyView?.isHidden = true
  }

  func showLoadingView() {
    collectionView?.isHidden = true
    loadingView?.isHidden = false
    emptyView?.isHidden = true
  }
}
