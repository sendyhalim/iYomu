//
//  ChapterPageCollectionViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 6/26/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import Foundation
import RxCocoa
import RxMoya
import RxSwift
import Swiftz

/// A data structure that represents zoom scale
struct ZoomScale: CustomStringConvertible {
  /// Scale in 1 based, 1 -> 100%
  let scale: Double

  /// String representation of zoom scale,
  /// will automatically multiply the scale by 100
  var description: String {
    return String(Int(scale * 100))
  }

  ///  Normalize the given scale .
  ///
  ///  - parameter scale: Zoom scale, if the scale is greater than 10 then
  ///    it's considered as 100 based scale (I believe no one wants to zoom in by 1000%)
  ///
  ///  - returns: zoom scale with base 1  (1 -> 100%)
  static private func normalize(scale: Double) -> Double {
    return scale > 10 ? (scale / 100) : scale
  }

  init(scale: Double) {
    self.scale = ZoomScale.normalize(scale: scale)
  }

  init(scale: String) {
    self.init(scale: Double(scale)!)
  }
}

struct ChapterPageCollectionViewModel {
  // MARK: Public
  /// Chapter image
  var chapterImage: ImageUrl? {
    return _chapterPages.value.isEmpty ? .none : _chapterPages.value.first!.image
  }

  /// Number of pages in one chapter
  var count: Int {
    return _chapterPages.value.count
  }

  // MARK: Input
  let zoomIn = PublishSubject<Void>()
  let zoomOut = PublishSubject<Void>()

  // MARK: Output
  let reload: Driver<Void>
  let chapterPages: Driver<List<ChapterPage>>
  let invalidateLayout: Driver<Void>
  let title: Driver<String>
  let readingProgress: Driver<String>
  let pageCount: Driver<String>
  let disposeBag = DisposeBag()

  // MARK: Private
  fileprivate let _chapterPages = Variable(List<ChapterPage>())
  fileprivate let _currentPageIndex = Variable(0)
  fileprivate let _zoomScale = Variable(ZoomScale(scale: 1.0))
  fileprivate let chapterVM: ChapterViewModel

  init(chapterViewModel: ChapterViewModel) {
    let _chapterPages = self._chapterPages
    let _zoomScale = self._zoomScale
    let _currentPageIndex = self._currentPageIndex

    chapterVM = chapterViewModel
    chapterPages = _chapterPages.asDriver()

    reload = chapterPages
      .asDriver()
      .map { _ in () }

    readingProgress = _currentPageIndex
      .asDriver()
      .map { String($0 + 1) }

    pageCount = _chapterPages
      .asDriver()
      .map { "/ \($0.count) pages" }

    invalidateLayout = _zoomScale
      .asDriver()
      .map { _ in () }

    title = chapterVM.title
  }

  subscript(index: Int) -> ChapterPageViewModel {
    let page = _chapterPages.value[UInt(index)]

    return ChapterPageViewModel(page: page)
  }

  func fetch() -> Disposable {
    return MangaEden
      .request(MangaEdenAPI.chapterPages(chapterVM.chapter.id))
      .mapArray(ChapterPage.self, withRootKey: "images")
      .subscribe(onNext: {
        let sortedPages = $0.sorted {
          let (x, y) = ($0, $1)

          return x.number < y.number
        }

        self._chapterPages.value = List<ChapterPage>(fromArray: sortedPages)
      })
  }

  func setCurrentPageIndex(_ index: Int) {
    _currentPageIndex.value = index
  }

  func chapterIndexIsValid(index: Int) -> Bool {
    return 0 ... (count - 1) ~= index
  }
}
