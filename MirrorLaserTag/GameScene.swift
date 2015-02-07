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
	
	var players: [Player] = []
	var map: Map!
	
	// MARK: Set Up
	
    override func didMoveToView(view: SKView) {
		setupPlayers()
		setupMap()
		
        physicsWorld.contactDelegate = self
    }
	
	func setupPlayers() {
		let player1 = Player()
		player1.controls = Controls(player: player1, mappings: Controls.mappings[0])
		player1.position = CGPoint(x: 100, y: 100)
		players.append(player1)
		
		let player2 = Player()
		player2.controls = Controls(player: player2, mappings: Controls.mappings[1])
		player2.position = CGPoint(x: 300, y: 300)
		players.append(player2)
	}
	
	func setupMap() {
		let levels = Level.all
		map = Map(players: players, level: levels[0], size: size)
		map.position = CGPoint(x: size.width / 2, y: size.height / 2)
		
		addChild(map)
	}
	
	// MARK: Update Loop
    
    override func keyDown(theEvent: NSEvent) {
		for player in players {
			player.handleKeyDown(theEvent.keyCode)
		}
    }
	
	override func keyUp(theEvent: NSEvent) {
		for player in players {
			player.handleKeyUp(theEvent.keyCode)
		}
	}
    
    override func update(currentTime: CFTimeInterval) {
		var elapsedTime = currentTime - time
		time = currentTime
		
		for player in players {
			player.update(elapsedTime)
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
