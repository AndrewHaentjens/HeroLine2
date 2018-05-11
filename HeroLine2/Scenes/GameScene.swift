//
//  GameScene.swift
//  HeroLine2
//
//  Created by Andrew Haentjens on 10/05/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import SpriteKit
import GameplayKit

private var warriorName = "warrior"
private var zombieName = "zombie"

class GameScene: SKScene {
    
    var warrior: WarriorSpriteNode?
    var zombie: ZombieSpriteNode?
    
    var warriorDamageLbl: SKLabelNode?
    var zombieDamageLbl: SKLabelNode?
        
    override func sceneDidLoad() {
        
        physicsWorld.contactDelegate = self
        
        warrior = self.childNode(withName: "warrior") as? WarriorSpriteNode
        zombie = self.childNode(withName: "zombie") as? ZombieSpriteNode
        
        warriorDamageLbl = warrior?.childNode(withName: "warriorDamage") as? SKLabelNode
        zombieDamageLbl = zombie?.childNode(withName: "zombieDamage") as? SKLabelNode
        
        warrior?.runToward(zombie)
        zombie?.runToward(warrior)
        
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        let minHealth: CGFloat = 0.0
        
        /**
         Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        */
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        /**
         Fight!
         */
        if firstBody.categoryBitMask == warrior?.physicsBody?.categoryBitMask &&
            secondBody.categoryBitMask == zombie?.physicsBody?.categoryBitMask {
            
            guard
                let warrior = warrior,
                let zombie = zombie else {
                    return
            }
            
            while warrior.health > minHealth
                && zombie.health > minHealth {
                    
                    warrior.club(zombie)
                    zombieDamageLbl?.text = "\(zombie.health)"
                    
                    zombie.claw(warrior)
                    warriorDamageLbl?.text = "\(warrior.health)"
                                        
            }
            
            if warrior.health <= minHealth {
                warrior.isHidden = true
            }
            
            if zombie.health <= minHealth {
                zombie.isHidden = true
            }
            
        }
        
    }
    
}
