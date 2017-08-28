//
//  MangaTableViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/14/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit
import RxSwift

class MangaCollectionViewController: UICollectionViewController {
  let viewModel = MangaCollectionViewModel()
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView!.register(R.nib.mangaCell)
    collectionView?.delegate = self

    let rightBarItem = UIBarButtonItem(
      title: "Add Manga 📘",
      style: .plain,
      target: nil,
      action: nil
    )

    navigationItem.rightBarButtonItem = rightBarItem

    viewModel
      .reload
      .drive(onNext: collectionView!.reloadData)
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

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.count
  }

  override func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: R.nib.mangaCell.identifier,
      for: indexPath
      ) as! MangaCell

    cell.setup(viewModel: viewModel[indexPath.row])

    return cell
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let mangaViewModel = viewModel[indexPath.row]

    _ = YomuNavigationController
      .instance()!
      .navigate(to: .chapterCollection(mangaViewModel.id))
  }
}

extension MangaCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = UIScreen.main.bounds.size.width

    return CGSize(width: width, height: 80)
  }
}
