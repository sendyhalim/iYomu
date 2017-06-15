//
//  MangaViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 6/16/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import RxCocoa
import RxSwift

struct MangaViewModel {
  // MARK: Output
  let previewUrl: Driver<URL>
  let title: Driver<String>
  let categoriesString: Driver<String>

  // MARK: Private
  fileprivate let _manga: Variable<Manga>

  init(manga: Manga) {
    _manga = Variable(manga)

    previewUrl = _manga
      .asDriver()
      .map { $0.image.url }

    title = _manga
      .asDriver()
      .map { $0.title }

    categoriesString = _manga
      .asDriver()
      .map {
        $0.categories.joined(separator: ", ")
    }
  }
}
