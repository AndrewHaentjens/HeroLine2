//
//  Warrior.swift
//  HeroLine2
//
//  Created by Andrew Haentjens on 01/06/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import SpriteKit

class Warrior: SKSpriteNode {
    
    public func setup() {
        self.addFieldOfView()
    }
    
}

extension Warrior: Horde {
    
    internal var runSpeed: CGFloat {
        return 300.0
    }
    
    internal var health: CGFloat {
        return 100.0
    }
    
    internal var damage: CGFloat {
        return 5.0
    }
    
    internal var defense: CGFloat {
        return 0.2
    }
    
    internal var healthBar: SKSpriteNode? {
        return childNode(withName: "WarriorHealthBar") as? SKSpriteNode
    }
    
    func hasEnemyInSight() -> Bool {
        
        guard let fieldOfView = self.childNode(withName: "fieldOfView") else { return false }
        
        let body = scene?.physicsWorld.body(in: fieldOfView.frame)
        
        return body?.categoryBitMask == CollisionMaskName.enemy.rawValue

    }
    
    func runToward(_ target: SKSpriteNode?) {
        
        /**
         Stop the bodies from bouncing
         */
        physicsBody?.restitution = 0.0
        
        guard let target = target else {
            return
        }
        
        let walk = walkAnimation()
        let walkAction = SKAction.animate(with: walk, timePerFrame: 0.1, resize: false, restore: false)
        
        run(SKAction.repeatForever(walkAction))
        
        let targetPosition = target.position
        
        let angle = atan2(position.y - targetPosition.y, position.x - targetPosition.x) + CGFloat(Double.pi)
        let rotateAction = SKAction.rotate(toAngle: angle + CGFloat(Double.pi * 0.5), duration: 0.0)
        
        run(rotateAction)
        
        let velocotyX = runSpeed * cos(angle)
        let velocityY = runSpeed * sin(angle)
        
        let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
        physicsBody!.velocity = newVelocity
        
    }
    
    func attack(_ target: SKSpriteNode?) {
        
        let attack = attackAnimation()
        let knifeAction = SKAction.animate(with: attack, timePerFrame: 0.1, resize: false, restore: false)
        
        run(knifeAction) {
            // TODO set healthbar of opponent
        }
    }
    
    internal func walkAnimation() -> [SKTexture] {
        
        let warriorAnimatedAtlas = SKTextureAtlas(named: "warriorMove")
        var walkFrames: [SKTexture] = []
        
        let numImages = warriorAnimatedAtlas.textureNames.count
        for i in 1..<numImages {
            let warriorTextureName = "survivor-move_knife_\(i)"
            walkFrames.append(warriorAnimatedAtlas.textureNamed(warriorTextureName))
        }
        
        return walkFrames
        
    }
    
    internal func attackAnimation() -> [SKTexture] {
        
        let warriorAnimatedAtlas = SKTextureAtlas(named: "warriorAttack")
        var attackFrames: [SKTexture] = []
        
        let numImages = warriorAnimatedAtlas.textureNames.count
        for i in 1..<numImages {
            let warriorTextureName = "survivor-meleeattack_knife_\(i)"
            attackFrames.append(warriorAnimatedAtlas.textureNamed(warriorTextureName))
        }
        
        return attackFrames
        
    }
    
}
