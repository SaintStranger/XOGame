//
//  PlayOutState.swift
//  XO-game
//
//  Created by Антон Чечевичкин on 16.09.2022.
//

import Foundation

 class PlayoutState: GameState {
     var isCompleted: Bool = false

     private weak var invoker: PlayerMoveInvoker?

     init(invoker: PlayerMoveInvoker) {
         self.invoker = invoker
     }

     func begin() {
         invoker?.executeFiveMoves()

     }

     func addMark(at position: GameboardPosition) {

     }
 }
