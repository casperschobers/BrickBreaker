//
//  GameViewController.swift
//  BrickBreaker
//
//  Created by Casper Schobers on 19/10/15.
//  Copyright (c) 2015 CSA. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            do {
                let sceneData = try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
                let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
                
                archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
                guard let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as? SKScene else { return nil }
                archiver.finishDecoding()
              
                return scene
            } catch {
                print("[ERROR] \(error)")
            }
        }
      
        return nil
    }
}


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameOverScene.unarchiveFromFile("GameOverScene") as? GameOverScene {
            // Configure the view.
            let skView = self.view as? SKView
            skView?.showsFPS = true
            skView?.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView?.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView?.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
