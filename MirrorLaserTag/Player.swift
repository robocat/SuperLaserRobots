//
//  Player.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 06/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import SpriteKit

class Player : SKSpriteNode {
	var direction : CGFloat = 0 { didSet { updateDirection() } }
	var health : Int = 100
    var lastShot : CFTimeInterval
	var playerName : String
	
	override init() {
		let texture = SKTexture(imageNamed: "Spaceship")
		lastShot = 0
		playerName = "Anonymous"
        super.init(texture: texture, color: nil, size: CGSize(width: 96, height: 96))
		direction = 0
		setupPhysics()
	}
    
	convenience init(playerName name : String, currentTime time : CFTimeInterval) {
        self.init()
        self.lastShot = time
		playerName = name
    }
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updateDirection() {
		zRotation = direction
	}
	
	func setupPhysics() {
		physicsBody = SKPhysicsBody(texture: texture, size: size)
		physicsBody?.affectedByGravity = false
		physicsBody?.dynamic = true
		physicsBody?.angularDamping = 8.0
		physicsBody?.categoryBitMask = PhysicsType.Player.rawValue
		physicsBody?.collisionBitMask = PhysicsType.Mirror.rawValue | PhysicsType.Player.rawValue | PhysicsType.Projectile.rawValue
		physicsBody?.contactTestBitMask = PhysicsType.Mirror.rawValue | PhysicsType.Player.rawValue | PhysicsType.Projectile.rawValue
	}
}
