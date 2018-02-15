//
//  SearchMangaHeader.swift
//  Yomu
//
//  Created by Sendy Halim on 16/02/18.
//  Copyright © 2018 Sendy Halim. All rights reserved.
//

import UIKit
import RxSwift

class SearchMangaHeader: UICollectionReusableView {
  @IBOutlet weak var searchInput: UISearchBar!

  var disposeBag = DisposeBag()

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func setup() {
    disposeBag = DisposeBag()
  }
}
