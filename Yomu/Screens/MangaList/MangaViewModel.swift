//
//  MangaViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 6/16/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import RxCocoa
import RxSwift
import class RealmSwift.Realm
import RxRealm

struct MangaViewModel {
  var manga: Manga {
    return _manga.value
  }

  var id: String {
    return _manga.value.id!
  }

  // MARK: Output
  var previewUrl: Driver<URL> {
    return _manga
      .asDriver()
      .map { $0.image.url  }
  }

  var title: Driver<String> {
    return _manga
      .asDriver()
      .map { $0.title }
  }

  var categoriesString: Driver<String> {
    return _manga
      .asDriver()
      .map {
        $0.categories.joined(separator: ", ")
      }
  }

  var author: Driver<String> {
    return _manga
      .asDriver()
      .map { $0.author }
  }

  var releasedYear: Driver<String> {
    return _manga
      .asDriver()
      .map {
        $0.releasedYear == nil ? "-" : "\($0.releasedYear!)"
      }
  }

  var plot: Driver<String> {
    return _manga
      .asDriver()
      .map { $0.plot }
  }

  let disposeBag = DisposeBag()

  // MARK: Private
  fileprivate let _manga: Variable<Manga>

  init(manga: Manga) {
    _manga = Variable(manga)

    _manga
      .asDriver()
      .map(MangaRealm.from)
      .drive(Realm.rx.add(update: true))
      .disposed(by: disposeBag)
 }

  func update(position: Int) {
    _manga.value.position = position
  }
}

extension MangaViewModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(_manga.value.id!)
  }
}

extension MangaViewModel: Equatable { }

func == (lhs: MangaViewModel, rhs: MangaViewModel) -> Bool {
  return lhs._manga.value.id == rhs._manga.value.id
}
