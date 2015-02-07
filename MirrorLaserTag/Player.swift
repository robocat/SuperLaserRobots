//
//  Player.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 06/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import SpriteKit

@objc protocol PlayerDelegate {
	func playerDidChangeHealth(player : Player)
}

class Player : SKSpriteNode {
	var direction : CGFloat = 0 { didSet { updateDirection() } }
	
	var controls: Controls!
	
	var shouldTurnLeft: Bool = false
	var shouldTurnRight: Bool = false
	var shouldMoveFoward: Bool = false
	
	var health : Int = 100 { didSet { delegate?.playerDidChangeHealth(self) } }
	var lastShot : CFTimeInterval
	var playerName : String
	var dead = false
	
	weak var delegate : PlayerDelegate?
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
		physicsBody = SKPhysicsBody(rectangleOfSize: size)
		//physicsBody = SKPhysicsBody(texture: texture, size: size)
		physicsBody?.affectedByGravity = false
		physicsBody?.dynamic = true
		physicsBody?.linearDamping = 10.0
		physicsBody?.angularDamping = 20.0
		physicsBody?.categoryBitMask = PhysicsType.Player.rawValue
		physicsBody?.collisionBitMask = PhysicsType.Mirror.rawValue | PhysicsType.Player.rawValue | PhysicsType.Projectile.rawValue
		physicsBody?.contactTestBitMask = PhysicsType.Mirror.rawValue | PhysicsType.Player.rawValue | PhysicsType.Projectile.rawValue
	}
	
	
	func update(timePassed: CFTimeInterval) {
		var rotationsPerSecond = 0.3
		var pixelsPerSecond : CGFloat = 1000
		
		var rotation = (π * 2) * CGFloat(rotationsPerSecond) * CGFloat(timePassed)
		
		if !dead {
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
				physicsBody?.applyImpulse(vector)
			}
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
					for i in -5...5
					{
						let pSize = size
						let offset = CGPoint(x: pSize.width * sin(-zRotation) + CGFloat(i) / 3.0, y: pSize.height * cos(zRotation) + CGFloat(i) / 3.0)
						let projectile = Projectile(position: position + offset, angle: zRotation + (CGFloat(i) / 3))
						
						let remover = SKAction.sequence([SKAction.waitForDuration(2), SKAction.removeFromParent()])
						let sound = SKAction.playSoundFileNamed(randomFireSound(), waitForCompletion: false)
						let grouped = SKAction.group([sound, remover])
						
						projectile.runAction(grouped)
						map?.addChild(projectile)
					}
					//}
					if (false) {}
				case _: break
				}
			}
		}
	}
	
	func randomFireSound() -> String {
		let rand = Int.random(Range(start: 1, end: 3))
		return "Laser\(rand).wav"
	}
}
