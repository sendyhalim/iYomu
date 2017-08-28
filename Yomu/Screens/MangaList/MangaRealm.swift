//
//  MangaRealm.swift
//  Yomu
//
//  Created by Sendy Halim on 5/30/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import Foundation
import RealmSwift

/// Represents Manga object for `Realm` database
class MangaRealm: Object {
  dynamic var id: String = ""
  dynamic var slug: String = ""
  dynamic var title: String = ""
  dynamic var author: String = ""
  dynamic var imageEndpoint: String = ""
  dynamic var releasedYear: Int = 0
  dynamic var commaSeparatedCategories: String = ""
  dynamic var plot: String = ""
  dynamic var position: Int = MangaPosition.undefined.rawValue

  override static func primaryKey() -> String? {
    return "id"
  }

  ///  Convert the given `Manga` struct to `MangaRealm` object
  ///
  ///  - parameter manga: `Manga`
  ///
  ///  - returns: `MangaRealm`
  static func from(manga: Manga) -> MangaRealm {
    let mangaRealm = MangaRealm()

    mangaRealm.id = manga.id!
    mangaRealm.slug = manga.slug
    mangaRealm.title = manga.title
    mangaRealm.author = manga.author
    mangaRealm.imageEndpoint = manga.image.endpoint
    mangaRealm.releasedYear = manga.releasedYear ?? 0
    mangaRealm.commaSeparatedCategories = manga.categories.joined(separator: ",")
    mangaRealm.position = manga.position
    mangaRealm.plot = manga.plot

    return mangaRealm
  }

  ///  Convert the given `MangaRealm` object to `Manga` struct
  ///
  ///  - parameter mangaRealm: `MangaRealm`
  ///
  ///  - returns: `Manga`
  static func mangaFrom(mangaRealm: MangaRealm) -> Manga {
    let categories = mangaRealm
      .commaSeparatedCategories.characters
      .split {
        $0 == ","
      }
      .map(String.init)

    return Manga(
      position: mangaRealm.position,
      id: mangaRealm.id,
      slug: mangaRealm.slug,
      title: mangaRealm.title,
      author: mangaRealm.author,
      image: ImageUrl(endpoint: mangaRealm.imageEndpoint),
      releasedYear: mangaRealm.releasedYear,
      plot: mangaRealm.plot,
      categories: categories
    )
  }
}
