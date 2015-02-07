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
	
	var health : Int = 100 {
		didSet {
			delegate?.playerDidChangeHealth(self)
			
			if health < 30 {
				startFlash()
			} else {
				stopFlash()
			}
		}
	}
	
	var lastShot : CFTimeInterval
	var playerName : String
	var dead = false
	var playerColor : String = "green" { didSet { texture = SKTexture(imageNamed: "\(playerColor)1") } }
	
	weak var delegate : PlayerDelegate?
	weak var map : Map?
	
	override init() {
		lastShot = 0
		playerName = "Anonymous"
		super.init(texture: nil, color: nil, size: CGSize(width: 96, height: 96))
		direction = 0
		setupPhysics()
		
		let heal = SKAction.runBlock { if !self.dead { self.health = min(self.health + 1, 100) } }
		let wait = SKAction.waitForDuration(3)
		let sequence = SKAction.sequence([heal, wait])
		runAction(SKAction.repeatActionForever(sequence))
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
	
	enum State : Printable {
		case Stand
		case Walk
		case Shoot
		
		var description : String {
			switch self {
			case .Stand: return "Stand"
			case .Walk: return "Walk"
			case .Shoot: return "Shoot"
			}
		}
	}
	
	var moving = false
	var state = State.Stand
	
	func playAnimation(state : State, frames : [SKTexture]) {
		if self.state != state {
			self.state = state
			let animation = SKAction.animateWithTextures(frames, timePerFrame: 0.1)
			let action = SKAction.repeatActionForever(animation)
			runAction(action)
		}
	}
	
	func setupPhysics() {
		physicsBody = SKPhysicsBody(rectangleOfSize: size)
		//physicsBody = SKPhysicsBody(texture: texture, size: size)
		physicsBody?.affectedByGravity = false
		physicsBody?.dynamic = true
		physicsBody?.linearDamping = 10.0
		physicsBody?.angularDamping = 20.0
		physicsBody?.categoryBitMask = PhysicsType.Player.rawValue
		physicsBody?.collisionBitMask = PhysicsType.Mirror.rawValue | PhysicsType.Player.rawValue | PhysicsType.Projectile.rawValue | PhysicsType.Obstacle.rawValue
		physicsBody?.contactTestBitMask = PhysicsType.Mirror.rawValue | PhysicsType.Player.rawValue | PhysicsType.Projectile.rawValue | PhysicsType.Obstacle.rawValue
	}
	
	func update(timePassed: CFTimeInterval) {
		var rotationsPerSecond = 0.3
		var pixelsPerSecond : CGFloat = 1000
		
		var rotation = (π * 2) * CGFloat(rotationsPerSecond) * CGFloat(timePassed)
		
		if !dead {
			moving = false
			
			if shouldTurnLeft {
				physicsBody?.applyAngularImpulse(rotation)
				moving = true
			} else if shouldTurnRight {
				physicsBody?.applyAngularImpulse(-rotation)
				moving = true
			}
			if shouldMoveFoward {
				let vector = CGVector(dx: sin(-zRotation), dy: cos(zRotation)) * pixelsPerSecond * CGFloat(timePassed)
				physicsBody?.applyImpulse(vector)
				moving = true
			}
			
			updateMoving()
		}
	}
	
	func updateMoving() {
		if state != .Shoot {
			if moving {
				let frames = ["\(playerColor)1", "\(playerColor)2"].map { SKTexture(imageNamed: $0)! }
				playAnimation(.Walk, frames: frames)
			} else {
				playAnimation(.Stand, frames: [SKTexture(imageNamed: "\(playerColor)1")!])
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
					if !dead {
						state = .Shoot
						let frames = [SKTexture(imageNamed: "\(playerColor)shoot")!]
						let animation = SKAction.animateWithTextures(frames, timePerFrame: 0.2)
						let end = SKAction.runBlock { self.state = .Stand; self.updateMoving() }
						let sequence = SKAction.sequence([animation, end])
						runAction(sequence)
						
						let bulletCount = Int((100.0 - CGFloat(health)) / 10.0) / 2
						for i in -bulletCount...bulletCount
						{
							let pSize = size
							// put it back inside the trigonometric calls to fan out bullets
							// + CGFloat(i) / 10.0
							//						let offset = CGPoint(x: pSize.width * sin(-(zRotation + CGFloat(i) / 10.0)), y: pSize.height * cos(zRotation + CGFloat(i) / 10.0))
							//						let projectile = Projectile(position: position + offset, angle: zRotation + (CGFloat(i) / 10))
							//						let remover = SKAction.sequence([SKAction.waitForDuration(1 + Double(random() as CGFloat)), SKAction.removeFromParent()])
							//						projectile.runAction(remover)
							
							let offset = CGPoint(x: pSize.width * sin(-zRotation) + CGFloat(i) / 3.0, y: pSize.height * cos(zRotation) + CGFloat(i) / 3.0)
							let projectile = Projectile(position: position + offset, angle: zRotation + (CGFloat(i) / 3), color: playerColor)
							
							let remover = SKAction.sequence([SKAction.waitForDuration(2), SKAction.removeFromParent()])
							let sound = SKAction.playSoundFileNamed(randomFireSound(), waitForCompletion: false)
							let grouped = SKAction.group([sound, remover])
							
							projectile.runAction(grouped)
							map?.addChild(projectile)
						}
					}
					if (false) {}
				case _: break
				}
			}
		}
	}
	
	var flash : SKSpriteNode?
	
	func startFlash() {
		if flash == nil {
			flash = SKSpriteNode(texture: SKTexture(imageNamed: "flash"))
			flash?.xScale = 2
			flash?.yScale = 2
			let rotate = SKAction.rotateByAngle(π * 2, duration: 1)
			let action = SKAction.repeatActionForever(rotate)
			flash?.runAction(action)
			addChild(flash!)
		}
	}
	
	func stopFlash() {
		flash?.removeFromParent()
		flash = nil
	}
	
	func randomFireSound() -> String {
		let rand = Int.random(Range(start: 1, end: 3))
		return "Laser\(rand).wav"
	}
}
