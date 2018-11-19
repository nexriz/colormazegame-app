//
//  GameModel.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 10/13/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

struct MapShape {
    let row: Int
    let column: Int
}
struct BoardSize {
    let width: Int
    let height: Int
}
struct PieceSize {
    let width: Float
    let height: Float
    let spacing: Float
}


class GameBoard<T: Piece>: GameRules {
    var t = false
    var mySound = Sounds()
    private var gameArea: UIView!
    var mapShape: MapShape!
    var boardSize: BoardSize!
    var pieceSize: PieceSize!
    var sound = Sounds()
    var defaultSpacing: Float = 1// cant be zero
    var touchArea: CGFloat   = 10
    
    var selectedPiece: Piece!
    var selectedPieceEnd: Piece! = nil
    var position: Int!
    private var canMove = true

    private var gameMap = [[Int]]()
    var gameRenderMap   = [Int]()
    var gamePieces      = [Piece]()

    init(board: UIView, map: [[Int]]) {
        self.gameArea = board
        self.gameMap = map
        createNewGame(map: map)
    }
    deinit {
        print("GameModel deinited")
    }
    private func updateWallSize() {
        for p in gamePieces {
            p.ifWallUpdateSize()
        }
    }
    private func removeAllElements() {
        for piece in gamePieces { piece.label.removeFromSuperview() }
        gameMap       = [[Int]]()
        gameRenderMap = [Int]()
        gamePieces    = [Piece]()
        
    }
    func createNewGame(map: [[Int]]) {
        removeAllElements()
        mapShape = getRowsAndColumns(for: map)
        boardSize = getSize(for: gameArea)
        pieceSize = getPieceSize(with: mapShape, and: boardSize)
        gameRenderMap = render(map)
        renderGameBoard()
        updateWallSize()
        printSettings()

    }
    func printSettings() {
        print("Settings:")
        print("  ", mapShape!)
        print("  ", boardSize!)
        print("  ", pieceSize!)
    }
    func stopBoard() {
        self.canMove = false
        self.clearColoredPath()
    }
    func startBoard() {
        self.canMove = true
        
    }
    func onTouch(_ x: CGFloat, _ y: CGFloat) {
//        if canMove == false { return}
        canMove = true
        if let piece = getPieceFromCoord(x: x, y: y) {
            if isColoredBlock(piece.block.type){
                selectedPiece = piece as! T
                if piece.isLit {
                    canMove = false
                    piece.hold() {
                        
                    }
                    mySound.missBubble()
                    selectedPiece.release() {
                        self.clearColoredPath()
                    }
                    

                    return

                }
                selectedPiece.isLit = true
                selectedPiece.litBlock()
//                sound.selectSound.play()
                Vibration.sound(1130).vibrate()
//                sound.play()
                position = piece.id
                print("Begin ", "Selected Piece:",selectedPiece.id)
            }
        }
    }
    func checkIfPieceMatchPath(p: Piece, pos: Int?) -> Bool {
        
        if let mpos = pos {
            if gamePieces[mpos].connectedWith == p.id {
                return true
            }
            return checkIfPieceMatchPath(p: p, pos: gamePieces[mpos].connectedWith)
        }
        return false

    }
    func resetPiecesPath(p: Piece, pos: Int?) {
        if let mpos = pos {
            
            if gamePieces[mpos].connectedWith == p.id {
                gamePieces[mpos].dimBlock()
                if !isColoredBlock(gamePieces[mpos].block.type) {
                    gamePieces[mpos].updatePiece(block: Block.empty)
                    gameRenderMap[mpos] = 1
                    Vibration.sound(1397).vibrate()
                }
                if selectedPieceEnd != nil {
                    selectedPieceEnd.dimBlock()
                    Vibration.sound(1130).vibrate()
                }
                
                self.position = p.id
                return
            }

            resetPiecesPath(p: p, pos: gamePieces[mpos].connectedWith)
            gamePieces[mpos].dimBlock()
            if !isColoredBlock(gamePieces[mpos].block.type) {
                gamePieces[mpos].updatePiece(block: Block.empty)
                gameRenderMap[mpos] = 1
                Vibration.sound(1397).vibrate()
            }
            
            
            return
        }
        return
    }
    func onTouchMove(_ x: CGFloat, _ y: CGFloat) {
        if noPieceSelected() {return}
        if let piece = getPieceFromCoord(x: x, y: y) {
            
            if let selectEnd = selectedPieceEnd {
                if selectEnd.id != piece.id {
                    selectedPieceEnd.dimBlock()
                    selectedPieceEnd = nil
                }
            }
            if t {
                            if checkIfPieceMatchPath(p: piece, pos: position) {
                                print("match")
                                resetPiecesPath(p: piece, pos: position)
                                if let sp = selectedPieceEnd {
                                    selectedPieceEnd.dimBlock()
                                }
                                
                                selectedPieceEnd = nil
                                t = false
                            }
            }
            if !canMove {
 
//                else if gamePieces[self.position].connectedWith == piece.id {
//                    print("cant move - ", piece.id)
//                    gamePieces[self.position].dimBlock()
//                    gamePieces[self.position].updatePiece(block: Block.empty)
//                    gameRenderMap[position] = 1
//                    self.position = piece.id
//                    print("previous")
//                    Vibration.sound(1397).vibrate()
//                    selectedPieceEnd.dimBlock()
////
//                    selectedPieceEnd = nil
//                    canMove = true
//                }
                return
                
            }

            
            if piece.block.type == selectedPiece.block.type {
                if piece.id == position {canMove = true}
                if piece.id != selectedPiece.id && !cannotMoveToPiece(piece.id) || (isPieceConnected(piece) && isColoredBlock(piece.block.type)){
//                    sound.play()

                    if selectedPieceEnd == nil {
                        Vibration.sound(1130).vibrate()
                    }
                    
                    piece.litBlock()
                    selectedPieceEnd = piece
                    selectedPieceEnd.connectedWith = position
                    
                    return
                }
            }
            if cannotMoveToPiece(piece.id) || isWall(piece.block.type) || isNotEmpty(piece.block.type){
                if checkIfPieceMatchPath(p: piece, pos: position) {
                    resetPiecesPath(p: piece, pos: position)
                }
//                if gamePieces[self.position].connectedWith == piece.id {
//                    gamePieces[self.position].dimBlock()
//                    gamePieces[self.position].updatePiece(block: Block.empty)
//                    gameRenderMap[position] = 1
//                    self.position = piece.id
//                    print("previous")
//                    Vibration.sound(1397).vibrate()
//                }
                return
                
            }
            if canMove  {
//                sound.play()
                
              
                piece.connectedWith = position
                Vibration.sound(1397).vibrate()
                position = piece.id
                piece.updatePiece(block: selectedPiece.block.upp())
                gameRenderMap[position] = selectedPiece.block.upp().type
                piece.litBlock()
                print("Moving ","Selected Piece:",selectedPiece.id, "Position:",piece.id, "- connectedWith:", piece.connectedWith)
                
                
            }
            
        }
    }
    func onTouchEnd(_ x: CGFloat, _ y: CGFloat, _ win: () -> (), _ lose: () -> ()) {
        if noPieceSelected() {return}

        if let piece = getPieceFromCoord(x: x, y: y) {
            guard selectedPieceEnd != nil else {
                clearColoredPath()
                lose()
                selectedPieceEnd = nil
                return
            }
            
            if piece.block.type == selectedPiece.block.type || isNearSelectedBlock(x, y, selectedPieceEnd) && selectedPieceEnd.block.type == selectedPiece.block.type {
                print("End ","Selected Piece:",selectedPiece.id, "Position:",position, "End Piece:", selectedPieceEnd.id)
                if (piece.id != selectedPiece.id || isNearSelectedBlock(x, y, selectedPieceEnd)) && (isNeighborSameColor(p: piece.id) || isNeighborSameColor(p: selectedPieceEnd.id)) && (piece.isConnected == false || selectedPieceEnd.isConnected == false) {
                    
                    print("connected")
                    selectedPieceEnd.isConnected = true
                    selectedPieceEnd.litBlock()
                    selectedPieceEnd.isLit = true
                    selectedPiece.isConnected = true
                    selectedPiece.connectedWith = piece.id
                    selectedPiece = nil
                    selectedPieceEnd = nil
                    
                    
                    if checkIfBoardIsFilled() && checkIfPiecesIsConnected() {
                        selectedPiece = nil;print("Board is filled", " All pieces is connected")
                        win()
                    }
                } else {
                    print("Connected wrong")
                    clearColoredPath()
                    lose()
                }
            } else {
                clearColoredPath()
                lose()
            }
        } else {
            clearColoredPath()
            lose()
        }
        canMove = true
    }
    private func clearColoredPath() {
        if noPieceSelected() {return}
        for piece in gamePieces {
            if piece.block.type == selectedPiece.block.upp().type {
                piece.updatePiece(block: Block.empty)
                piece.dimBlock()
                
                gameRenderMap[piece.id] = Block.empty.type
            }
            if piece.block.type == selectedPiece.block.type {
                piece.isConnected = false
            }

        }
        selectedPiece.dimBlock()
        dimAllColoredBlock()
        position = nil
        selectedPiece = nil
        selectedPieceEnd = nil
    }
    func dimAllColoredBlock() {
        for piece in gamePieces {
            if piece.block.type == selectedPiece.block.type && piece.isLit == true {
                piece.dimBlock()
            }
        }
    }
    func getAllStartingPositons(type: Int) -> [Int] {
        var pos = [Int]()
        for (i, Btype) in gameRenderMap.enumerated() {
            if Btype == type {
                pos.append(i)
            }
        }
        return pos
    }
    private func getPieceFromCoord(x:CGFloat, y: CGFloat) -> Piece? {
        for piece in gamePieces {
            if touchCollideWithPiece(x, y, piece) {
                return piece
            }
        }
        return nil
    }
    
