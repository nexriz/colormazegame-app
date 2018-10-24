//
//  ViewController.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 9/20/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import UIKit

struct MapSize {
    let row: Int
    let column: Int
}

struct PieceSize {
    let width: Float
    let height: Float
    let spacing: Float
}

struct Settings {
    let mapSize: MapSize
    let pieceSize: PieceSize
}

struct Map {
    let map: [[Int]]
    let settings: Settings
    
}


class ViewController: UIViewController {
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var gameArea: UIView!

    // 0: No Block
    // 1: Empty Block
    // 10: Color X Start Block, 11: Color X Filled Block
    // 20: Color Y Start Block, 21: Color Y Filled Block
    // etc...
    
    var gameMap: [[Int]] = [
        [10, 30,  1, 30, 20, 30, 10,  40],
        [ 1,  1,  1,  1,  1, 1,   1,  1],
        [ 1,  1, 40,  1,  1, 1,  10,  1],
        [10,  1,  1, 20, 40, 1,   40,  1],
        [ 0,  0, 10,  1, 10, 1,   1,  1],
        [ 0,  1,  1,  1,  30, 1,  0, 20],
        [ 0,  1,  0,  1,  1, 1,  0,  1],
        [20,  1,  0,  0,  0, 1,  1,  1]
        
    ]
    
    var myGame: GameBoard<Piece>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myGame = GameBoard(board: gameArea, map: gameMap)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.gameArea)
        myGame!.onTouch(location.x, location.y)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.gameArea)
        myGame!.onTouchMove(location.x, location.y)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self.gameArea)
        myGame!.onTouchEnd(location.x, location.y)
    }
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }


}



//                if isColoredBlock(piece.type) {
//                    selectedColor = piece.id
//                }
//
//                if isColoredBlock(piece.type) {
//                    currentColor = applyColor(for: piece.type)
//                    print(piece.id)
//                    selectedColor = piece.id
//                }
//
//
//                if !canMoveToPiece(piece.id) {return}
//                if isWall(piece.type) {return}
//
//
//                if
//                gameRenderMap[piece.id] = piece.type
//
//                piece.label.layer.backgroundColor = currentColor
//                selectedColor = piece.id
//                if gameRenderMap[selectedColor] == piece.type {return}

