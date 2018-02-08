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

    searchBarStyle = .minimal

    // Create search icon
    let searchIcon = UIImageView(image: #imageLiteral(resourceName: "search"))
    let searchImageSize = searchIcon.image!.size
    searchIcon.frame = CGRect(x: 0, y: 0, width: searchImageSize.width + 10, height: searchImageSize.height)
    searchIcon.contentMode = UIViewContentMode.center

    // Configure text field
    let textField = value(forKey: "_searchField") as! UITextField
    textField.leftView = searchIcon
    textField.borderStyle = .none
    textField.backgroundColor = UIColor(hex: "#F7F7F7")
    textField.clipsToBounds = true
    textField.layer.cornerRadius = 6.0
    textField.layer.borderWidth = 1.0
    textField.layer.borderColor = textField.backgroundColor!.cgColor
    textField.textColor = UIColor(hex: "#555555")
  }
}