    private func render(_ arr: [[Int]]) -> [Int] {
        var temp = [Int]()
        for row in arr {
            for column in row {
                temp.append(column)
            }
        }
        return temp
    }
    private func renderGameBoard() {
        let offsetX: Float = (Float(gameArea.frame.width) - (pieceSize.width + pieceSize.spacing) * Float(mapShape.column)) / 2
        var Y: Float = 0;
        var X: Float = 0 + offsetX + pieceSize.spacing / 2;

        for (i, blockType) in gameRenderMap.enumerated() {
            let block = getBlockFrom(type: blockType)
            let piece = Piece(id: i, X: CGFloat(X), Y: CGFloat(Y), width: pieceSize.width, height: pieceSize.height, block: block)
            
            piece.updatePiece(block: block)
            piece.fadeIn()
            
            gameArea.addSubview(piece.label)
            gamePieces.append(piece as! T)
            X += pieceSize.width + pieceSize.spacing
            if(((i + 1) % mapShape.column) == 0) {
                Y += pieceSize.height + pieceSize.spacing
                X = 0 + offsetX + pieceSize.spacing / 2
            }
        }
    }
    func spinAll() {
        for p in gamePieces {
            p.spin()
        }
    }
    func resetspinAll() {
        for p in gamePieces {
            p.resetSpin()
        }
    }
    private func getBlockFrom(type: Int) -> Block {
        for block in Block.allCases {
            if type == block.type {
                return block
            }
        }
        return Block.empty
    }
    private func getRowsAndColumns(for map: [[Int]]) -> MapShape {
        let row = map.count
        let column = map[0].count
        let size = MapShape(row: row, column: column)
        return size
    }
    private func getSize(for board: UIView) -> BoardSize {
        return BoardSize(width: Int(board.frame.width), height: Int(board.frame.height))
    }
    private func getPieceSize(with map: MapShape, and board: BoardSize) -> PieceSize {
        let biggest = (map.column > map.row ? map.column : map.row)
        let pS = Float(board.width) / Float(biggest)
        let space = Float(pS - (Float(Int(pS / 10) * 10)))
        let spacing = self.defaultSpacing
//            (space < self.defaultSpacing ? self.defaultSpacing : space)
        return PieceSize(width: pS - spacing, height: pS - spacing, spacing: spacing)
    }

}


