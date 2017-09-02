//
//  SearchBar.swift
//  Yomu
//
//  Created by Sendy Halim on 9/3/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import Foundation
import UIKit

class SearchBar: UISearchBar {

  override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)

    setImage(#imageLiteral(resourceName: "search"), for: .search, state: .normal)
  }
}
