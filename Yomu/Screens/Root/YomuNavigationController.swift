//
//  YomuRootViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/3/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit
import RxSwift

enum NavigationTarget {
  case searchManga
  case chapterCollection(String)
  case chapterPageCollection(ChapterViewModel)
}

enum NavigationData {
  case searchManga(String)
}

/// Custom UINavigationController for easier customization in the future
class YomuNavigationController: UINavigationController {
  static func instance() -> YomuNavigationController? {
    let windows = UIApplication.shared.windows

    for window in windows {
      if let rootViewController = window.rootViewController {
        return rootViewController as? YomuNavigationController
      }
    }

    return nil
  }

  func navigate(to: NavigationTarget) -> Observable<NavigationData?> {
    switch to {
    case .searchManga:
      let searchMangaVC = SearchMangaViewController(nibName: nil, bundle: nil)
      pushViewController(searchMangaVC, animated: true)

      return searchMangaVC
        .newManga
        .asObservable()
        .flatMap { $0.apiId.asObservable() }
        .map { .searchManga($0) }

    case .chapterCollection(let mangaId):
      let viewModel = ChapterCollectionViewModel(mangaId: mangaId)
      let chapterCollectionVC = ChapterCollectionViewController(viewModel: viewModel)
      pushViewController(chapterCollectionVC, animated: true)

      return Observable.just(nil)

    case .chapterPageCollection(let chapterVM):
      let viewModel = ChapterPageCollectionViewModel(chapterViewModel: chapterVM)
      let chapterPageCollectionVC = ChapterPageCollectionViewController(viewModel: viewModel)

      pushViewController(chapterPageCollectionVC, animated: true)

      return Observable.just(nil)
    }
  }
}
