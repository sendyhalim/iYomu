//
//  ChapterRealm.swift
//  Yomu
//
//  Created by Sendy Halim on 8/25/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import Foundation
import RealmSwift

/// Represents chapter object that has been read for `Realm` database
class ReadChapterRealm: Object {
  @objc dynamic var id: String = ""
  @objc dynamic var number: Int = 0
  @objc dynamic var title: String = ""

  override static func primaryKey() -> String? {
    return "id"
  }

  ///  Convert the given `Chapter` struct to `ReadChapterRealm` object
  ///
  ///  - parameter chapter: `Chapter`
  ///
  ///  - returns: `ReadChapterRealm`
  static func from(chapter: Chapter) -> ReadChapterRealm {
    let readChapterRealm = ReadChapterRealm()

    readChapterRealm.id = chapter.id
    readChapterRealm.number = chapter.number
    readChapterRealm.title = chapter.title

    return readChapterRealm
  }
}
