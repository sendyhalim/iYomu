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
  @IBOutlet weak var sortButton: UIButton!

  var disposeBag = DisposeBag()

  func setup() {
    disposeBag = DisposeBag()
  }
}
