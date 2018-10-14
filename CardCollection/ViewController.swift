//
//  ViewController.swift
//  CardCollection
//
//  Created by 배지영 on 2018. 10. 14..
//  Copyright © 2018년 ChesseFactory. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var cardCollection: UIColorCardCollection!

  override func viewDidLoad() {
    super.viewDidLoad()

    let cards: [ColorCard] = [
      ColorCard(name: "red", color: .red),
      ColorCard(name: "blue", color: .blue),
      ColorCard(name: "brown", color: .brown),
      ColorCard(name: "cyan", color: .cyan),
      ColorCard(name: "green", color: .green)
    ]
    cardCollection.set(datas: cards)
  }

}


