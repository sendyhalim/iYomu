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

  override func awakeFromNib() {
    super.awakeFromNib()

    chapterImagePreview.kf.indicatorType = .activity
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    // Reset image and request to prevent race conditions when cell is reused
    chapterImagePreview.image = .none
    disposeBag = DisposeBag()
  }

  func setup(viewModel: ChapterViewModel) {
    self.viewModel = viewModel

    disposeBag = DisposeBag()

    self.viewModel
      .title
      .drive(titleLabel.rx.text)
      .disposed(by: disposeBag)

   self.viewModel
      .previewUrl()
      .drive(onNext: { [weak self] in
        self?.chapterImagePreview.kf.setImage(with: $0)
      })
      .disposed(by: disposeBag)

   self.viewModel
      .number
      .drive(chapterNumberLabel.rx.text)
      .disposed(by: disposeBag)

   self.viewModel
      .readColorString
      .drive(onNext: { [weak self] in
        self?.titleLabel.textColor = UIColor(hex: $0)
      })
      .disposed(by: disposeBag)
  }
}
