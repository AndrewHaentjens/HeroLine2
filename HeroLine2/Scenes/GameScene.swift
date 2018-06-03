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

private var topCastleName = "topCastle"
private var bottomCastleName = "bottomCastle"

class GameScene: SKScene {
    
    var warrior: Warrior!
    var zombie: Zombie!
    
    var topCastle: CastleSpriteNode!
    var bottomCastle: CastleSpriteNode!
    
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
        
        topCastle = self.childNode(withName: topCastleName) as? CastleSpriteNode
        bottomCastle = self.childNode(withName: bottomCastleName) as? CastleSpriteNode
        
        warrior = self.childNode(withName: warriorName) as? Warrior
        warrior.setup()
        
        zombie = self.childNode(withName: zombieName) as? Zombie
        zombie.setup()
        
        warrior.runToward(bottomCastle)
        zombie.runToward(topCastle)
        
        if warrior.hasEnemyInSight() {
            warrior.runToward(zombie)
        }
        
        if zombie.hasEnemyInSight() {
            zombie.runToward(warrior)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if zombie.hasEnemyInSight() {
            zombie.runToward(warrior)
        }
        
        if warrior.hasEnemyInSight() {
            warrior.runToward(zombie)
        }
        
    }
    
    private func resolveFightBetween(_ zombie: Zombie, and warrior: Warrior) {
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
        
        warrior.attack(zombie)
        
/** TODO: adjust
        warrior.knife(zombie, completion: {
            zombie.claw(warrior, completion: {
                self.resolveFightBetween(zombie, and: warrior)
            })
        })
*/
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
        
        if let secondBodyCategoryBitMask = CollisionMaskName(rawValue: secondBody.categoryBitMask) {
            
            switch secondBodyCategoryBitMask {
            case .fieldOfVision:
                break
            default:
                break
            }
            
        }
        
        /**
         Fight!
         */
        if (firstBody.categoryBitMask == warrior?.physicsBody?.categoryBitMask &&
            secondBody.categoryBitMask == zombie?.physicsBody?.categoryBitMask) ||
            (firstBody.categoryBitMask == zombie?.physicsBody?.categoryBitMask &&
            secondBody.categoryBitMask == warrior.physicsBody?.categoryBitMask) {
            
            // make sure they stay put while fighting
            firstBody.pinned = true
            secondBody.pinned = true
            
            isFighting = true
        }
        
    }
    
}
