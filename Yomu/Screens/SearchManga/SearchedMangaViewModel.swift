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
  let categoriesString: Driver<String>
  let title: Driver<String>
  let apiId: Driver<String>
  let bookmarked: Driver<Bool>

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

    categoriesString = self.manga
      .asDriver()
      .map { $0.categories.joined(separator: ", ") }

    // NOTE: Are we doing this on the main thread?
    bookmarked = Driver.just(Database.exists(mangaId: self.manga.value.apiId))
  }

  func existsInDb() -> Bool {
    return Database.exists(mangaId: manga.value.apiId)
  }
}
