//
//  ZombieSpriteNode.swift
//  HeroLine2
//
//  Created by Andrew Haentjens on 10/05/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import SpriteKit

class ZombieSpriteNode: SKSpriteNode {
    
    /**
     Possible refactor of  how the health reduction is handled
     Maybe pass the new health to the setHealthBar function instead of add fullHealth var?
     */

    private let fullHealth: CGFloat = 75.0
    private let healthBarWidth: CGFloat = 100.0
    private let healthBarHeight: CGFloat = 10.0
    
    var runSpeed: CGFloat = 150.0
    var health: CGFloat = 75.0
    var damage: CGFloat = 7
    var defense: CGFloat = 0.0

    var healthBar: SKSpriteNode?
    
    // MARK: - init function
    public func setup() {
        healthBar = childNode(withName: "ZombieHealthBar") as? SKSpriteNode
    }
    
    // MARK: - Health bar
    
    public func updateHealthBar() {
        
        guard health > 0 else {
            return
        }
        
        let ratio = health / fullHealth
        let newWidth: CGFloat = healthBarWidth * ratio
        
        healthBar?.run(SKAction.resize(toWidth: newWidth, duration: 0.1))
    }
    
    // MARK: - Actions
    
    public func runToward(_ target: SKSpriteNode?) {
        
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
    
    public func claw(_ warrior: WarriorSpriteNode?, completion: @escaping () -> Void) {
        
        guard let warrior = warrior else {
            return
        }
        
        let clawAnimation = createZombieAttackAnimation()
        let clawAction = SKAction.animate(with: clawAnimation, timePerFrame: 0.1, resize: false, restore: false)
        
        run(clawAction) {
            warrior.health = warrior.health - (self.damage - (self.damage * warrior.defense))
            warrior.updateHealthBar()
            completion()
        }

    }
    
    // MARK: - Private helper functions
    
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
