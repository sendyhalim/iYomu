//
//  MangaTableViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/14/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit
import RxSwift

class MangaCollectionViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var emptyDataSetContainerView: EmptyDataSetContainerView!

  let viewModel = MangaCollectionViewModel()
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.register(R.nib.mangaCell)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

    setupEmptyDataSet()
    setupViewModelBindings()
    setupGestureRecognizers()
  }

  func setupEmptyDataSet() {
    emptyDataSetContainerView.emptyView = R.nib.emptyMangaSetView.firstView(owner: nil)!
    emptyDataSetContainerView.loadingView = R.nib.fetchMangaLoadingView.firstView(owner: nil)!
    emptyDataSetContainerView.collectionView = collectionView
  }

  func setupViewModelBindings() {
    let rightBarItem = UIBarButtonItem(
      title: "Add Manga 📘",
      style: .plain,
      target: nil,
      action: nil
    )

    navigationItem.rightBarButtonItem = rightBarItem

    viewModel
      .reload
      .drive(onNext: collectionView.reloadData)
      .disposed(by: disposeBag)

   viewModel
      .reload
      .drive(onNext: { [weak self] in
        if self!.viewModel.count > 0 {
          self!.emptyDataSetContainerView.showCollectionView()
        } else {
          self!.emptyDataSetContainerView.showEmptyDataSetView()
        }
      })
      .disposed(by: disposeBag)

   viewModel
      .showEmptyDataSetLoading
      .drive(onNext: emptyDataSetContainerView.showLoadingView)
      .disposed(by: disposeBag)

   viewModel
      .fetching
      .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
      .disposed(by: disposeBag)

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
            .disposed(by: self.disposeBag)
       }

        YomuNavigationController.instance()?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }

  func setupGestureRecognizers() {
    // Setup left swipe gesture
    let leftSwipeGesture = UISwipeGestureRecognizer(
      target: self,
      action: #selector(MangaCollectionViewController.deleteCell)
    )
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirection.left
    collectionView.addGestureRecognizer(leftSwipeGesture)

    // Setup right swipe gesture
    let rightSwipeGesture = UISwipeGestureRecognizer(
      target: self,
      action: #selector(MangaCollectionViewController.deleteCell)
    )
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirection.right
    collectionView.addGestureRecognizer(rightSwipeGesture)

    // Setup long press gesture to reorder cells
    let longPressGesture = UILongPressGestureRecognizer(
      target: self,
      action: #selector(MangaCollectionViewController.handleLongPressGesture)
    )

    collectionView.addGestureRecognizer(longPressGesture)
  }

  @objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer) {
    switch gesture.state {
    case .began:
      guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
        return
      }

      collectionView.beginInteractiveMovementForItem(at: indexPath)

    case .changed:
      collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))

    case .ended:
      collectionView.endInteractiveMovement()

    default:
      collectionView.cancelInteractiveMovement()
    }
  }

  @objc func deleteCell(swipeGesture: UISwipeGestureRecognizer) {
    let swipeLocation = swipeGesture.location(in: collectionView)

    guard let indexPath = collectionView.indexPathForItem(at: swipeLocation) else {
      return
    }

    let cell = collectionView.cellForItem(at: indexPath) as! MangaCell

    cell.onSwipe(gesture: swipeGesture)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // There's a bug in iOS 11.2 that makes UIBarButtonItem grayed out when a view controller
    // in navigation controller popped out
    // https://stackoverflow.com/questions/47754472/ios-uinavigationbar-button-remains-faded-after-segue-back/47839657#4783965
    self.navigationController?.navigationBar.tintAdjustmentMode = .normal
    self.navigationController?.navigationBar.tintAdjustmentMode = .automatic
  }
}

extension MangaCollectionViewController: UICollectionViewDataSource {
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
      withReuseIdentifier: R.nib.mangaCell.identifier,
      for: indexPath
    ) as! MangaCell

    cell.setup(viewModel: viewModel[indexPath.row])
    cell.delegate = self

    return cell
  }
}

extension MangaCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let mangaViewModel = viewModel[indexPath.row]

    _ = YomuNavigationController
      .instance()!
      .navigate(to: .chapterCollection(mangaViewModel.id))
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: 80)
  }

  func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  func collectionView(
    _ collectionView: UICollectionView,
    moveItemAt sourceIndexPath: IndexPath,
    to destinationIndexPath: IndexPath
  ) {
    viewModel.move(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
  }
}

extension MangaCollectionViewController: MangaCellDelegate {
  func deleteButtonClicked(mangaViewModel: MangaViewModel) {
    viewModel.remove(mangaViewModel: mangaViewModel)
  }
}
