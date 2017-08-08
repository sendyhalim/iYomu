//
//  MangaCell.swift
//  Yomu
//
//  Created by Sendy Halim on 6/14/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit
import EasyAnimation
import RxSwift

class MangaCell: UICollectionViewCell {
  @IBOutlet weak var contentContainerView: UIView!
  @IBOutlet weak var previewImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  @IBOutlet weak var deleteButton: UIButton!

  var viewModel: MangaViewModel!
  var disposeBag = DisposeBag()
  var deleteButtonIsShown = false
  let swipeAnimationDuration = 0.5

  override func prepareForReuse() {
    super.prepareForReuse()

    // Reset image and request to prevent race conditions when cell is reused
    previewImage.image = .none
    disposeBag = DisposeBag()
  }

  func setup(viewModel: MangaViewModel) {
    self.viewModel = viewModel

    disposeBag = DisposeBag()

    viewModel
      .title
      .drive(titleLabel.rx.text)
      .addDisposableTo(disposeBag)

    viewModel
      .previewUrl
      .drive(onNext: { [weak self] in
        self?.previewImage.kf.setImage(with: $0)
      })
      .addDisposableTo(disposeBag)

    viewModel
      .categoriesString
      .drive(categoriesLabel.rx.text)
      .addDisposableTo(disposeBag)
  }

  func onSwipe(gesture: UISwipeGestureRecognizer) {
    if gesture.direction == .left {
      onSwipeLeft(gesture: gesture)
    } else {
      onSwipeRight(gesture: gesture)
    }
  }

  func onSwipeLeft(gesture: UISwipeGestureRecognizer) {
    guard !deleteButtonIsShown else {
      return
    }

    let deleteButtonWidth = deleteButton.bounds.width

    UIView.animate(
      withDuration: swipeAnimationDuration,
      delay: 0,
      usingSpringWithDamping: 0.75,
      initialSpringVelocity: 0,
      options: [.curveEaseIn],
      animations: { [weak self] in
        self?.contentContainerView.layer.position.x -= deleteButtonWidth
        self?.deleteButtonIsShown = true
      }
    )
  }

  func onSwipeRight(gesture: UISwipeGestureRecognizer) {
    guard deleteButtonIsShown else {
      return
    }

    let deleteButtonWidth = deleteButton.bounds.width

    UIView.animate(
      withDuration: swipeAnimationDuration,
      delay: 0,
      usingSpringWithDamping: 0.75,
      initialSpringVelocity: 0,
      options: [.curveEaseIn],
      animations: { [weak self] in
        self?.contentContainerView.layer.position.x += deleteButtonWidth
        self?.deleteButtonIsShown = false
      }
    )
  }
}
