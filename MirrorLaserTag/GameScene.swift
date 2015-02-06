//
//  GameScene.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 06/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
    }
    
    override func mouseDown(theEvent: NSEvent) {
    
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
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
