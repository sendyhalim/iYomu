//
//  String.swift
//  Yomu
//
//  Created by Sendy Halim on 6/4/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import Foundation

extension String {
  var UTF8EncodedData: Data {
    return self.data(using: String.Encoding.utf8)!
  }
}
