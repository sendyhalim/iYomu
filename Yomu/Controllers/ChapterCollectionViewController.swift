//
//  ChapterCollectionViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/24/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit
import RxSwift

class ChapterCollectionViewController: UITableViewController {
  @IBOutlet weak var searchInput: UISearchBar!

  let viewModel: ChapterCollectionViewModel
  let disposeBag = DisposeBag()

  init(viewModel: ChapterCollectionViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    searchInput
      .rx.text.orEmpty
      .bind(to: viewModel.filterPattern)
      .addDisposableTo(disposeBag)

    viewModel
      .fetch()
      .addDisposableTo(disposeBag)

    viewModel
      .reload
      .drive(onNext: tableView.reloadData)
      .addDisposableTo(disposeBag)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 0
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.count
  }
}
