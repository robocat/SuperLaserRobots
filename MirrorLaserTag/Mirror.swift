//
//  Mirror.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 06/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import SpriteKit

class Mirror: SKSpriteNode {
	func setupPhysics() {
		physicsBody = SKPhysicsBody(texture: texture, size: size)
		physicsBody?.affectedByGravity = false
		physicsBody?.dynamic = false
		physicsBody?.categoryBitMask = PhysicsType.Mirror.rawValue
		physicsBody?.contactTestBitMask = PhysicsType.Projectile.rawValue
	}
}
