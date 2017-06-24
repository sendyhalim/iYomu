//
//  ChapterCell.swift
//  Yomu
//
//  Created by Sendy Halim on 6/24/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit
import RxSwift

class ChapterCell: UITableViewCell {
  @IBOutlet weak var chapterImagePreview: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var chapterNumberLabel: UILabel!

  var viewModel: ChapterViewModel!
  var disposeBag = DisposeBag()

  func setup(viewModel: ChapterViewModel) {
    self.viewModel = viewModel

    disposeBag = DisposeBag()

    viewModel
      .title
      .drive(titleLabel.rx.text)
      .addDisposableTo(disposeBag)

    viewModel
      .previewUrl
      .drive(onNext: { [weak self] in
        self?.chapterImagePreview.kf.setImage(with: $0)
      })
      .addDisposableTo(disposeBag)

    viewModel
      .number
      .drive(chapterNumberLabel.rx.text)
      .addDisposableTo(disposeBag)
  }
}
