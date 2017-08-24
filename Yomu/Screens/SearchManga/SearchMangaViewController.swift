//
//  SearchMangaViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/5/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit
import RxSwift
import Toaster

class SearchMangaViewController: UITableViewController {
  @IBOutlet weak var searchField: UISearchBar!

  let viewModel = SearchedMangaCollectionViewModel()
  let newManga = PublishSubject<SearchedMangaViewModel>()
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(R.nib.searchedMangaCell)

    viewModel
      .fetching
      .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
      .addDisposableTo(disposeBag)

    // Register bindings
    searchField
      .rx.text.orEmpty
      .filter { $0.characters.count > 2 } // At least 3 characters
      .throttle(1.0, latest: true, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        guard let `self` = self else {
          return
        }

        self.viewModel
          .search(term: $0)
          .addDisposableTo(self.disposeBag)
      })
      .addDisposableTo(disposeBag)

    viewModel
      .reload
      .drive(onNext: tableView.reloadData)
      .addDisposableTo(disposeBag)
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: R.nib.searchedMangaCell.identifier,
      for: indexPath
    ) as! SearchedMangaCell

    cell.setup(viewModel: viewModel[indexPath.row])

    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let searchedManga = viewModel[indexPath.row]

    guard !searchedManga.existsInDb() else {
      let _disposeBag = DisposeBag()
      ToastCenter.default.currentToast?.cancel()

      searchedManga
        .title
        .drive(onNext: {
          Toast(text: "Whoops, looks like \($0) is already in your collection", delay: 0, duration: Delay.short).show()
        })
        .addDisposableTo(_disposeBag)

      return
    }

    newManga.on(.next(searchedManga))
  }
}
