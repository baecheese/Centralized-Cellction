//
//  UICardCollection.swift
//  CardCollection
//
//  Created by 배지영 on 2018. 10. 14..
//  Copyright © 2018년 ChesseFactory. All rights reserved.
//

import UIKit

protocol UICardCollectionPresentable {
  associatedtype Datas
}

class UIColorCardCollection: UIView, UICardCollectionPresentable {

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var pageControl: UIPageControl!

  func set(pageCount: Int) {
    collectionView.dataSource = self
    collectionView.delegate = self
    self.pageCount = pageCount
    collectionView.reloadData()
  }

}

extension UIColorCardCollection: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pageCount
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath)
    return cell
  }
}

extension UIColorCardCollection: UICollectionViewDelegate {

}
