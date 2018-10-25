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
    var mapShape: MapShape! {get set}
    var pieceSize: PieceSize! {get set}
    var position: Int! {get set}
    var gameRenderMap: [Int] {get set}
    var gamePieces: [Piece] {get set}
    var touchArea: CGFloat {get set}
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
        if x >= p.x - touchArea && x <= p.x + touchArea + CGFloat(p.width) && y >= p.y - touchArea && y <= p.y + touchArea + CGFloat(p.height) {
            return true
        } else {
            return false
        }
    }
    func isColoredBlock(_ type: Int) -> Bool {
        if type % 10 == 0 && type != Block.wall.type {
            return true
        } else {
            return false
        }
    }
    func isWall(_ type: Int) -> Bool {
        if type == Block.wall.type {
            return true
        } else {
            return false
        }
    }
    func isNotEmpty(_ type: Int) -> Bool {
        if type == Block.empty.type {
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
        if  p != Block.empty.type && p == self.position - 1 || p == self.position + 1 || p == self.position + self.mapShape.column || p == self.position - self.mapShape.column {
            return false
        } else {
            return true
        }
    }
    func checkIfBoardIsFilled() -> Bool {
        for piece in gamePieces {
            if piece.type == Block.empty.type {
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
        if p == position + 1 || p == position - 1 || p == position + self.mapShape.column || p == position - self.mapShape.column {
            return true
        } else {
            return false
        }
        
    }
    func noPieceSelected() -> Bool {
        if selectedPiece == nil {
            return true
        }
        return false
    }
}