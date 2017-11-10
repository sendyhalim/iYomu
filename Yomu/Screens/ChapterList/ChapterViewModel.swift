//
//  ChapterViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 6/24/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import class RealmSwift.Realm
import RxCocoa
import RxMoya
import RxRealm
import RxSwift

struct ChapterViewModel {
  // MARK: Public
  var chapter: Chapter {
    return _chapter.value
  }

  // MARK: Output
  let title: Driver<String>
  let number: Driver<String>

  lazy var readColorString: Driver<String> = {
    let readColor = "#A0A0A0"
    let unreadColor = "#000000"
    let read = self.read

    if !read.value {
      read.value = Database.exists(readChapterId: self._chapter.value.id)
    }

    return read
      .asDriver()
      .map {
        $0 ? readColor : unreadColor
      }
  }()

  // MARK: Private
  private let _chapter: Variable<Chapter>
  private let read = Variable<Bool>(false)
  private let disposeBag = DisposeBag()

  init(chapter: Chapter) {
    _chapter = Variable(chapter)

    title = _chapter
      .asDriver()
      .map { $0.title }

    number = _chapter
      .asDriver()
      .map { "Chapter \($0.number)" }
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
            let (x, y) = ($0, $1)

            return x.number < y.number
          }
          .first!
          .image
      }
      .asDriver(onErrorJustReturn: ImageUrl(endpoint: ""))
      .filter { $0.endpoint.count != 0 }
      .map { $0.url }
  }

  func markAsRead() -> Disposable {
    read.value = true

    return Observable
      .just(ReadChapterRealm.from(chapter: chapter))
      .subscribe(Realm.rx.add(update: true))
  }
}
