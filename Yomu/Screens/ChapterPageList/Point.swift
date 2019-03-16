//
//  Point.swift
//  Yomu
//
//  Created by Sendy Halim on 17/03/19.
//  Copyright © 2019 Sendy Halim. All rights reserved.
//

struct Point {
  let x: Double
  let y: Double

  init(x: Double, y: Double) {
    self.x = x
    self.y = y
  }

  init(both: Double) {
    self.init(x: both, y: both)
  }

 static func + (left: Point, right: Point) -> Point {
    return Point(
      x: left.x + right.x,
      y: left.y + right.y
    )
  }

  static func - (left: Point, right: Point) -> Point {
    return Point(
      x: left.x - right.x,
      y: left.y - right.y
    )
  }

  static func * (left: Point, scale: Double) -> Point {
    return Point(
      x: left.x * scale,
      y: left.y * scale
    )
  }
}
