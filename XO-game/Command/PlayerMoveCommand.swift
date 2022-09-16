//
//  PlayerMoveCommand.swift
//  XO-game
//
//  Created by Антон Чечевичкин on 16.09.2022.
//

import Foundation

 class PlayerMoveCommand {
     private var player: Player
     private weak var gameboardView: GameboardView?
     private weak var gameboard: Gameboard?
     private var position: GameboardPosition

     init(_ player: Player, view: GameboardView, gameboard: Gameboard, position: GameboardPosition) {
         self.player = player
         gameboardView = view
         self.gameboard = gameboard
         self.position = position
     }

     func execute() {
         gameboard?.setPlayer(player, at: position)
         gameboardView?.placeMarkView(player.markViewPrototype.copy(), at: position)
     }
 }
