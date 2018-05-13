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
        zombie = self.childNode(withName: "zombie") as? ZombieSpriteNode
        
        warriorDamageLbl = warrior?.childNode(withName: "warriorDamage") as? SKLabelNode
        zombieDamageLbl = zombie?.childNode(withName: "zombieDamage") as? SKLabelNode
        
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
        
        zombieDamageLbl?.text = "\(zombie.health)"
        zombieDamageLbl?.run(SKAction.fadeIn(withDuration: 0.1))
            
        zombie.claw(warrior, completion: {
            self.warriorDamageLbl?.text = "\(warrior.health)"
            
            self.warriorDamageLbl?.run(SKAction.fadeIn(withDuration: 0.1)) {
                self.resolveFightBetween(zombie, and: warrior)
                
            }
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
            
            warrior?.run(SKAction.stop())
            warrior?.removeAllActions()
            
            zombie?.run(SKAction.stop())
            zombie?.removeAllActions()
            
            isFighting = true
        }
        
    }
    
}
