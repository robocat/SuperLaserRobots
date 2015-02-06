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
		player.position = CGPoint(x: 100, y: 100)
		addChild(player)
		
        physicsWorld.contactDelegate = self
    }
	
	var leftPressed : Bool = false
	var rightPressed : Bool = false
    
    override func keyDown(theEvent: NSEvent) {
		switch theEvent.key {
		case .Some(.Left): leftPressed = true
		case .Some(.Right): rightPressed = true
		case _: break
		}
    }
	
	override func keyUp(theEvent: NSEvent) {
		switch theEvent.key {
		case .Some(.Left): leftPressed = false
		case .Some(.Right): rightPressed = false
		case _: break
		}
	}
    
    override func update(currentTime: CFTimeInterval) {
		var elapsedTime = currentTime - time
		time = currentTime
		
		var rotationsPerSecond = 0.5
		var rotation = (π * 2) * CGFloat(rotationsPerSecond) * CGFloat(elapsedTime)
		
		if leftPressed {
			player.direction += rotation
		} else if rightPressed {
			player.direction -= rotation
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
