//
//  ComputerState.swift
//  XO-game
//
//  Created by Антон Чечевичкин on 16.09.2022.
//

import UIKit

protocol ComputerMoveProtocol: AnyObject {
     func makeMove() -> GameboardPosition?
 }

class ComputerState: GameState, ComputerMoveProtocol {

     var isCompleted: Bool = false

     public let player: Player
     private weak var gameViewController: GameViewController?
     private weak var gameBoard: Gameboard?
     private weak var gameBoardView: GameboardView?

     public let markViewPrototype: MarkView

     init(player: Player, gameViewController: GameViewController, gameBoard: Gameboard, gameBoardView: GameboardView, markViewPrototype: MarkView) {
         self.player = player
         self.gameViewController = gameViewController
         self.gameBoard = gameBoard
         self.gameBoardView = gameBoardView
         self.markViewPrototype = markViewPrototype
     }

     func begin() {
         switch player {
         case .first:
             gameViewController?.firstPlayerTurnLabel.isHidden = false
             gameViewController?.secondPlayerTurnLabel.isHidden = true
         case .second:
             gameViewController?.firstPlayerTurnLabel.isHidden = true
             gameViewController?.secondPlayerTurnLabel.isHidden = false
         }

         gameViewController?.winnerLabel.isHidden = true
     }

     func addMark(at position: GameboardPosition) {

         guard let gameBoardView = gameBoardView, gameBoardView.canPlaceMarkView(at: position) else {
             return
         }

         Log(action: .playerInput(player: player, position: position))

         gameBoard?.setPlayer(player, at: position)
         gameBoardView.placeMarkView(markViewPrototype.copy(), at: position)

         isCompleted = true
     }

     func makeMove() -> GameboardPosition? {
         var undefinedPositions: [GameboardPosition] = []

         guard let gameBoard = gameBoard else { return nil }

         for (columnIndex, rows) in gameBoard.positions.enumerated() {
             for (rowIndex, row) in rows.enumerated() {
                 if row == nil {
                     undefinedPositions.append(GameboardPosition(column: columnIndex, row: rowIndex))
                 }
             }
         }

         return undefinedPositions.shuffled().first
     }
 }
