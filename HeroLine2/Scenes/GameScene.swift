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
    
    // TODO: rewrite as protocol!
    var warrior: WarriorSpriteNode?
    var zombie: ZombieSpriteNode?
    
    var isFighting = false {
        didSet {
            if isFighting {
                
                guard
                    let warrior = warrior,
                    let zombie = zombie else {
                        return
                }
                
                resolveFightBetween(zombie, and: warrior)
            }
        }
    }
        
    override func sceneDidLoad() {
        
        physicsWorld.contactDelegate = self
        
        warrior = self.childNode(withName: "warrior") as? WarriorSpriteNode
        warrior?.setup()
        
        zombie = self.childNode(withName: "zombie") as? ZombieSpriteNode
        zombie?.setup()
        
        warrior?.runToward(zombie)
        zombie?.runToward(warrior)
        
    }
    
    private func resolveFightBetween(_ zombie: ZombieSpriteNode, and warrior: WarriorSpriteNode) {
        let minHealth: CGFloat = 0.0
        
        guard warrior.health > minHealth
            && zombie.health > minHealth else {
                
                if warrior.health <= minHealth {
                    warrior.removeFromParent()
                    return
                }
                
                if zombie.health <= minHealth {
                    zombie.removeFromParent()
                    return
                }
                
                return
        }
                
        warrior.club(zombie)
            
        zombie.claw(warrior, completion: {
            self.resolveFightBetween(zombie, and: warrior)
        })
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
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
            
            // make sure they stay put while fighting
            firstBody.pinned = true
            secondBody.pinned = true
            
            isFighting = true
        }
        
    }
    
}
