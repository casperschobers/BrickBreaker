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
            let gameOverLabel = childNodeWithName(GameOverLabelCategoryName) as? SKLabelNode
            gameOverLabel?.text = gameWon ? "Game Won" : "Game Over"
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let gameScene = GameScene.unarchiveFromFile("GameScene") as? GameScene else { return }
        
        if let view = view {
            gameScene.scaleMode = .AspectFill
            view.presentScene(gameScene)
        }
    }

}
