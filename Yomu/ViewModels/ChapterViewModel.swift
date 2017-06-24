//
//  ChapterViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 6/24/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import RxCocoa
import RxMoya
import RxSwift

struct ChapterViewModel {
  // MARK: Public
  var chapter: Chapter {
    return _chapter.value
  }

  // MARK: Output
  let title: Driver<String>
  let number: Driver<String>

  // MARK: Private
  private let _chapter: Variable<Chapter>

  init(chapter: Chapter) {
    _chapter = Variable(chapter)

    number = _chapter
      .asDriver()
      .map { "Chapter \($0.number.description)" }

    title = _chapter
      .asDriver()
      .map { $0.title }
  }

  func chapterNumberMatches(pattern: String) -> Bool {
    return _chapter.value.number.description.lowercased().contains(pattern)
  }

  func previewUrl() -> Driver<URL> {
    return MangaEden
      .request(MangaEdenAPI.chapterPages(_chapter.value.id))
      .mapArray(ChapterPage.self, withRootKey: "images")
      .map { chapters in
        chapters
          .sorted {
            let (x, y) = $0

            return x.number < y.number
          }
          .first!
          .image
      }
      .asDriver(onErrorJustReturn: ImageUrl(endpoint: ""))
      .filter { $0.endpoint.characters.count != 0 }
      .map { $0.url }
  }
}
