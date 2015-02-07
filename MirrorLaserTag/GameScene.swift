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
	
    override func didMoveToView(view: SKView) {
//		backgroundColor = .blackColor()
		player.position = CGPoint(x: 100, y: 100)
		addChild(player)
		
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
		
        physicsWorld.contactDelegate = self
    }
	
	var leftPressed : Bool = false
	var rightPressed : Bool = false
	var upPressed : Bool = false
    
    override func keyDown(theEvent: NSEvent) {
		switch theEvent.key {
		case .Some(.Left): leftPressed = true
		case .Some(.Right): rightPressed = true
		case .Some(.Up): upPressed = true
		case _: break
		}
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
		
		var rotationsPerSecond = 0.5
		var pixelsPerSecond : CGFloat = 500
		
		var rotation = (π * 2) * CGFloat(rotationsPerSecond) * CGFloat(elapsedTime)
		
		if leftPressed {
			player.direction += rotation
		} else if rightPressed {
			player.direction -= rotation
		}
		
		if upPressed {
			let vector = CGVector(dx: sin(-player.direction), dy: cos(player.direction)) * pixelsPerSecond * CGFloat(elapsedTime)
			player.runAction(SKAction.moveBy(vector, duration: 0))
		}
    }
	
	// MARK: SKPhysicsContactDelegate
	
	func didBeginContact(contact: SKPhysicsContact) {
		let collision = contact.bodyA.collisionBitMask | contact.bodyB.collisionBitMask
		switch collision {
		case PhysicsType.Projectile.rawValue | PhysicsType.Mirror.rawValue:
			// Change the trajectory and/or velocity of the projectile
			return
		default:
			return
		}
	}
}
