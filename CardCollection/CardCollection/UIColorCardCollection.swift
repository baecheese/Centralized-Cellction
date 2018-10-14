//
//  UICardCollection.swift
//  CardCollection
//
//  Created by 배지영 on 2018. 10. 14..
//  Copyright © 2018년 ChesseFactory. All rights reserved.
//

import UIKit

protocol UICardCollectionPresentable {
  associatedtype Data
}

class UIColorCardCollection: UIView, UICardCollectionPresentable {

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var pageControl: UIPageControl!

  typealias Data = PresentableModal
  var datas: [Data] = []
  var cardSize: CGSize = CGSize(width: 200.0, height: 150.0) // default
  var layout: UICollectionViewFlowLayout?
  private var edgeInset: UIEdgeInsets = .zero
  private var isMovingPage: Bool = false

  func set(
    datas: [PresentableModal],
    cardSize: CGSize? = nil,
    lineSpacing: CGFloat = 0.0,
    scrollDirection: UICollectionViewScrollDirection = .horizontal
  ) {
    pageControl.numberOfPages = datas.count
    self.datas = datas
    collectionView.dataSource = self
    collectionView.delegate = self
    setCollectionLayout(
      cardSize: cardSize,
      lineSpacing: lineSpacing,
      scrollDirection: scrollDirection
    )
    collectionView.reloadData()
  }

  func setCollectionLayout(
    cardSize: CGSize? = nil,
    lineSpacing: CGFloat = 0.0,
    scrollDirection: UICollectionViewScrollDirection = .horizontal
  ) {
    layout = UICollectionViewFlowLayout()
    layout?.scrollDirection = scrollDirection
    layout?.itemSize = cardSize ?? self.cardSize
    layout?.minimumLineSpacing = 20.0
    collectionView!.collectionViewLayout = layout!
  }

}

extension UIColorCardCollection: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    guard !datas.isEmpty else { return .zero }
    let center: CGFloat = layout?.scrollDirection == .horizontal ?
      collectionView.frame.width / 2 : collectionView.frame.height / 2
    let cellScrollSize = layout?.scrollDirection == .horizontal ? cardSize.width : cardSize.height
    let edge: CGFloat = center - (cellScrollSize / 2.0)
    let topBottom: CGFloat = layout?.scrollDirection == .horizontal ? 0.0 : edge
    let leftRight: CGFloat = layout?.scrollDirection == .horizontal ? edge : 0.0
    edgeInset = UIEdgeInsets(top: topBottom, left: leftRight, bottom: topBottom, right: leftRight)
    return edgeInset
  }
}

extension UIColorCardCollection: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return datas.count
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return cardSize
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath)
    guard let colorCardCell = cell as? CardCell, datas.indices.contains(indexPath.row) else { return cell }
    colorCardCell.configure(datas[indexPath.row])
    return colorCardCell
  }
}

extension UIColorCardCollection: UICollectionViewDelegate {

  // bug note : 일정 속도 이하면 바로 visible cell 로 갈 수 있도록
  // 너무 느릿할 경우 decelerating할 때까지 기다렸다가 cell을 찾아감
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    guard let currentIndexPath = collectionView.visibleIndexPath, !isMovingPage else { return }
    isMovingPage = true
    let velocity = layout?.scrollDirection == .horizontal ? velocity.x : velocity.y
    let inset = layout?.scrollDirection == .horizontal ? edgeInset.left : edgeInset.top
    let currentPoint = layout?.scrollDirection == .horizontal ?
      scrollView.contentOffset.x : scrollView.contentOffset.y
    let contentSize = layout?.scrollDirection == .horizontal ?
      scrollView.contentSize.width : scrollView.contentSize.height
    let scrollPoistion: UICollectionViewScrollPosition = layout?.scrollDirection == .horizontal ?
      .centeredHorizontally : .centeredVertically
    print("velocity \(velocity)")
//    guard inset < currentPoint && currentPoint < contentSize else { return }
    collectionView.scrollToItem(at: currentIndexPath, at: scrollPoistion, animated: true)
    isMovingPage = false
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    guard let indexPath = collectionView.visibleIndexPath else { return }
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
  
}

extension UICollectionView {
  // bug note : 1. spacing에 가면 indexpath가 안잡힘
  var visibleIndexPath: IndexPath? {
    var visibleRect = CGRect()
    visibleRect.origin = contentOffset
    visibleRect.size = bounds.size
    let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
    return indexPathForItem(at: visiblePoint)
  }

}
