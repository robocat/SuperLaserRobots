//
//  Projectile.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 06/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import SpriteKit

class Projectile: SKSpriteNode {
	func setupPhysics() {
		physicsBody = SKPhysicsBody(texture: texture, size: size)
		physicsBody?.affectedByGravity = false
		physicsBody?.dynamic = true
		physicsBody?.categoryBitMask = PhysicsType.Projectile.rawValue
		physicsBody?.contactTestBitMask = PhysicsType.Mirror.rawValue | PhysicsType.Player.rawValue
	}
}
