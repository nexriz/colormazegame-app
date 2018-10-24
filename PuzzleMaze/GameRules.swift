//
//  GameRules.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 10/23/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import Foundation
import UIKit

protocol GameRules {
    var selectedPiece: Piece! {get set}
    var position: Int {get set}
    var gameRenderMap: [Int] {get set}
    var gamePieces: [Piece] {get set}
    var xPieces: Int {get set}
    func touchCollideWithPiece(_ x: CGFloat, _ y: CGFloat, _ p: Piece) -> Bool
    func isColoredBlock(_ type: Int) -> Bool
    func isWall(_ type: Int) -> Bool
    func isNotEmpty(_ type: Int) -> Bool
    func isPieceConnected(_ p: Piece) -> Bool
    func cannotMoveToPiece(_ p: Int) -> Bool
    func checkIfBoardIsFilled() -> Bool
    func isNeighborSameColor(p: Int) -> Bool
}

extension GameRules {
    func touchCollideWithPiece(_ x: CGFloat, _ y: CGFloat, _ p: Piece) -> Bool {
        if x >= p.x && x <= p.x + CGFloat(p.width) && y >= p.y && y <= p.y + CGFloat(p.height) {
            return true
        } else {
            return false
        }
    }
    func isColoredBlock(_ type: Int) -> Bool {
        if type % 10 == 0 && type != Block.wall {
            return true
        } else {
            return false
        }
    }
    func isWall(_ type: Int) -> Bool {
        if type == Block.wall {
            return true
        } else {
            return false
        }
    }
    func isNotEmpty(_ type: Int) -> Bool {
        if type == Block.empty_block {
            return false
        } else {
            return true
        }
    }
    func isPieceConnected(_ p: Piece) -> Bool {
        if p.isConnected == true {
            return true
        }
        return false
    }
    func cannotMoveToPiece(_ p: Int) -> Bool{
        if  p != Block.empty_block && p == self.position - 1 || p == self.position + 1 || p == self.position + self.xPieces || p == self.position - self.xPieces {
            return true
        } else {
            return false
        }
    }
    func checkIfBoardIsFilled() -> Bool {
        for blockType in gameRenderMap {
            if blockType == Block.empty_block {
                return false
            }
        }
        return true
    }
    func checkIfPiecesIsConnected() -> Bool{
        for p in gamePieces where p.isConnected == false && isColoredBlock(p.type){
            return false
        }
        return true
    }
    func isNeighborSameColor(p: Int) -> Bool {
        if p == position + 1 || p == position - 1 || p == position + self.xPieces || p == position - self.xPieces{
            return true
        } else {
            return false
        }
        
    }
}
