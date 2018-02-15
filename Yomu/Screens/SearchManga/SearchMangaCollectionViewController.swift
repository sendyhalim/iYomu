//
//  SearchMangaViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/5/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Toaster
import Swiftz

class SearchMangaCollectionViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!

  var header: SearchMangaHeader!
  var viewModel = SearchedMangaCollectionViewModel()
  let newManga = PublishSubject<SearchedMangaViewModel>()
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.register(
      R.nib.searchMangaHeader(),
      forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
      withReuseIdentifier: R.nib.searchMangaHeader.identifier
    )

    collectionView.register(R.nib.searchedMangaCell)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.headerReferenceSize = CGSize(width: collectionView.bounds.width, height: 50)

     setupBindings()
  }

  func setupBindings() {
    viewModel
      .fetching
      .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
      .disposed(by: disposeBag)

    viewModel
      .reload
      .drive(onNext: collectionView.reloadData)
      .disposed(by: disposeBag)
  }
}

extension SearchMangaCollectionViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: R.nib.searchedMangaCell.identifier,
      for: indexPath
    ) as! SearchedMangaCell

    cell.setup(viewModel: viewModel[indexPath.row])

    return cell
  }
}

extension SearchMangaCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: 80)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let searchedManga = viewModel[indexPath.row]

    header.searchInput.resignFirstResponder()

    guard !searchedManga.existsInDb() else {
      let _disposeBag = DisposeBag()
      ToastCenter.default.currentToast?.cancel()

      searchedManga
        .title
        .drive(onNext: {
          Toast(text: "Whoops, looks like \($0) is already in your collection", delay: 0, duration: Delay.short).show()
        })
        .disposed(by: _disposeBag)

      return
    }

    newManga.on(.next(searchedManga))
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: 50)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    header = collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionElementKindSectionHeader,
      withReuseIdentifier: R.nib.searchMangaHeader.identifier,
      for: indexPath
    ) as! SearchMangaHeader

    header?.setup()

    header.searchInput
      .rx.text.orEmpty
      .filter { $0.count > 2 } // At least 3 characters
      .throttle(1.0, latest: true, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        guard let `self` = self else {
          return
        }

        // Is there a better way to cancel previous requests?
        self.viewModel.disposeBag = DisposeBag()
        self.viewModel
          .search(term: $0)
          .disposed(by: self.viewModel.disposeBag)
      })
      .disposed(by: header.disposeBag)

    return header
  }
}
