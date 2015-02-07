//
//  Projectile.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 06/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import SpriteKit

class Projectile: SKSpriteNode {
	
	convenience init(position: CGPoint, angle: CGFloat) {
		let texture = SKTexture(imageNamed: "bullet")
		self.init(texture: texture, color: nil, size: texture.size())
        self.position = position
        self.zRotation = angle - π/2
        setupPhysics()
	}
	
	override init(texture: SKTexture!, color: NSColor!, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func setupPhysics() {
		physicsBody = SKPhysicsBody(texture: texture, size: size)
		physicsBody?.affectedByGravity = false
		physicsBody?.dynamic = true
		physicsBody?.categoryBitMask = PhysicsType.Projectile.rawValue
		physicsBody?.collisionBitMask = PhysicsType.Mirror.rawValue | PhysicsType.Player.rawValue
		physicsBody?.contactTestBitMask = PhysicsType.Mirror.rawValue | PhysicsType.Player.rawValue
		//physicsBody?.restitution = 1.0
		//physicsBody?.allowsRotation = true
        
        let v = CGVector(dx: 500.0 * -cos(self.zRotation), dy: -500.0 * sin(self.zRotation))
        physicsBody?.velocity = v
	}
}
