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
  let zoomScale: Driver<ZoomScale>
  let contentOffset: Driver<Point>
  let disposeBag = DisposeBag()
  let maxZoomScale: Double = 2.0
  let minZoomScale: Double = 1.0

  // MARK: Private
  fileprivate let _chapterPages = Variable(List<ChapterPage>())
  fileprivate let _currentPageIndex = Variable(0)
  fileprivate let _zoomScale = Variable(ZoomScale(scale: 1.0))
  fileprivate let _contentOffset = Variable(Point(x: 0, y: 0))
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

    zoomScale = _zoomScale.asDriver()
    contentOffset = _contentOffset.asDriver()

    invalidateLayout = zoomScale.map { _ in () }

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

  func zoom(pinchLocation: Point, currentContentOffset: Point, scaleBy: Double) {
    let currentZoomScale = _zoomScale.value.scale

    guard currentZoomScale <= maxZoomScale && currentZoomScale >= minZoomScale else {
      return
    }

    let nextZoomScale = min(max(currentZoomScale * scaleBy, minZoomScale), maxZoomScale)

    guard currentZoomScale != nextZoomScale else {
      return
    }

    _zoomScale.value = ZoomScale(scale: nextZoomScale)

    let scaledPinchLocation = pinchLocation * scaleBy

    _contentOffset.value = currentContentOffset + scaledPinchLocation - pinchLocation
  }

  func toggleZoom(tapLocation: Point, containerHeight: Double) {
    let previousZoomScale = _zoomScale.value.scale
    let nextZoomScale = previousZoomScale > minZoomScale ? minZoomScale : maxZoomScale

    let scaledTapLocation = tapLocation * nextZoomScale
    let midHeight = containerHeight / 2
    let scaledYBasedOnTap = nextZoomScale == minZoomScale ? (tapLocation.y / previousZoomScale) : (tapLocation.y * maxZoomScale)

    _zoomScale.value = ZoomScale(scale: nextZoomScale)
    _contentOffset.value = Point(
      x: max(scaledTapLocation.x - tapLocation.x, 0),
      y: scaledYBasedOnTap - midHeight
    )
  }

  func maxSizeForPage(atIndex index: Int, maxWidth: Double) -> Size {
    let vm = self[index]

    return vm.maxSize(
      maxWidth: maxWidth,
      zoomScale: _zoomScale.value.scale
    )
  }
}
