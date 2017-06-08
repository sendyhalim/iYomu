//
//  SearchedMangaCell.swift
//  Yomu
//
//  Created by Sendy Halim on 6/8/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

class SearchedMangaCell: UITableViewCell {
  @IBOutlet weak var previewImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!

  var viewModel: SearchedMangaViewModel!
  var disposeBag = DisposeBag()

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
      .categories
      .drive(categoriesLabel.rx.text)
      .addDisposableTo(disposeBag)
  }
}
