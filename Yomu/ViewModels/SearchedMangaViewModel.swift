//
//  SearchedMangaViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 6/4/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import RxCocoa
import RxSwift

struct SearchedMangaViewModel {
  // MARK: Output
  let previewUrl: Driver<URL>
  let title: Driver<String>
  let apiId: Driver<String>

  // MARK: Private
  fileprivate let manga: Variable<SearchedManga>

  init(manga: SearchedManga) {
    self.manga = Variable(manga)

    previewUrl = self.manga
      .asDriver()
      .map { $0.image.url }

    title = self.manga
      .asDriver()
      .map { $0.name }

    apiId = self.manga
      .asDriver()
      .map { $0.apiId }
  }
}
