import UIKit
import RxSwift

class ChapterPageCollectionViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!

  let viewModel: ChapterPageCollectionViewModel
  let disposeBag = DisposeBag()
  let layout = ZoomableCollectionViewLayout()

  var chapterPageScale: CGFloat = 1.0
  var previousContentOffset: CGPoint = CGPoint.zero
  var maxZoomScale: CGFloat = 2.0
  var minZoomScale: CGFloat = 1.0

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
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.register(R.nib.chapterPageCell)
    collectionView.dataSource = self
    collectionView.collectionViewLayout = layout
    layout.delegate = self

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
      .drive(onNext: collectionView.reloadData)
      .disposed(by: disposeBag)

    let pinchGesture = UIPinchGestureRecognizer(
      target: self,
      action: #selector(ChapterPageCollectionViewController.zoom(gesture:))
    )

    let doubleTapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(ChapterPageCollectionViewController.toggleZoom(gesture:))
    )
    doubleTapGesture.numberOfTapsRequired = 2

    collectionView.addGestureRecognizer(pinchGesture)
    collectionView.addGestureRecognizer(doubleTapGesture)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }

  @objc
  func toggleZoom(gesture: UITapGestureRecognizer) {
    previousContentOffset = collectionView.contentOffset

    let previousScale = chapterPageScale
    chapterPageScale = chapterPageScale > minZoomScale ? minZoomScale : maxZoomScale

    collectionView.collectionViewLayout.invalidateLayout()

    let tapLocation = gesture.location(in: gesture.view!)
    let scaledTapLocation = CGPoint(
      x: tapLocation.x * chapterPageScale,
      y: tapLocation.y * chapterPageScale
    )

    let midHeight = collectionView.bounds.size.height / 2
    let scaledYBasedOnTap = chapterPageScale == minZoomScale ? (tapLocation.y / previousScale) : (tapLocation.y * maxZoomScale)

    collectionView.contentOffset = CGPoint(
      x: max(scaledTapLocation.x - tapLocation.x, 0),
      y: scaledYBasedOnTap - midHeight
    )
  }

  @objc
  func zoom(gesture: UIPinchGestureRecognizer) {
    switch gesture.state {
    case .changed:
      guard chapterPageScale <= maxZoomScale && chapterPageScale >= minZoomScale else {
        return
      }

      let previousChapterPageScale = chapterPageScale
      chapterPageScale = min(max(chapterPageScale * gesture.scale, minZoomScale), maxZoomScale)

      guard chapterPageScale != previousChapterPageScale else {
        return
      }

      previousContentOffset = collectionView.contentOffset
      collectionView.collectionViewLayout.invalidateLayout()
      adjustOffset(gesture: gesture, scale: gesture.scale)

      gesture.scale = 1.0

    default:
      return
    }
  }

  func adjustOffset(gesture: UIGestureRecognizer, scale: CGFloat) {
    let pinchLocation = gesture.location(in: gesture.view!)
    let scaledPinchLocation = CGPoint(
      x: pinchLocation.x * scale,
      y: pinchLocation.y * scale
    )

    collectionView.contentOffset = CGPoint(
      x: previousContentOffset.x + (scaledPinchLocation.x - pinchLocation.x),
      y: previousContentOffset.y + (scaledPinchLocation.y - pinchLocation.y)
    )
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

extension ChapterPageCollectionViewController: ZoomableCollectionViewLayoutDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let vm = viewModel[indexPath.row]
    let originalWidth = collectionView.bounds.width
    let width = originalWidth * chapterPageScale
    let height = CGFloat(vm.heightToWidthRatio) * originalWidth * chapterPageScale

    return CGSize(width: Int(width), height: Int(height))
  }
}
