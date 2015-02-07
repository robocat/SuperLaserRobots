//
//  GameScene.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 06/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	var time : CFTimeInterval = 0
    let player = Player()
	var map: Map!
	
	// MARK: Set Up
	
    override func didMoveToView(view: SKView) {
		setupPlayers()
		setupMap()
		setupUI()
		
        physicsWorld.contactDelegate = self
		physicsBody = SKPhysicsBody(edgeLoopFromRect: map.frame)
    }
	
	func setupPlayers() {
//		player.position = CGPoint(x: 100, y: 100)
//		addChild(player)
	}
	
	func setupUI() {
		let health1 = PlayerInfo(leftMode: true)
		addChild(health1)
		health1.position = CGPoint(x: 0, y: 100)
		
		let health2 = PlayerInfo(leftMode: false)
		addChild(health2)
		health2.position = CGPoint(x: size.width - health2.size.width, y: 100)
		
		let health3 = PlayerInfo(leftMode: true)
		addChild(health3)
		health3.position = CGPoint(x: 0, y: size.height - health3.size.height)
		
		let health4 = PlayerInfo(leftMode: false)
		addChild(health4)
		health4.position = CGPoint(x: size.width - health4.size.width, y: size.height - health4.size.height)
	}
	
	func setupMap() {
		let levels = Level.all
		map = Map(players: [player], level: levels[0], size: CGSize(width: 600, height: 400))
		map.position = CGPoint(x: size.width / 2, y: size.height / 2)
		
		addChild(map)
	}
	
	// MARK: Update Loop
	
	var leftPressed : Bool = false
	var rightPressed : Bool = false
	var upPressed : Bool = false
    
    override func keyDown(theEvent: NSEvent) {
		switch theEvent.key {
		case .Some(.Left): leftPressed = true
		case .Some(.Right): rightPressed = true
		case .Some(.Up): upPressed = true
		//case .Some(.Up):
		//	removeChildrenInArray(self.children.filter({$0 is Projectile}))
        case .Some(.Space):
            if (time - player.lastShot > 0.2) {
                player.lastShot = time
				let pSize = player.size
				let offset = CGPoint(x: pSize.width * -sin(player.zRotation), y: pSize.height * cos(player.zRotation))
				let projectile = Projectile(position: player.position + offset, angle: player.zRotation)
                map.addChild(projectile)
            }
		case _: break
		}
    }
	
	override func mouseDown(theEvent: NSEvent) {
		let location = theEvent.locationInNode(self)
		// addChild(Mirror(position: location, angle: 0))
	}
	
	override func mouseDragged(theEvent: NSEvent) {
		
	}
	
	override func keyUp(theEvent: NSEvent) {
		switch theEvent.key {
		case .Some(.Left): leftPressed = false
		case .Some(.Right): rightPressed = false
		case .Some(.Up): upPressed = false
		case _: break
		}
	}
    
    override func update(currentTime: CFTimeInterval) {
		var elapsedTime = currentTime - time
		time = currentTime
		
		var rotationsPerSecond = 0.2
		var pixelsPerSecond : CGFloat = 5000
		
		var rotation = (π * 2) * CGFloat(rotationsPerSecond) * CGFloat(elapsedTime)
		
		if leftPressed {
			//player.direction += rotation
			player.physicsBody?.applyAngularImpulse(rotation)
		} else if rightPressed {
			//player.direction -= rotation
			player.physicsBody?.applyAngularImpulse(-rotation)
		}
		
		if upPressed {
			let vector = CGVector(dx: sin(-player.zRotation), dy: cos(player.zRotation)) * pixelsPerSecond * CGFloat(elapsedTime)
			//player.runAction(SKAction.moveBy(vector, duration: 0))
			player.physicsBody?.applyForce(vector)
		}
    }
	
	// MARK: SKPhysicsContactDelegate
	
	func didBeginContact(contact: SKPhysicsContact) {
		let normal = contact.contactNormal
		let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		switch collision {
		case PhysicsType.Projectile.rawValue | PhysicsType.Mirror.rawValue:
			// Change the trajectory and/or velocity of the projectile
			let angle = asin(min(normal.dx, normal.dy)/max(normal.dx, normal.dy))
			if let projectile = contact.bodyA.node as? Projectile {
				projectile.zRotation += 0.3
			} else {
				//let projectile = contact.bodyB.node as Projectile
				//let v = contact.bodyB.velocity
				//let newV = CGVector(dx: v.dx * cos(angle), dy: v.dy * sin(angle))
				//contact.bodyB.velocity = newV
				
				//projectile.zRotation += 0.3
			}
			return
		case PhysicsType.Projectile.rawValue | PhysicsType.Player.rawValue:
			if let node = contact.bodyB.node {
				map.removeChildrenInArray([node])
			}
		default:
			return
		}
	}
}
