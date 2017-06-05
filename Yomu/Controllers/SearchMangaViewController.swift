//
//  SearchMangaViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/5/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit

class SearchMangaViewController: UITableViewController {
  let mockData = [
    "one",
    "two",
    "three"
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return mockData.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()

    cell.textLabel?.text = mockData[indexPath.row]

    return cell
  }
}
