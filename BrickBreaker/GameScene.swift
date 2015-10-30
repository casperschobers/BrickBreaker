//
//  GameScene.swift
//  BrickBreaker
//
//  Created by Casper Schobers on 19/10/15.
//  Copyright (c) 2015 CSA. All rights reserved.
//

import SpriteKit

private let BallCategoryName = "ball"
private let PaddleCategoryName = "paddle"
private let BlockCategoryName = "block"
private let BlockNodeCategoryName = "blockNode"

var isFingerOnPaddle = false

private let BallCategory   : UInt32 = 0x1 << 0 // 00000000000000000000000000000001
private let BottomCategory : UInt32 = 0x1 << 1 // 00000000000000000000000000000010
private let BlockCategory  : UInt32 = 0x1 << 2 // 00000000000000000000000000000100
private let PaddleCategory : UInt32 = 0x1 << 3 // 00000000000000000000000000001000

class GameScene: SKScene, SKPhysicsContactDelegate {
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        //set border for screen
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        //set bounce for the ball and set contact delegate
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
        ball.physicsBody!.applyImpulse(CGVector(dx: 10, dy: -10))
      
        //set border for bottom
        let borderRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1.0)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: borderRect)
        addChild(bottom)
        
        //set bitmask category
        let paddle = childNodeWithName(PaddleCategoryName) as! SKSpriteNode
        bottom.physicsBody!.categoryBitMask = BottomCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        
        //set contacttestbitmask
        ball.physicsBody!.contactTestBitMask = BottomCategory | BlockCategory
        
        //let to make the blocks
        let numberOfBlocks = 5
        let blockWidth = SKSpriteNode(imageNamed: "block.png").size.width
        let totalBlockWidth = blockWidth * CGFloat(numberOfBlocks)
        
        let padding: CGFloat = 10.0
        let totalPadding = padding * CGFloat(numberOfBlocks - 1)
        
        //calc the x-offset
        let xOffset = (CGRectGetWidth(frame) - totalBlockWidth - totalPadding) / 2
        
        //create blocks and add them to the GameScene
        for i in 0..<numberOfBlocks{
            let block = SKSpriteNode(imageNamed: "block.png")
            block.position = CGPoint(x: xOffset + CGFloat(CGFloat(i) + 0.5) * blockWidth + CGFloat(i-1) * padding, y :CGRectGetHeight(frame) * 0.8)
            block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
            block.physicsBody!.allowsRotation = false
            block.physicsBody!.friction = 0.0
            block.physicsBody!.affectedByGravity = false
            block.name = BlockCategoryName
            block.physicsBody!.categoryBitMask = BlockCategory
            block.physicsBody!.dynamic = false
            addChild(block)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.locationInNode(self)
        
        if let body = physicsWorld.bodyAtPoint(touchLocation), name = body.node?.name where name == PaddleCategoryName {
            print("start touching paddle")
            isFingerOnPaddle = true
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if isFingerOnPaddle{
            guard let touch =  touches.first else { return }
            let touchLocation = touch.locationInNode(self)
            let previousLocation = touch.previousLocationInNode(self)
            
            let paddle = childNodeWithName(PaddleCategoryName) as! SKSpriteNode
            
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("endend touching paddle")
        isFingerOnPaddle = false
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory{
            if let mainView = view, gameOverScene = GameOverScene.unarchiveFromFile("GameOverScene") as? GameOverScene {
                gameOverScene.gameWon = false
                gameOverScene.scaleMode = .AspectFill
                mainView.presentScene(gameOverScene)
            }
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BlockCategory{
            secondBody.node?.removeFromParent()
            if let mainView = view, gameOverScene = GameOverScene.unarchiveFromFile("GameOverScene") as? GameOverScene where gameWon {
                gameOverScene.gameWon = true
                gameOverScene.scaleMode = .AspectFit
                mainView.presentScene(gameOverScene)
            }
        }
    }
  
    var gameWon: Bool {
        var numberOfBricks = 0
        self.enumerateChildNodesWithName(BlockCategoryName) { _, _ in
            numberOfBricks += 1
        }
        
        return numberOfBricks == 0
    }
}
