//
//  Manga.swift
//  Yomu
//
//  Created by Sendy Halim on 5/30/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

enum MangaPosition: Int {
  case undefined = -1
}

struct Manga {
  // Id is an optional because manga eden API does not return manga id
  // when we requested manga detail API
  var position: Int
  var id: String?
  let slug: String
  let title: String
  let author: String
  let image: ImageUrl
  var releasedYear: Int?
  let plot: String
  let categories: [String]

  static func copyWith(position: Int, manga: Manga) -> Manga {
    return Manga(
      position: MangaPosition.undefined.rawValue,
      id: manga.id,
      slug: manga.slug,
      title: manga.title,
      author: manga.author,
      image: manga.image,
      releasedYear: manga.releasedYear,
      plot: manga.plot,
      categories: manga.categories
    )
  }
}

extension Manga: Decodable {
  static func decode(_ json: JSON) -> Decoded<Manga> {

    ///  JSON mapping of Manga Eden API.
    ///  Example: http://www.mangaeden.com/api/manga/4e70ea6ac092255ef7006a52/
    return curry(Manga.init)(MangaPosition.undefined.rawValue)
      <^> json <|? "id"
      <*> json <| "alias"
      <*> json <| "title"
      <*> json <| "author"
      <*> json <| "image"
      <*> json <|? "released'"
      <*> json <| "description"
      <*> json <|| "categories"
  }
}
