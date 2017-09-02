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
    searchBarStyle = .minimal

    let textField = value(forKey: "_searchField") as! UITextField

    textField.borderStyle = .none
    textField.backgroundColor = UIColor(hex: "#F7F7F7")
    textField.clipsToBounds = true
    textField.layer.cornerRadius = 6.0
    textField.layer.borderWidth = 1.0
    textField.layer.borderColor = textField.backgroundColor!.cgColor
    textField.textColor = UIColor(hex: "#555555")
  }
}
