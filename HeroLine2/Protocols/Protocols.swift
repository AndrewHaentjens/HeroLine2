//
//  Protocols.swift
//  HeroLine2
//
//  Created by Andrew Haentjens on 01/06/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import SpriteKit

/**
 The horde are the characters that are summoned and fight for the player
 */
protocol Horde {
    
    var runSpeed: CGFloat           { get }
    var health: CGFloat             { get }
    var damage: CGFloat             { get }
    var defense: CGFloat            { get }
    var healthBar: SKSpriteNode?    { get }
    
    func hasEnemyInSight() -> Bool
    
    func runToward(_ target: SKSpriteNode?)
    
    func attack(_ target: SKSpriteNode?)
    
    func walkAnimation() -> [SKTexture]
    
    func attackAnimation() -> [SKTexture]
    
}
