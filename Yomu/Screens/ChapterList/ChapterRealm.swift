//
//  ChapterRealm.swift
//  Yomu
//
//  Created by Sendy Halim on 8/25/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import Foundation
import RealmSwift

/// Represents Chapter object for `Realm` database
class ChapterRealm: Object {
  dynamic var id: String = ""
  dynamic var number: Int = 0
  dynamic var title: String = ""

  override static func primaryKey() -> String? {
    return "id"
  }

  ///  Convert the given `Chapter` struct to `ChapterRealm` object
  ///
  ///  - parameter chapter: `Chapter`
  ///
  ///  - returns: `ChapterRealm`
  static func from(chapter: Chapter) -> ChapterRealm {
    let chapterRealm = ChapterRealm()

    chapterRealm.id = chapter.id
    chapterRealm.number = chapter.number
    chapterRealm.title = chapter.title

    return chapterRealm
  }

  ///  Convert the given `ChapterRealm` object to `Chapter` struct
  ///
  ///  - parameter chapterRealm: `ChapterRealm`
  ///
  ///  - returns: `Chapter`
  static func chapterFrom(chapterRealm: ChapterRealm) -> Chapter {
    return Chapter(id: chapterRealm.id, number: chapterRealm.number, title: chapterRealm.title)
  }
}
