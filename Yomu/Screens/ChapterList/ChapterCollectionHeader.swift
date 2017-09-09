//
//  ChapterCollectionHeader.swift
//  Yomu
//
//  Created by Sendy Halim on 9/9/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ChapterCollectionHeader: UIView {
  @IBOutlet weak var searchInput: UISearchBar!

  var disposeBag = DisposeBag()
  var searchChapter: Driver<String> {
    return self.searchInput.rx.text.orEmpty.asDriver()
  }

  func setup() {
    disposeBag = DisposeBag()
  }
}
