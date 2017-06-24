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
  case chapterCollection
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

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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

    case .chapterCollection:
      let chapterCollectionVC = ChapterCollectionViewController(nibName: nil, bundle: nil)
      pushViewController(chapterCollectionVC, animated: true)

      return Observable.just(nil)
    }
  }
}
