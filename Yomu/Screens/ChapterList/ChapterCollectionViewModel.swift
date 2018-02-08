//
//  ChapterCollectionViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 6/24/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import RxMoya
import RxSwift
import RxCocoa
import Swiftz

enum SortOrder {
  case ascending
  case descending
}

struct ChapterCollectionViewModel {
  // MARK: Public
  var count: Int {
    return _filteredChapters.value.count
  }

  var isEmpty: Bool {
    return count == 0
  }

  var ordering: SortOrder {
    return _ordering.value
  }

  // MARK: Input
  let filterPattern = PublishSubject<String>()
  let toggleSort = PublishSubject<Void>()

  // MARK: Output
  let reload: Driver<Void>
  let fetching: Driver<Bool>
  let disposeBag = DisposeBag()
  let title: Driver<String>
  let sortOrder: Driver<SortOrder>

  // MARK: Private
  fileprivate let mangaId: String
  fileprivate let _chapters = Variable(List<ChapterViewModel>())
  fileprivate let _filteredChapters = Variable(List<ChapterViewModel>())
  fileprivate let _fetching = Variable(false)
  fileprivate let _ordering = Variable(SortOrder.descending)
  fileprivate let _title = Variable("")

  init(mangaId: String) {
    self.mangaId = mangaId
    let chapters = self._chapters
    let filteredChapters = self._filteredChapters
    let _ordering = self._ordering

    fetching = _fetching.asDriver()
    title = _title.asDriver()
    sortOrder = _ordering.asDriver()

    chapters
      .asObservable()
      .bind(to: _filteredChapters)
      .disposed(by: disposeBag)

    reload = _filteredChapters
      .asDriver()
      .map { _ in () }

    // MARK: Filtering chapters
    filterPattern
      .flatMap { pattern -> Observable<List<ChapterViewModel>> in
        let chaptersObservable = chapters.asObservable()

        if pattern.isEmpty {
          return chaptersObservable
        }

        return chaptersObservable.map { chaptersList in
          chaptersList.filter {
            $0.chapterNumberMatches(pattern: pattern)
          }
        }
      }
      .bind(to: _filteredChapters)
      .disposed(by: disposeBag)

    // MARK: Sorting chapters
    toggleSort
      .map {
        _ordering.value == .descending ? .ascending : .descending
      }
      .bind(to: _ordering)
      .disposed(by: disposeBag)

    _ordering
      .asObservable()
      .map { order in
        // We cannot use (>) because the (>)'s arguments ordering in
        // sort method need to be flipped too, the easiest way is to flip it
        order == .ascending ? curry(<) : flip(curry(<))
      }
      .map { (compare: @escaping (Int) -> (Int) -> Bool) in
        let sorted = filteredChapters.value.sorted {
          let (left, right) = ($0, $1)

          return compare(left.chapter.number)(right.chapter.number)
        }

        return List(fromArray: sorted)
      }
      .bind(to: _filteredChapters)
      .disposed(by: disposeBag)
  }

  func fetch() -> Disposable {
    let api = MangaEdenAPI.mangaDetail(mangaId)
    let request = MangaEden.request(api).share()

    let fetchingDisposable = request
      .map(const(false))
      .startWith(true)
      .asDriver(onErrorJustReturn: false)
      .drive(_fetching)

    let parseMangaTitleDisposable = request
      .filterSuccessfulStatusCodes()
      .map(Manga.self)
      .map { $0.title }
      .bind(to: _title)

    let parseChaptersDisposable = request
      .filterSuccessfulStatusCodes()
      .mapArray(Chapter.self, withRootKey: "chapters")
      .map {
        $0.map(ChapterViewModel.init)
      }
      .map(List<ChapterViewModel>.init)
      .bind(to: _chapters)

    return CompositeDisposable(fetchingDisposable, parseChaptersDisposable, parseMangaTitleDisposable)
  }

  subscript(index: Int) -> ChapterViewModel {
    return _filteredChapters.value[UInt(index)]
  }
}

struct ChapterNavigator {
  let collection: ChapterCollectionViewModel
  var currentIndex: Int

  init(collection: ChapterCollectionViewModel, currentIndex: Int) {
    self.collection = collection
    self.currentIndex = currentIndex
  }

  func previous() -> (ChapterNavigator, ChapterViewModel)? {
    if collection.ordering == .descending {
      guard let vm = peekNext() else {
        return nil
      }

      return (
        ChapterNavigator(collection: collection, currentIndex: currentIndex + 1),
        vm
      )
    } else {
      guard let vm = peekPrevious() else {
        return nil
      }

      return (
        ChapterNavigator(collection: collection, currentIndex: currentIndex - 1),
        vm
      )
    }
  }

  func next() -> (ChapterNavigator, ChapterViewModel)? {
    if collection.ordering == .descending {
      guard let vm = peekPrevious() else {
        return nil
      }

      return (
        ChapterNavigator(collection: collection, currentIndex: currentIndex - 1),
        vm
      )
    } else {
      guard let vm = peekNext() else {
        return nil
      }

      return (
        ChapterNavigator(collection: collection, currentIndex: currentIndex + 1),
        vm
      )
    }
  }

  func peekPrevious() -> ChapterViewModel? {
    let previousIndex = currentIndex - 1

    guard previousIndex > -1 else {
      return nil
    }

    return collection[previousIndex]
  }

  func peekNext() -> ChapterViewModel? {
    let nextIndex = currentIndex + 1

    guard nextIndex < collection.count else {
      return nil
    }

    return collection[nextIndex]
  }
}
