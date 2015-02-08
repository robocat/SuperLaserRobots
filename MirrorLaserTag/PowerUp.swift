//
//  PowerUp.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 07/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import SpriteKit

enum PowerUpType {
	case Health
}

class PowerUp: SKSpriteNode {
	convenience init(type: PowerUpType) {
		let texture = SKTexture(imageNamed: "healthup")
		
		self.init(texture: texture, color: nil, size: texture.size())
	}
	
	override init(texture: SKTexture!, color: NSColor!, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
		setupPhysics()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupPhysics() {
		physicsBody = SKPhysicsBody(rectangleOfSize: size)
		physicsBody?.affectedByGravity = false
		physicsBody?.dynamic = false
		physicsBody?.categoryBitMask = PhysicsType.PowerUp.rawValue
		physicsBody?.collisionBitMask = PhysicsType.Player.rawValue
		physicsBody?.contactTestBitMask = PhysicsType.Player.rawValue
	}
}
