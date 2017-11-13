//
//  MangaEdenAPI.swift
//  Yomu
//
//  Created by Sendy Halim on 6/4/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxMoya

enum MangaEdenAPI {
  case mangaDetail(String)
  case chapterPages(String)
}

extension MangaEdenAPI: TargetType {
  var baseURL: URL { return URL(string: "http://www.mangaeden.com/api")! }

  var path: String {
    switch self {
    case .mangaDetail(let id):
      return "/manga/\(id)"

    case .chapterPages(let id):
      return "/chapter/\(id)"
    }
  }

  var method: Moya.Method {
    return .get
  }

  var task: Task {
    return .requestPlain
  }

  var sampleData: Data {
    return "{}".UTF8EncodedData
  }

  var headers: [String: String]? {
    return nil
  }
}

struct MangaEden {
  fileprivate static let provider = MoyaProvider<MangaEdenAPI>()

  static func request(_ api: MangaEdenAPI) -> Observable<Response> {
    return provider.rx.request(api).asObservable()
  }
}
