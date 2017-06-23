//
//  MangaCell.swift
//  Yomu
//
//  Created by Sendy Halim on 6/14/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit
import RxSwift

class MangaCell: UITableViewCell {
  @IBOutlet weak var previewImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!

  var viewModel: MangaViewModel!
  var disposeBag = DisposeBag()

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
}
