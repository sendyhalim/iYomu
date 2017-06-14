//
//  Database.swift
//  Yomu
//
//  Created by Sendy Halim on 6/14/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import Foundation
import RealmSwift

struct Database {
  static fileprivate var realm: Realm!

  static func connection() -> Realm {
    guard let _ = realm else {
      realm = try! Realm()

      return realm
    }

    return realm
  }

  static func queryMangas() -> Array<Manga> {
    return connection()
      .objects(MangaRealm.self)
      .map(MangaRealm.from(mangaRealm:))
  }

  static func queryManga(id: String) -> Manga {
    let mangaRealm: MangaRealm = queryMangaRealm(id: id)

    return MangaRealm.from(mangaRealm: mangaRealm)
  }

  static func queryMangaRealm(id: String) -> MangaRealm {
    return connection().object(ofType: MangaRealm.self, forPrimaryKey: id)!
  }
}
