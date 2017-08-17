//
//  SearchedMangaCell.swift
//  Yomu
//
//  Created by Sendy Halim on 6/8/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit
import Hue
import Kingfisher
import RxSwift

class SearchedMangaCell: UITableViewCell {
  @IBOutlet weak var previewImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  @IBOutlet weak var accessoryLabel: UILabel!

  var viewModel: SearchedMangaViewModel!
  var disposeBag = DisposeBag()

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

  func setup(viewModel: SearchedMangaViewModel) {
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

    viewModel
      .categoryLabelColorHex
      .map(UIColor.init(hex:))
      .drive(onNext: { [weak self] in
        self?.accessoryLabel.textColor = $0
      })
      .addDisposableTo(disposeBag)
  }
}
