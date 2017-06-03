//
//  YomuRootViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/3/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit

/// Custom UINavigationController for easier customization in the future
class YomuNavigationController: UINavigationController {
  static func instance() -> YomuNavigationController? {
    let windows = UIApplication.shared.windows

    for window in windows {
      if let rootViewController = window.rootViewController {
        return rootViewController as? YomuNavigationController
      }
    }

    return nil
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
