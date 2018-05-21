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
    
    private let fullHealth: CGFloat = 100.0
    private let healthBarWidth: CGFloat = 100.0
    private let healthBarHeight: CGFloat = 10.0
    
    var runSpeed: CGFloat = 300.0
    var health: CGFloat = 100.0
    var damage: CGFloat = 5.0
    var defense: CGFloat = 0.2
    
    var healthBar: SKSpriteNode?

    // MARK: - init function
    public func setup() {
        healthBar = childNode(withName: "WarriorHealthBar") as? SKSpriteNode
        
        addFieldOfView()
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
    
    func hasEnemyVisibleInSight() -> Bool {
        
        guard let fieldOfView = self.childNode(withName: "fieldOfView") else { return false }
        
        let enemyCategory: UInt32 = 2
        let body = scene?.physicsWorld.body(in: fieldOfView.frame)
        
        return body?.categoryBitMask == enemyCategory
    }
    
    func runToward(_ target: SKSpriteNode?) {
        
        /**
         Stop the bodies from bouncing
         */
        physicsBody?.restitution = 0.0
        
        guard let target = target else {
            return
        }
        
        let walkAnimation = createWarriorWalkAnimation()
        let walkAction = SKAction.animate(with: walkAnimation, timePerFrame: 0.1, resize: false, restore: false)
        
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
    
    func knife(_ zombie: ZombieSpriteNode?, completion: @escaping () -> Void) {
        
        guard let zombie = zombie else {
            return
        }
        
        let knifeAnimation = createWarriorAttackAnimation()
        let knifeAction = SKAction.animate(with: knifeAnimation, timePerFrame: 0.1, resize: false, restore: false)
        
        run(knifeAction) {
            zombie.health = zombie.health - (self.damage - (self.damage * zombie.defense))
            zombie.updateHealthBar()
            completion()
        }

    }
    
    // MARK: - Private helper functions
    
    private func createWarriorWalkAnimation() -> [SKTexture] {
        
        let warriorAnimatedAtlas = SKTextureAtlas(named: "warriorMove")
        var walkFrames: [SKTexture] = []
        
        let numImages = warriorAnimatedAtlas.textureNames.count
        for i in 1..<numImages {
            let warriorTextureName = "survivor-move_knife_\(i)"
            walkFrames.append(warriorAnimatedAtlas.textureNamed(warriorTextureName))
        }
        
        return walkFrames
    }
    
    private func createWarriorAttackAnimation() -> [SKTexture] {
        
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
