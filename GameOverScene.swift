//
//  GameOverScene.swift
//  BrickBreaker
//
//  Created by Casper Schobers on 21/10/15.
//  Copyright © 2015 CSA. All rights reserved.
//

import SpriteKit

let GameOverLabelCategoryName = "gameOverLabel"

class GameOverScene: SKScene {
    
    var gameWon : Bool = false {
        didSet{
            let gameOverLabel = childNodeWithName(GameOverLabelCategoryName) as! SKLabelNode
            gameOverLabel.text = gameWon ? "Game Won" : "Game Over"
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let view = view {
            let gameScene = GameScene.unarchiveFromFile("GameScene") as! GameScene
            gameScene.scaleMode = .AspectFill
            view.presentScene(gameScene)
        }
    }

}
