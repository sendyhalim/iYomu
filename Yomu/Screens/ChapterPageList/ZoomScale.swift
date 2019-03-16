//
//  ZoomScale.swift
//  Yomu
//
//  Created by Sendy Halim on 02/03/19.
//  Copyright © 2019 Sendy Halim. All rights reserved.
//

import Foundation
import UIKit

/// A data structure that represents zoom scale
struct ZoomScale: CustomStringConvertible {
  /// Scale in 1 based, 1 -> 100%
  let scale: Double

  /// String representation of zoom scale,
  /// will automatically multiply the scale by 100
  var description: String {
    return String(Int(scale * 100))
  }

  ///  Normalize the given scale .
  ///
  ///  - parameter scale: Zoom scale, if the scale is greater than 10 then
  ///    it's considered as 100 based scale (I believe no one wants to zoom in by 1000%)
  ///
  ///  - returns: zoom scale with base 1  (1 -> 100%)
  static private func normalize(scale: Double) -> Double {
    return scale > 10 ? (scale / 100) : scale
  }

  init(scale: Double) {
    self.scale = ZoomScale.normalize(scale: scale)
  }

  init(scale: String) {
    self.init(scale: Double(scale)!)
  }
}
