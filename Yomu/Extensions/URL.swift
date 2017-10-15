//
//  URL.swift
//  Yomu
//
//  Created by Sendy Halim on 6/4/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import Argo
import Swiftz

extension URL: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<URL> {
    switch json {
    case JSON.string(let url):
      return URL(string: url).map(pure) ?? .typeMismatch(
        expected: "A String that is convertible to URL",
        actual: url
      )

    default:
      return .typeMismatch(expected: "String", actual: json)
    }
  }
}
