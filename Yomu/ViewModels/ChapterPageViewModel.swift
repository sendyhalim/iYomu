//
//  ChapterPageViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 6/26/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import RxCocoa
import RxSwift

struct ChapterPageViewModel {
  // MARK: Public
  let imageUrl: Driver<URL>

  // MARK: Private
  fileprivate let chapterPage: Variable<ChapterPage>

  init(page: ChapterPage) {
    chapterPage = Variable(page)

    imageUrl = chapterPage
      .asDriver()
      .map { $0.image.url }
  }
}
