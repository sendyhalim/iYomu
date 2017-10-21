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
  @IBOutlet weak var scrollView: UIScrollView!
  var imageContainerView: UIView!

  let viewModel: ChapterPageCollectionViewModel
  let disposeBag = DisposeBag()

  init(viewModel: ChapterPageCollectionViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    imageContainerView.removeFromSuperview()
    imageContainerView = nil
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupScrollView()

    navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
      title: "Back",
      style: .plain,
      target: nil,
      action: nil
    )

    viewModel
      .title
      .drive(onNext: { [weak self] in
        self?.title = $0
      })
      .disposed(by: disposeBag)

    viewModel
      .fetch()
      .disposed(by: disposeBag)

    viewModel
      .reload
      .drive(onNext: self.setupImageViews)
      .disposed(by: disposeBag)
  }

  func setupScrollView() {
    imageContainerView = UIView(frame: CGRect(
      origin: .zero,
      size: scrollView.bounds.size
    ))

    scrollView.addSubview(imageContainerView)
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 2.0
    scrollView.delegate = self

    // Double tap to zoom in or zoom out
    let tap = UITapGestureRecognizer(
      target: self,
      action: #selector(ChapterPageCollectionViewController.toogleZoom(gesture:))
    )
    tap.numberOfTapsRequired = 2
    scrollView.addGestureRecognizer(tap)
  }

  @objc
  func toogleZoom(gesture: UITapGestureRecognizer) {
    if scrollView.zoomScale > 1.0 {
      // Zoom out
      scrollView.setZoomScale(1.0, animated: true)
    } else {
      // Zoom in
      scrollView.setZoomScale(2.0, animated: true)
    }
  }

  func setupImageViews() {
    let width = imageContainerView.bounds.size.width
    let spaceBetweenPage: CGFloat = 20
    var totalHeight: CGFloat = 0

    for index in 0..<viewModel.count {
      let vm = viewModel[index]
      let height = CGFloat(vm.heightToWidthRatio) * width
      let origin = CGPoint(x: 0, y: totalHeight)
      let size = CGSize(width: width, height: height)
      let chapterPageView = R.nib.chapterPageView.firstView(owner: nil)!
      chapterPageView.frame = CGRect(origin: origin, size: size)
      chapterPageView.setup(viewModel: vm)
      imageContainerView.addSubview(chapterPageView)

      totalHeight = totalHeight + height + spaceBetweenPage
    }

    let totalSize = CGSize(width: width, height: totalHeight)
    imageContainerView.frame.size = totalSize
    scrollView.contentSize = totalSize
  }
}

extension ChapterPageCollectionViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageContainerView
  }
}
