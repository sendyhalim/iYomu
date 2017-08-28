//
//  ChapterPageCollectionViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/26/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import UIKit
import RxSwift

class ChapterPageCollectionViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var scrollView: UIScrollView!

  let viewModel: ChapterPageCollectionViewModel
  let disposeBag = DisposeBag()
  var scale: CGFloat = 1.0

  init(viewModel: ChapterPageCollectionViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.register(R.nib.chapterPageCell)
    collectionView.dataSource = self
    collectionView.delegate = self

    viewModel
      .fetch()
      .addDisposableTo(disposeBag)

    viewModel
      .reload
      .drive(onNext: collectionView.reloadData)
      .addDisposableTo(disposeBag)
  }
}

extension ChapterPageCollectionViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: R.nib.chapterPageCell.identifier,
      for: indexPath
    ) as! ChapterPageCell

    cell.setup(viewModel: viewModel[indexPath.row])

    return cell
  }
}

extension ChapterPageCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let vm = viewModel[indexPath.row]
    let width = scale * collectionView.bounds.size.width
    let height = scale * CGFloat(vm.heightToWidthRatio) * width

    return CGSize(width: width, height: height)
  }
}
