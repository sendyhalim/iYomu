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

  var task: Task {
    switch self {
    case .search(let searchTerm):
      return .requestParameters(parameters: ["term": searchTerm], encoding: URLEncoding.queryString)
    }
  }

  var sampleData: Data {
    return "[]".UTF8EncodedData
  }

  var headers: [String : String]? {
    return nil
  }
}

struct Yomu {
  fileprivate static let provider = MoyaProvider<YomuAPI>()

  static func request(_ api: YomuAPI) -> Observable<Response> {
    return provider.rx.request(api).asObservable()
  }
}
