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
  let heightToWidthRatio: Double

  // MARK: Private
  fileprivate let chapterPage: Variable<ChapterPage>

  init(page: ChapterPage) {
    chapterPage = Variable(page)
    heightToWidthRatio = Double(page.height) / Double(page.width)

    imageUrl = chapterPage
      .asDriver()
      .map { $0.image.url }
  }

  func maxSize(maxWidth: Double, zoomScale: Double) -> Size {
    return Size(
      width: maxWidth * zoomScale,
      height: heightToWidthRatio * maxWidth * zoomScale
    )
  }
}
