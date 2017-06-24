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
  let mangaCellIdentifier = "MangaCell"
  let viewModel = MangaCollectionViewModel()
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

    viewModel
      .reload
      .drive(onNext: tableView.reloadData)
      .addDisposableTo(disposeBag)

    viewModel
      .fetching
      .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
      .addDisposableTo(disposeBag)

    navigationItem
      .rightBarButtonItem?
      .rx.tap
      .flatMap {
        YomuNavigationController
          .instance()!
          .navigate(to: .searchManga)
      }
      .subscribe(onNext: { [weak self] navigationData in
        guard let `self` = self else {
          return
        }

        if case .some(.searchManga(let id)) = navigationData {
          self.viewModel
            .fetch(id: id)
            .addDisposableTo(self.disposeBag)
        }

        YomuNavigationController.instance()?.popViewController(animated: true)
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
    return viewModel.count
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: mangaCellIdentifier,
      for: indexPath
    ) as! MangaCell

    cell.setup(viewModel: viewModel[indexPath.row])

    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    _ = YomuNavigationController
      .instance()!
      .navigate(to: .chapterCollection)
  }
}
