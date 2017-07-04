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

  override func viewDidLoad() {
    super.viewDidLoad()

    imageContainerView = UIView(frame: CGRect(
      origin: .zero,
      size: scrollView.bounds.size
    ))

    scrollView.addSubview(imageContainerView)
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 2.0
    scrollView.delegate = self

    viewModel
      .fetch()
      .addDisposableTo(disposeBag)

    viewModel
      .reload
      .drive(onNext: self.setupImageViews)
      .addDisposableTo(disposeBag)
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
      let imageView = UIImageView(frame: CGRect(origin: origin, size: size))
      imageContainerView.addSubview(imageView)

      totalHeight = totalHeight + height + spaceBetweenPage

      vm
        .imageUrl
        .drive(onNext: {
          imageView.startAnimating()
          imageView.kf.setImage(with: $0, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { _ in
            imageView.stopAnimating()
          })
        })
        .addDisposableTo(disposeBag)
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
