//
//  MangaTableViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/14/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit

class MangaCollectionViewController: UITableViewController {
  let mockData = [
    "test",
    "yo"
  ]

  let mangaCellIdentifier = "MangaCell"

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(
      UINib(nibName: mangaCellIdentifier, bundle: nil),
      forCellReuseIdentifier: mangaCellIdentifier
    )
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
