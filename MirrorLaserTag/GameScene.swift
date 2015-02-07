//
//  GameScene.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 06/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, PlayerDelegate {
	var time : CFTimeInterval = 0
	var players: [Player] = []
	var map: Map!
	var infoViews : [Player: PlayerInfo] = [:]
	
	// MARK: Set Up
	
    override func didMoveToView(view: SKView) {
		setupPlayers()
		setupMap()
		setupUI()
		
        physicsWorld.contactDelegate = self
		physicsBody = SKPhysicsBody(edgeLoopFromRect: map.frame)
    }
	
	func setupPlayers() {
		let player1 = Player()
		player1.controls = Controls(player: player1, mappings: Controls.mappings[0])
		player1.position = CGPoint(x: -500, y: -200)
		player1.zRotation = -π / 4
		players.append(player1)
		
		let player2 = Player()
		player2.controls = Controls(player: player2, mappings: Controls.mappings[1])
		player2.position = CGPoint(x: -500, y: 200)
		player2.zRotation = -π * 0.75
		players.append(player2)
		
		let player3 = Player()
		player3.controls = Controls(player: player3, mappings: Controls.mappings[2])
		player3.position = CGPoint(x: 500, y: -200)
		player3.zRotation = π / 4
		players.append(player3)
		
		let player4 = Player()
		player4.controls = Controls(player: player4, mappings: Controls.mappings[3])
		player4.position = CGPoint(x: 500, y: 200)
		player4.zRotation = π * 0.75
		players.append(player4)

		for player in players {
			player.delegate = self
		}
	}
	
	func setupUI() {
		let health1 = PlayerInfo(leftMode: true)
		addChild(health1)
		health1.position = CGPoint(x: 0, y: 100)
		infoViews[players[0]] = health1
		
		let health2 = PlayerInfo(leftMode: false)
		addChild(health2)
		health2.position = CGPoint(x: size.width - health2.size.width, y: 100)
		infoViews[players[1]] = health2
		
		let health3 = PlayerInfo(leftMode: true)
		addChild(health3)
		health3.position = CGPoint(x: 0, y: size.height - health3.size.height)
		
		let health4 = PlayerInfo(leftMode: false)
		addChild(health4)
		health4.position = CGPoint(x: size.width - health4.size.width, y: size.height - health4.size.height)
	}
	
	func setupMap() {
		let levels = Level.all
		map = Map(players: players, level: levels[0], size: CGSize(width: 1024, height: 500))
		map.position = CGPoint(x: size.width / 2, y: size.height / 2)
		
		addChild(map)
		
		for player in players {
			player.map = map
		}
	}
	
	// MARK: Update Loop

    override func keyDown(theEvent: NSEvent) {
		println(theEvent.keyCode)
		for player in players {
			player.handleKeyDown(theEvent.keyCode)
		}
	}
	
	override func mouseDown(theEvent: NSEvent) {
		let location = theEvent.locationInNode(self)
		// addChild(Mirror(position: location, angle: 0))
	}
	
	override func mouseDragged(theEvent: NSEvent) {
		
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
				if let player = contact.bodyA.node as? Player {
					player.health -= 1
					
					let fire = SKSpriteNode(texture: SKTexture(imageNamed: "fire"))
					fire.position = convertPoint(contact.contactPoint, toNode: map)
					map.addChild(fire)
					
					let scale = SKAction.scaleBy(3, duration: 0.2)
					let fade = SKAction.fadeOutWithDuration(0.2)
					let group = SKAction.group([scale, fade])
					let remove = SKAction.runBlock { fire.removeFromParent() }
					let action = SKAction.sequence([group, remove])
					fire.runAction(action)
				}
			}
		default:
			return
		}
	}
	
	func playerDidChangeHealth(player: Player) {
		if let infoView = infoViews[player] {
			infoView.healthBar.health = player.health
		}
		
		if player.health <= 0 {
			player.dead = true
		}
	}
}
