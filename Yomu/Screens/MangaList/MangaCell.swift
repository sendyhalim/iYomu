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

protocol MangaCellDelegate: class {
  func deleteButtonClicked(mangaViewModel: MangaViewModel)
}

class MangaCell: UICollectionViewCell {
  @IBOutlet weak var contentContainerView: UIView!
  @IBOutlet weak var previewImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  @IBOutlet weak var deleteButton: UIButton!

  weak var delegate: MangaCellDelegate?
  var viewModel: MangaViewModel!
  var disposeBag = DisposeBag()
  var deleteButtonIsShown = false
  let swipeAnimationDuration = 0.5

  override func awakeFromNib() {
    super.awakeFromNib()

    previewImage.kf.indicatorType = .activity
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    // Reset image and request to prevent race conditions when cell is reused
    previewImage.image = .none
    disposeBag = DisposeBag()
  }

  func setup(viewModel: MangaViewModel) {
    self.viewModel = viewModel

    disposeBag = DisposeBag()

    deleteButton
      .rx.tap
      .subscribe(onNext: { [weak self] in
        self?.hideDeleteButton(duration: 0)
        self?.delegate?.deleteButtonClicked(mangaViewModel: viewModel)
      })
      .disposed(by: disposeBag)

    viewModel
      .title
      .drive(titleLabel.rx.text)
      .disposed(by: disposeBag)

   viewModel
      .previewUrl
      .drive(onNext: { [weak self] in
        self?.previewImage.kf.setImage(with: $0)
      })
      .disposed(by: disposeBag)

    viewModel
      .categoriesString
      .drive(categoriesLabel.rx.text)
      .disposed(by: disposeBag)
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

    hideDeleteButton(duration: swipeAnimationDuration)
  }

  func hideDeleteButton(duration: Double) {
    let deleteButtonWidth = deleteButton.bounds.width

    UIView.animate(
      withDuration: duration,
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
