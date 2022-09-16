//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

enum GameLevel {
     case withHuman
     case withCPU
     case fiveMove
 }

class GameViewController: UIViewController {
    
    var level: GameLevel?
    
    private let gameBoard = Gameboard()
    private var currentState: GameState! {
        didSet {
            currentState.begin()
        }
    }
    
    private lazy var referee = Referee(gameboard: gameBoard)
    
    private var counter = 0
    private var invoker = PlayerMoveInvoker()
    
    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
//            self.gameboardView.placeMarkView(XView(), at: position)
            
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                
                self.counter += 1
                
                self.setNextState()
            }
        }
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        
        Log(action: .restartGame)
        
        gameboardView.clear()
        gameBoard.clear()
        setFirstState()
    }
    
    private func setFirstState() {
        counter = 0
//        let player = Player.first
//        currentState = PlayerState(player: player, gameViewController: self,
//                                   gameBoard: gameBoard, gameBoardView: gameboardView, markViewPrototype: player.markViewPrototype)
        
        switch level! {
                 case .fiveMove:
                     currentState = FiveMovesState(player: Player.first, gameViewController: self, gameBoard: gameBoard, gameBoardView: gameboardView, markViewPrototype: Player.first.markViewPrototype, invoker: invoker)
                 case .withCPU, .withHuman:
                     currentState = buildPlayerState(player: Player.first)
                 }
    }
    
    private func setNextState() {
        
      //  if let winner = referee.determineWinner() {
        guard let level = level else {return}

               if counter >= 9 {
                   currentState = GameFinishedState(winner: nil, gameViewController: self)
                   return
               }

               if level != .fiveMove, let winner = referee.determineWinner() {
                   currentState = GameFinishedState(winner: winner, gameViewController: self)
                   return
               }
        //}
        
//        if counter >= 9 {
//            currentState = GameOverState(winner: nil, gameViewController: self)
//            return
//        }
        if level == .withHuman, let playerInputState = currentState as? PlayerInputState {
                    currentState = buildPlayerState(player: playerInputState.player.next)
                    return
                }
        
        if let playerInputState = currentState as? ComputerState {
                    currentState = buildPlayerState(player: playerInputState.player.next)
                    return
                }

                if level == .fiveMove, let playerInputState = currentState as? FiveMovesState {
                    gameboardView.clear()
                    gameBoard.clear()

                    if playerInputState.player == Player.second {
                        // расчитать игру
                        
                        currentState = PlayoutState(invoker: invoker)

                        if let winner = referee.determineWinner() {
                            currentState = GameFinishedState(winner: winner, gameViewController: self)
                            return
                        }

                        return
                    }


                    let player = playerInputState.player.next

                    currentState = FiveMovesState(player: player, gameViewController: self, gameBoard: gameBoard, gameBoardView: gameboardView, markViewPrototype: player.markViewPrototype, invoker: invoker)

                    return
                }
        
        if let playerInputState = currentState as? PlayerInputState {
            let player = playerInputState.player.next

            let state = ComputerState(player: player,
                                                  gameViewController: self,
                                                  gameBoard: gameBoard,
                                                  gameBoardView: gameboardView,
                                                  markViewPrototype: player.markViewPrototype
                        )

                        guard let nextMove = state.makeMove() else { return }

                        currentState = state

                        gameboardView.onSelectPosition!(nextMove)
        }
    }
    
    private func buildPlayerState(player: Player) -> PlayerInputState {
            return PlayerInputState(player: player, gameViewController: self, gameboard: gameBoard, gameboardView: gameboardView, markViewPrototype: player.markViewPrototype, invoker: invoker)
        }
}
