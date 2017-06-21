//
//  MangaTableViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/14/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit
import RxSwift

class MangaCollectionViewController: UITableViewController {
  let mockData = [
    "test",
    "yo"
  ]

  let mangaCellIdentifier = "MangaCell"
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(
      UINib(nibName: mangaCellIdentifier, bundle: nil),
      forCellReuseIdentifier: mangaCellIdentifier
    )

    let rightBarItem = UIBarButtonItem(
      title: "Add Manga 📘",
      style: .plain,
      target: nil,
      action: nil
    )

    navigationItem.rightBarButtonItem = rightBarItem

    navigationItem
      .rightBarButtonItem?
      .rx.tap
      .subscribe(onNext: {
        YomuNavigationController.instance()?.navigateToSearchMangaView()
      })
      .addDisposableTo(disposeBag)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return mockData.count
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: mangaCellIdentifier,
      for: indexPath
    ) as! MangaCell

    cell.titleLabel.text = mockData[indexPath.row]

    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}
