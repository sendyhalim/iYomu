//
//  ChapterPageCell.swift
//  Yomu
//
//  Created by Sendy Halim on 6/26/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit
import RxSwift

class ChapterPageCell: UICollectionViewCell {
  @IBOutlet weak var chapterPageImageView: UIImageView!

  var disposeBag = DisposeBag()

  override func prepareForReuse() {
    super.prepareForReuse()

    // Reset image and request to prevent race conditions when cell is reused
    disposeBag = DisposeBag()
    chapterPageImageView.image = .none
  }

  func setup(viewModel: ChapterPageViewModel) {
    viewModel
      .imageUrl
      .drive(onNext: { [weak self] in
        self?.chapterPageImageView.kf.setImage(with: $0)
      })
      .addDisposableTo(disposeBag)
  }
}
