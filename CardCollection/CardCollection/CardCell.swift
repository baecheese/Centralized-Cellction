//
//  CardCell.swift
//  CardCollection
//
//  Created by 배지영 on 2018. 10. 14..
//  Copyright © 2018년 ChesseFactory. All rights reserved.
//

import UIKit

protocol PresentableModal {
  var name: String { get }
  var color: UIColor { get }
}

class CardCell: UICollectionViewCell {
  @IBOutlet weak var nameLabel: UILabel!

  func configure(_ card: PresentableModal) {
    nameLabel.text = card.name
    backgroundColor = card.color
  }
}
