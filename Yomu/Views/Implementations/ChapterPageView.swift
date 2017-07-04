//
//  ChapterPageCell.swift
//  Yomu
//
//  Created by Sendy Halim on 6/26/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit
import RxSwift

class ChapterPageView: UIView {
  @IBOutlet weak var chapterPageImageView: UIImageView!

  var disposeBag = DisposeBag()

  func setup(viewModel: ChapterPageViewModel) {
    viewModel
      .imageUrl
      .drive(onNext: { [weak self] in
        self?.chapterPageImageView.kf.setImage(with: $0)
      })
      .addDisposableTo(disposeBag)
  }
}
