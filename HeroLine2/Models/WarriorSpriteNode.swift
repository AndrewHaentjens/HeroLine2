//
//  WarriorSpriteNode.swift
//  HeroLine2
//
//  Created by Andrew Haentjens on 10/05/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import SpriteKit

/**
 Warrior Class
 */

class WarriorSpriteNode: SKSpriteNode {
    
    var runSpeed: CGFloat = 300.0
    var health: CGFloat = 100.0
    var damage: CGFloat = 5.0
    var defense: CGFloat = 0.2

    func runToward(_ target: SKSpriteNode?) {
        
        /**
         Stop the bodies from bouncing
         */
        physicsBody?.restitution = 0.0
        
        guard let target = target else {
            return
        }
        
        let targetPosition = target.position
        
        let angle = atan2(position.y - targetPosition.y, position.x - targetPosition.x) + CGFloat(Double.pi)
        let rotateAction = SKAction.rotate(toAngle: angle + CGFloat(Double.pi * 0.5), duration: 0.0)
        
        run(rotateAction)
        
        let velocotyX = runSpeed * cos(angle)
        let velocityY = runSpeed * sin(angle)
        
        let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
        physicsBody!.velocity = newVelocity
        
    }
    
    func club(_ zombie: ZombieSpriteNode?) {
        
        guard let zombie = zombie else {
            return
        }
        
        zombie.health = zombie.health - (damage - (damage * zombie.defense))
    }
    
}
