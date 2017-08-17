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
  let categoryLabelColorHex: Driver<String>

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

    categoryLabelColorHex = Driver.just(Database.exists(mangaId: self.manga.value.apiId))
      .map {
        $0 ? "#DDDDDD" : "#3083FB"
      }
  }

  func existsInDb() -> Bool {
    return Database.exists(mangaId: manga.value.apiId)
  }
}
