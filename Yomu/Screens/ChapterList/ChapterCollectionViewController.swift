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
  let viewModel: ChapterCollectionViewModel
  let disposeBag = DisposeBag()
  var chapterCollectionHeader: ChapterCollectionHeader!

  init(viewModel: ChapterCollectionViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(R.nib.chapterCell)

    chapterCollectionHeader = R.nib.chapterCollectionHeader.firstView(owner: nil)
    tableView.tableHeaderView = chapterCollectionHeader

    chapterCollectionHeader.setup()
    chapterCollectionHeader
      .searchInput
      .rx.text.orEmpty
      .asDriver()
      .drive(viewModel.filterPattern)
      .disposed(by: chapterCollectionHeader.disposeBag)

    chapterCollectionHeader
      .sortButton
      .rx.tap
      .asDriver()
      .drive(viewModel.toggleSort)
      .disposed(by: chapterCollectionHeader.disposeBag)

    viewModel
      .sortOrder
      .map {
        $0 == .descending ? #imageLiteral(resourceName: "descending") : #imageLiteral(resourceName: "ascending")
      }
      .drive(chapterCollectionHeader.sortButton.rx.image())
      .disposed(by: disposeBag)

    viewModel
      .title
      .drive(onNext: { [weak self] in
        self?.title = $0
      })
      .disposed(by: disposeBag)

    viewModel
      .fetching
      .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
      .disposed(by: disposeBag)

    viewModel
      .fetch()
      .disposed(by: disposeBag)

    viewModel
      .reload
      .drive(onNext: tableView.reloadData)
      .disposed(by: disposeBag)
  }
}

// MARK: - Data source
extension ChapterCollectionViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: R.nib.chapterCell.identifier,
      for: indexPath
    ) as! ChapterCell

    cell.setup(viewModel: viewModel[indexPath.row])

    return cell
  }
}

// MARK: - Delegate
extension ChapterCollectionViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let chapterViewModel = viewModel[indexPath.row]

    chapterViewModel
      .markAsRead()
      .disposed(by: disposeBag)

    _ = YomuNavigationController
      .instance()?
      .navigate(to: .chapterPageCollection(chapterViewModel))
  }
}
