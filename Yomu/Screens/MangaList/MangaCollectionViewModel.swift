//
//  MangaCollectionViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 6/16/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import OrderedSet
import class RealmSwift.Realm
import RxCocoa
import RxMoya
import RxSwift
import RxRealm
import Swiftz

struct SelectedIndex {
  let previousIndex: Int
  let index: Int
}

struct MangaCollectionViewModel {
  // MARK: Public
  var count: Int {
    return _mangas.value.count
  }

  // MARK: Output
  let fetching: Driver<Bool>
  let showEmptyDataSetLoading: Driver<Void>
  let reload: Driver<Void>

  // MARK: Private
  fileprivate let _selectedIndex = Variable(SelectedIndex(previousIndex: -1, index: -1))
  fileprivate var _fetching = Variable(false)
  fileprivate var _mangas: Variable<OrderedSet<MangaViewModel>> = {
    let mangas = Database
      .queryMangas()
      .sorted {
        $0.position < $1.position
      }
      .map(MangaViewModel.init)

    return Variable(OrderedSet(elements: mangas))
  }()

  fileprivate let deletedManga = PublishSubject<MangaViewModel>()
  fileprivate let addedManga = PublishSubject<MangaViewModel>()
  fileprivate let disposeBag = DisposeBag()

  init() {
    fetching = _fetching.asDriver()
    reload = _mangas
      .asDriver()
      .map { _ in () }

    deletedManga
      .map { manga in
        return Database.queryMangaRealm(id: manga.id)
      }
      .subscribe(Realm.rx.delete())
      .disposed(by: disposeBag)

    addedManga
      .map {
        MangaRealm.from(manga: $0.manga)
      }
      .subscribe(Realm.rx.add(update: true))
      .disposed(by: disposeBag)

    // We want to show empty data set loading view if manga count is 0 and we're in the fetching state
    showEmptyDataSetLoading = Driver
      .combineLatest(
        fetching,
        _mangas.asDriver().map { $0.count == 0 }
      )
      .map {
        $0 && $1
      }
      .filter(identity)
      .map { _ in () }
  }

  subscript(index: Int) -> MangaViewModel {
    return _mangas.value[index]
  }

  func fetch(id: String) -> Disposable {
    let api = MangaEdenAPI.mangaDetail(id)

    let request = MangaEden.request(api).share()
    let newMangaObservable = request
      .filterSuccessfulStatusCodes()
      .map(Manga.self)
      .map {
        var manga = $0
        manga.id = id
        manga.position = self.count

        return MangaViewModel(manga: manga)
      }
      .filter {
        return !self._mangas.value.contains($0)
      }
      .share()

    let fetchingDisposable = request
      .map(const(false))
      .startWith(true)
      .asDriver(onErrorJustReturn: false)
      .drive(_fetching)

    let resultDisposable = newMangaObservable.subscribe(onNext: {
      self.addedManga.on(.next($0))
      self._mangas.value.append(element: $0)
    })

    return CompositeDisposable(fetchingDisposable, resultDisposable)
  }

  func setSelectedIndex(_ index: Int) {
    let previous = _selectedIndex.value
    let selectedIndex = SelectedIndex(previousIndex: previous.index, index: index)
    _selectedIndex.value = selectedIndex
  }

  func move(fromIndex: Int, toIndex: Int) {
    let mangaViewModel = self[fromIndex]
    _mangas.value.remove(index: fromIndex)
    _mangas.value.insert(element: mangaViewModel, atIndex: toIndex)
    updateMangaPositions()
  }

  func remove(mangaViewModel: MangaViewModel) {
    let manga = _mangas.value.remove(element: mangaViewModel)!

    deletedManga.on(.next(manga))
    updateMangaPositions()
  }

  private func updateMangaPositions() {
    let indexes: [Int] = [Int](0..<self.count)

    indexes.forEach {
      _mangas.value[$0].update(position: $0)
    }
  }
}
