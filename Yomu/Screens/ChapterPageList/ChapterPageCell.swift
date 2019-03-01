//
//  ChapterPageCell.swift
//  Yomu
//
//  Created by Sendy Halim on 24/02/19.
//  Copyright © 2019 Sendy Halim. All rights reserved.
//

import UIKit
import RxSwift

class ChapterPageCell: UICollectionViewCell {
  @IBOutlet weak var chapterPageImageView: UIImageView!

  var disposeBag = DisposeBag()

  override func awakeFromNib() {
    super.awakeFromNib()

    chapterPageImageView.kf.indicatorType = .activity
  }

  func setup(viewModel: ChapterPageViewModel) {
    viewModel
      .imageUrl
      .drive(onNext: { [weak self] in
        self?.chapterPageImageView.kf.setImage(with: $0)
      })
      .disposed(by: disposeBag)
  }
}
