//
//  Zombie.swift
//  HeroLine2
//
//  Created by Andrew Haentjens on 03/06/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import SpriteKit

class Zombie: SKSpriteNode {

    public func setup() {
        self.addFieldOfView()
    }
    
}

extension Zombie: Horde {
    
    internal var runSpeed: CGFloat {
        return 150.0
    }
    
    internal var health: CGFloat {
        return 75.0
    }
    
    internal var damage: CGFloat {
        return 7.0
    }
    
    internal var defense: CGFloat {
        return 0.0
    }
    
    internal var healthBar: SKSpriteNode? {
        return childNode(withName: "ZombieHealthBar") as? SKSpriteNode
    }
    
    func hasEnemyInSight() -> Bool {
        guard let fieldOfView = self.childNode(withName: "fieldOfView") else { return false }
    
        let body = scene?.physicsWorld.body(in: fieldOfView.frame)
        
        return body?.categoryBitMask == CollisionMaskName.player.rawValue
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
        let clawAction = SKAction.animate(with: attack, timePerFrame: 0.1, resize: false, restore: false)
        
        run(clawAction) {
            // TODO set health of enemy
        }
        
    }
    
    internal func walkAnimation() -> [SKTexture] {
        
        let zombieAnimatedAtlas = SKTextureAtlas(named: "zombieMove")
        var walkFrames: [SKTexture] = []
        
        let numImages = zombieAnimatedAtlas.textureNames.count
        for i in 1..<numImages {
            let zombieTextureName = "skeleton-move_\(i)"
            walkFrames.append(zombieAnimatedAtlas.textureNamed(zombieTextureName))
        }
        
        return walkFrames
        
    }
    
    internal func attackAnimation() -> [SKTexture] {
        
        let zombieAnimatedAtlas = SKTextureAtlas(named: "zombieAttack")
        var attackFrames: [SKTexture] = []
        
        let numImages = zombieAnimatedAtlas.textureNames.count
        for i in 1..<numImages {
            let zombieTextureName = "skeleton-attack_\(i)"
            attackFrames.append(zombieAnimatedAtlas.textureNamed(zombieTextureName))
        }
        
        return attackFrames
        
    }
    
}
