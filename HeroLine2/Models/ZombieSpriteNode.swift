//
//  ZombieSpriteNode.swift
//  HeroLine2
//
//  Created by Andrew Haentjens on 10/05/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import SpriteKit

class ZombieSpriteNode: SKSpriteNode {

    var runSpeed: CGFloat = 150.0
    var health: CGFloat = 75.0
    var damage: CGFloat = 7
    var defense: CGFloat = 0.0
    
    func runToward(_ target: SKSpriteNode?) {
        
        /**
         Stop the bodies from bouncing
         */
        physicsBody?.restitution = 0.0
        
        guard let target = target else {
            return
        }
        
        let walkAnimation = createZombieWalkAnimation()
        let walkAction = SKAction.animate(with: walkAnimation, timePerFrame: 0.1, resize: false, restore: true)
        
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
    
    func claw(_ warrior: WarriorSpriteNode?, completion: @escaping () -> Void) {
        
        guard let warrior = warrior else {
            return
        }
        
        let clawAnimation = createZombieAttackAnimation()
        let clawAction = SKAction.animate(with: clawAnimation, timePerFrame: 0.1, resize: false, restore: false)
        
        run(clawAction) {
            warrior.health = warrior.health - (self.damage - (self.damage * warrior.defense))
            completion()
        }

    }
    
    private func createZombieWalkAnimation() -> [SKTexture] {
        
        let zombieAnimatedAtlas = SKTextureAtlas(named: "Move")
        var walkFrames: [SKTexture] = []
        
        let numImages = zombieAnimatedAtlas.textureNames.count
        for i in 1..<numImages {
            let zombieTextureName = "skeleton-move_\(i)"
            walkFrames.append(zombieAnimatedAtlas.textureNamed(zombieTextureName))
        }
        
        return walkFrames
    }
    
    private func createZombieAttackAnimation() -> [SKTexture] {
        
        let zombieAnimatedAtlas = SKTextureAtlas(named: "Attack")
        var attackFrames: [SKTexture] = []
        
        let numImages = zombieAnimatedAtlas.textureNames.count
        for i in 1..<numImages {
            let zombieTextureName = "skeleton-attack_\(i)"
            attackFrames.append(zombieAnimatedAtlas.textureNamed(zombieTextureName))
        }
        
        return attackFrames
    }
}
