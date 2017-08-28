//
//  YomuAPI.swift
//  Yomu
//
//  Created by Sendy Halim on 6/4/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//
import Foundation
import Moya
import RxMoya
import RxSwift

enum YomuAPI {
  case search(String)
}

extension YomuAPI: TargetType {
  var baseURL: URL { return URL(string: "https://yomu-server.herokuapp.com/api")! }

  var path: String {
    switch self {
    case .search:
      return "/search"
    }
  }

  var method: Moya.Method {
    return .get
  }

  var parameterEncoding: ParameterEncoding {
    return URLEncoding.default
  }

  var parameters: [String: Any]? {
    switch self {
    case .search(let titlePattern):
      return ["term": titlePattern as AnyObject]
    }
  }

  var task: Task {
    return .request
  }

  var sampleData: Data {
    return "[]".UTF8EncodedData
  }
}

struct Yomu {
  fileprivate static let provider = RxMoyaProvider<YomuAPI>()

  static func request(_ api: YomuAPI) -> Observable<Response> {
    return provider.request(api)
  }
}
