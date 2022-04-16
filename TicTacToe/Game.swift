//
//  Game.swift
//  TicTacToe
//
//  Created by Victor Yang on 2022-04-10.
//  Copyright © 2022 COMP2601. All rights reserved.
//

import Foundation

class Game: Codable{ //the Game class represents a game that is played and added to the database when game is over
    var id : Int = 1
    var p1stepsX : [Int]?
    var p1stepsY : [Int]?
    //var p1steps : [Dictionary<<#Key: Hashable#>, Int>] //How do I fix this?
    var p2stepsX : [Int]?
    var p2stepsY : [Int]?
    //var p2steps : [Dictionary<<#Key: Hashable#>, Int>] //How do I fix this?
    var outcome: String?
}
