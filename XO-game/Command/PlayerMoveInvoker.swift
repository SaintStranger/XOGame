//
//  PlayerMoveInvoker.swift
//  XO-game
//
//  Created by Антон Чечевичкин on 16.09.2022.
//

import Foundation

 class PlayerMoveInvoker {
     private var commands: [PlayerMoveCommand] = []

     func add(_ command: PlayerMoveCommand) {
         commands.append(command)
     }

     func execute() {
         commands.forEach { $0.execute() }
     }

     func executeFiveMoves() {
         for i in 0..<5 {
             self.commands[i].execute()
             self.commands[i+5].execute()
         }

         commands = []
     }
 }
