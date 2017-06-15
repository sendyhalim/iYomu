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
  var manga: Manga {
    return _manga.value
  }

  var id: String {
    return _manga.value.id!
  }

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

  func update(position: Int) {
    _manga.value.position = position
  }
}

extension MangaViewModel: Hashable {
  var hashValue: Int {
    return _manga.value.id!.hashValue
  }
}

extension MangaViewModel: Equatable { }

func == (lhs: MangaViewModel, rhs: MangaViewModel) -> Bool {
  return lhs._manga.value.id == rhs._manga.value.id
}
