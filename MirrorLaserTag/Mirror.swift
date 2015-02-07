//
//  Mirror.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 06/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import SpriteKit

class Mirror: SKSpriteNode {
	
	convenience init(position: CGPoint, angle: CGFloat) {
		// let texture = SKTexture(imageNamed: "bullet")
		// self.init(texture: nil, color: nil, size: CGSize(width: 200, height: 10))
		let color = NSColor.yellowColor()
		self.init(color: color, size: CGSize(width: 200, height: 10))
		self.position = position
		self.zRotation = angle
		self.setupPhysics()
	}
	
	func setupPhysics() {
		physicsBody = SKPhysicsBody(rectangleOfSize: size)
		physicsBody?.affectedByGravity = false
		physicsBody?.dynamic = false
		physicsBody?.categoryBitMask = PhysicsType.Mirror.rawValue
		physicsBody?.contactTestBitMask = PhysicsType.Projectile.rawValue
	}
}
