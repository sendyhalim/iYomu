//
//  SearchMangaHeader.swift
//  Yomu
//
//  Created by Sendy Halim on 17/10/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SearchMangaHeader: UIView {
  @IBOutlet weak var searchInput: UISearchBar!

  var disposeBag = DisposeBag()

  func setup() {
    disposeBag = DisposeBag()
  }
}
