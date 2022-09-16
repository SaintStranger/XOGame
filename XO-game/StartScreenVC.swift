//
//  StartScreenVC.swift
//  XO-game
//
//  Created by test on 16.09.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class StartScreenVC: UIViewController {
     //MARK: - IBActions
     
     @IBAction func startGameWithHuman(_ sender: UIButton) {
         startGame(level: .withHuman)
     }
     @IBAction func startGameWithComputer(_ sender: UIButton) {
         startGame(level: .withCPU)
     }
     @IBAction func startGameWith5move(_ sender: UIButton) {
         startGame(level: .fiveMove)
     }
     private func startGame(level: GameLevel) {
         let storyBoard = UIStoryboard(name: "Main", bundle: nil)
         guard let vc = storyBoard.instantiateViewController(identifier: "GameViewController") as? GameViewController else { return }

         vc.level = level

         show(vc, sender: self)
     }
 }
