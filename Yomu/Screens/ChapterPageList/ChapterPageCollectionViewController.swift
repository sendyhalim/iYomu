import UIKit
import RxSwift

class ChapterPageCollectionViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!

  let viewModel: ChapterPageCollectionViewModel
  let disposeBag = DisposeBag()
  let layout = ZoomableCollectionViewLayout()
  var initialSize: CGSize = CGSize.zero

  var chapterPageScale: CGFloat = 1.0
  var previousContentOffset: CGPoint = CGPoint.zero

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

    initialSize = collectionView.contentSize

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

    collectionView.addGestureRecognizer(pinchGesture)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }

  @objc
  func zoom(gesture: UIPinchGestureRecognizer) {
    if gesture.state == .began {
      previousContentOffset = collectionView.contentOffset
    } else if gesture.state == .changed {
      chapterPageScale = max(min(chapterPageScale * gesture.scale, 2.0), 1.0)
      gesture.scale = 1.0

      let newSize = CGSize(
        width: initialSize.width * chapterPageScale,
        height: initialSize.height * chapterPageScale
      )

      collectionView.contentSize = newSize
      layout.contentSize = newSize

      collectionView.contentOffset = CGPoint(
        x: 0,
        y: previousContentOffset.y * chapterPageScale
      )

      collectionView.collectionViewLayout.invalidateLayout()
    }
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
