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

	var controls: Controls!

	var shouldTurnLeft: Bool = false
	var shouldTurnRight: Bool = false
	var shouldMoveFoward: Bool = false
	
	var health : Int = 100
    var lastShot : CFTimeInterval
	var playerName : String

	weak var map : Map?
	
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

	
	func update(timePassed: CFTimeInterval) {
		var rotationsPerSecond = 0.2
		var pixelsPerSecond : CGFloat = 5000
		
		var rotation = (π * 2) * CGFloat(rotationsPerSecond) * CGFloat(timePassed)
		
		if shouldTurnLeft {
			//player.direction += rotation
			physicsBody?.applyAngularImpulse(rotation)
		} else if shouldTurnRight {
			//player.direction -= rotation
			physicsBody?.applyAngularImpulse(-rotation)
		}
		
		if shouldMoveFoward {
			let vector = CGVector(dx: sin(-zRotation), dy: cos(zRotation)) * pixelsPerSecond * CGFloat(timePassed)
			//player.runAction(SKAction.moveBy(vector, duration: 0))
			physicsBody?.applyForce(vector)
		}
	}
	
	func performCommand(command: Command) {
		switch command {
		case .TurnLeft: shouldTurnLeft = true
		case .TurnRight: shouldTurnRight = true
		case .Forward: shouldMoveFoward = true
		case _: break
		}
	}
	
	func handleKeyDown(keyCode: UInt16) {
		if let key = Controls.Key(rawValue: Int(keyCode)) {
			if let command = controls.mappings[key] {
				performCommand(command)
			}
		}
	}
	
	func handleKeyUp(keyCode: UInt16) {
		if let key = Controls.Key(rawValue: Int(keyCode)) {
			if let command = controls.mappings[key] {
				switch command {
				case .TurnLeft: shouldTurnLeft = false
				case .TurnRight: shouldTurnRight = false
				case .Forward: shouldMoveFoward = false
				case .Fire:
					//if (time - lastShot > 0.2) {
					//	lastShot = time
						let pSize = size
						let offset = CGPoint(x: pSize.width * -sin(zRotation), y: pSize.height * cos(zRotation))
						let projectile = Projectile(position: position + offset, angle: zRotation)
						map?.addChild(projectile)
					//}
					if (false) {}
				case _: break
				}
			}
		}
	}
}
