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
	
	var musicPlayer : MusicPlayer?
	
	// MARK: Set Up
	
    override func didMoveToView(view: SKView) {
		setupPlayers()
		setupMap()
		setupUI()
		setupMusic()
		
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
	
	func setupMusic() {
		let path = NSBundle.mainBundle().URLForResource("LaserMusic", withExtension: "mp3")!
		musicPlayer = MusicPlayer(fileURL: path)
		musicPlayer?.play()
	}
	
	func setupUI() {
		let health1 = PlayerInfo(leftMode: true)
		addChild(health1)
		health1.position = CGPoint(x: 0, y: 50)
		infoViews[players[0]] = health1
		
		let health2 = PlayerInfo(leftMode: false)
		addChild(health2)
		health2.position = CGPoint(x: size.width - health2.size.width, y: 50)
		infoViews[players[1]] = health2
		
		let health3 = PlayerInfo(leftMode: true)
		addChild(health3)
		health3.position = CGPoint(x: 0, y: size.height - health3.size.height)
		infoViews[players[2]] = health3
		
		let health4 = PlayerInfo(leftMode: false)
		addChild(health4)
		health4.position = CGPoint(x: size.width - health4.size.width, y: size.height - health4.size.height)
		infoViews[players[3]] = health4
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
		if (contact.bodyB.categoryBitMask == PhysicsType.Projectile.rawValue && contact.bodyA.categoryBitMask != PhysicsType.Player.rawValue) {
			if let node = contact.bodyB.node {
				//node.zRotation -= π/4
				
				node.removeFromParent()
			}
		}
		switch collision {
		case PhysicsType.Projectile.rawValue | PhysicsType.Mirror.rawValue:
			// Change the trajectory and/or velocity of the projectile
			if let node = contact.bodyB.node {
			}
			return
		case PhysicsType.Projectile.rawValue | PhysicsType.Obstacle.rawValue:
			if let node = contact.bodyB.node {
				//node.removeFromParent()
				//let newLaser = Projectile(position: convertPoint(node.position, fromNode: map), angle: node.zRotation + π)
				//map.addChild(newLaser)
				//node.removeFromParent()
			}
			return
		case PhysicsType.Projectile.rawValue | PhysicsType.Player.rawValue:
			if let node = contact.bodyB.node {
				if contact.bodyB.categoryBitMask == PhysicsType.Projectile.rawValue {
					map.removeChildrenInArray([node])
				}
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
			player.hidden = true
			let physics = player.physicsBody
			player.physicsBody = nil
			player.runAction(SKAction.sequence([SKAction.waitForDuration(3), SKAction.runBlock({
				if player.health > 0 { return }
				//player.physicsBody = physics
				player.setupPhysics()
				player.hidden = false
				player.health = 100
				player.dead = false
			})]))
		}
	}
}
