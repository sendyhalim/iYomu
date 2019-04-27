//
//  FetchableDataSetContainerView.swift
//  Yomu
//
//  Created by Sendy Halim on 28/04/19.
//  Copyright © 2019 Sendy Halim. All rights reserved.
//
import UIKit

class FetchableDataSetContainerView: UIView {
  private var _loadingView: UIView?
  var collectionView: UIView?

  var loadingView: UIView? {
    get {
      return _loadingView
    }

    set {
      _loadingView?.removeFromSuperview()
      _loadingView = newValue
      _loadingView!.frame = self.frame
      _loadingView!.isHidden = true

      self.addSubview(_loadingView!)
    }
  }

  func showLoadingView() {
    loadingView?.isHidden = false
    collectionView?.isHidden = true
  }

  func showCollectionView() {
    collectionView?.isHidden = false
    loadingView?.isHidden = true
  }
}
