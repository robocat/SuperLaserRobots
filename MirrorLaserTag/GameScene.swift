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
	var countdown = SKLabelNode(fontNamed: "Pixeleris")
	var firstTime : CFTimeInterval?
	
	var waiting1 : SKSpriteNode!
	var waiting2 : SKSpriteNode!
	var waiting3 : SKSpriteNode!
	var waiting4 : SKSpriteNode!
	var overlay : SKSpriteNode!
	var waitings : [String: SKSpriteNode] = [:]
	var waiting = true
	var numberOfPlayers = 0
	
	var musicPlayer : MusicPlayer?
	var lobbyPlayer : MusicPlayer?
	
	// MARK: Set Up
	
    override func didMoveToView(view: SKView) {
		setupPlayers()
		setupMap()
		setupBorders()
		setupUI()
		setupPressFireToJoin()
		
		anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.contactDelegate = self
		physicsBody = SKPhysicsBody(edgeLoopFromRect: map.frame)
		
		backgroundColor = NSColor(calibratedRed: 0.29, green: 0.29, blue: 0.29, alpha: 1)
		
		countdown.fontSize = 54
		countdown.position = CGPoint(x: 0, y: size.height / 2 - 60)
		countdown.verticalAlignmentMode = .Center
		countdown.horizontalAlignmentMode = .Center
		countdown.fontColor = .blackColor()
		countdown.text = "00:00"
		countdown.zPosition = 10000
		addChild(countdown)
		

		let wait = SKAction.waitForDuration(20, withRange: 5)
		let runBlock = SKAction.runBlock {
			if self.waiting {
				return
			}
			self.dropRandomPowerUp()
		}
		let seq = SKAction.sequence([wait, runBlock])
		let repeat = SKAction.repeatActionForever(seq)
		
		runAction(repeat)

		startLobbyMusic()
    }
	
	func dropRandomPowerUp() {
		let randomPoints:[CGPoint] = [
			CGPoint(x: 0, y: 0),
			CGPoint(x: -100, y: -200),
			CGPoint(x: 300, y: -300),
			CGPoint(x: 200, y:  40)
		]
		
		let powerUp = PowerUp(type: .Health)
		let range = Range(start: UInt32(0), end: UInt32(randomPoints.count - 1))
		let index = Int.random(range)
		powerUp.position = randomPoints[Int(index)]
		
		map.addChild(powerUp)
    }
	
	func startLobbyMusic() {
		musicPlayer?.pause()
		let path = NSBundle.mainBundle().URLForResource("LaserDisco", withExtension: "wav")!
		lobbyPlayer = MusicPlayer(fileURL: path)
		lobbyPlayer?.play()
	}
	
	func startGameMusic() {
		lobbyPlayer?.pause()
		let path = NSBundle.mainBundle().URLForResource("LaserMusic", withExtension: "mp3")!
		musicPlayer = MusicPlayer(fileURL: path)
		musicPlayer?.play()
	}
	
	func setupBorders() {
		let top = SKSpriteNode(imageNamed: "topwall")
		top.position = CGPoint(x: 0, y: size.height / 2 - top.size.height / 2)
		top.zPosition = 5
		
		addChild(top)

		let bottom = SKSpriteNode(imageNamed: "bottomwall")
		bottom.zPosition = 5
		bottom.position = CGPoint(x: 0, y: -size.height / 2 + bottom.size.height / 2 )
		
		addChild(bottom)

		let left = SKSpriteNode(imageNamed: "leftwall")
		left.position = CGPoint(x: top.size.width / 2 - left.size.width / 2, y: 0)
		left.zPosition = 4

		addChild(left)

		let right = SKSpriteNode(imageNamed: "rightwall")
		right.position = CGPoint(x: -top.size.width / 2 + right.size.width / 2, y: 0)
		right.zPosition = 4
		
		addChild(right)
	}
	
	func setupPlayers() {
		let player1 = Player()
		player1.controls = Controls(player: player1, mappings: Controls.mappings[0])
		player1.position = CGPoint(x: -370, y: -320)
		player1.zRotation = -π / 4
		player1.playerColor = "green"
		player1.playerName = "Green robot"
		players.append(player1)
		
		let player2 = Player()
		player2.controls = Controls(player: player2, mappings: Controls.mappings[1])
		player2.position = CGPoint(x: 370, y: 320)
		player2.zRotation = π * 0.75
		player2.playerColor = "blue"
		player2.playerName = "Blue robot"
		players.append(player2)
		
		let player3 = Player()
		player3.controls = Controls(player: player3, mappings: Controls.mappings[2])
		player3.position = CGPoint(x: 370, y: -320)
		player3.zRotation = π / 4
		player3.playerColor = "purple"
		player3.playerName = "Purple robot"
		players.append(player3)
		
		let player4 = Player()
		player4.controls = Controls(player: player4, mappings: Controls.mappings[3])
		player4.position = CGPoint(x: -370, y: 320)
		player4.zRotation = -π * 0.75
		player4.playerColor = "red"
		player4.playerName = "Red robot"
		players.append(player4)

		for player in players {
			player.delegate = self
		}
	}
	
	func setupPressFireToJoin() {
		waiting1 = SKSpriteNode(texture: SKTexture(imageNamed: "\(players[0].playerColor) waiting"))
		waiting1.size = CGSize(width: 192, height: 288)
		waiting1.position = CGPoint(x: -600, y: -220)
		addChild(waiting1)
		
		waiting2 = SKSpriteNode(texture: SKTexture(imageNamed: "\(players[1].playerColor) waiting"))
		waiting2.size = CGSize(width: 192, height: 288)
		waiting2.position = CGPoint(x: 600, y: 220)
		addChild(waiting2)
		
		waiting3 = SKSpriteNode(texture: SKTexture(imageNamed: "\(players[2].playerColor) waiting"))
		waiting3.size = CGSize(width: 192, height: 288)
		waiting3.position = CGPoint(x: 600, y: -220)
		addChild(waiting3)
		
		waiting4 = SKSpriteNode(texture: SKTexture(imageNamed: "\(players[3].playerColor) waiting"))
		waiting4.size = CGSize(width: 192, height: 288)
		waiting4.position = CGPoint(x: -600, y: 220)
		addChild(waiting4)
		
		waitings[players[0].playerColor] = waiting1
		waitings[players[1].playerColor] = waiting2
		waitings[players[2].playerColor] = waiting3
		waitings[players[3].playerColor] = waiting4
		
		overlay = SKSpriteNode(texture: SKTexture(imageNamed: "pressstart"))
		addChild(overlay)
		overlay.zPosition = 10000
	}
	
	func setupUI() {
		let health1 = PlayerInfo(leftMode: true, playerColor: players[0].playerColor)
		addChild(health1)
		health1.position = CGPoint(x: -600 , y: -410)
		
		infoViews[players[0]] = health1
		players[0].playerInfo = health1

		let health2 = PlayerInfo(leftMode: false, playerColor: players[1
			].playerColor)
		addChild(health2)
		health2.position = CGPoint(x: 600, y: 410)
		infoViews[players[1]] = health2
		players[1].playerInfo = health2

		let health3 = PlayerInfo(leftMode: true, playerColor: players[2].playerColor)
		addChild(health3)
		health3.position = CGPoint(x: 600, y: -410)
		infoViews[players[2]] = health3
		players[2].playerInfo = health3

		let health4 = PlayerInfo(leftMode: false, playerColor: players[3].playerColor)
		addChild(health4)
		health4.position = CGPoint(x: -600, y: 410)
		infoViews[players[3]] = health4
		players[3].playerInfo = health4
	}
	
	func setupMap() {
		let levels = Level.all
		let mapHeight = size.height - 100
		map = Map(players: players, level: levels[0], size: CGSize(width: mapHeight + 100, height: mapHeight))
		map.position = CGPointZero
		map.zPosition = 3
//		map.position = CGPoint(x: size.width / 2, y: size.height / 2)
		
		addChild(map)
		
		for player in players {
			player.map = map
		}
	}
	
	// MARK: Update Loop

    override func keyDown(theEvent: NSEvent) {
//		if let key = Controls.Key(rawValue: Int(theEvent.keyCode)) {
//			switch key {
//			case .Escape: self.view?.presentScene(StartScene(size: size))
//			case _: break
//			}
//		}
		
		if waiting {
			for player in players {
				if let key = Controls.Key(rawValue: Int(theEvent.keyCode)) {
					if let command = player.controls.mappings[key] {
						if command == .Fire {
							let waitingNode = waitings[player.playerColor]!
							waitingNode.texture = SKTexture(imageNamed: "\(player.playerColor)")
							player.hidden = false
							player.dead = false
							player.inGame = true
							player.setupPhysics()
							numberOfPlayers++
						}
					}
				}
			}
			
			let key = Controls.Key(rawValue: Int(theEvent.keyCode))
			switch key {
			case .Some(.Enter):
				if numberOfPlayers >= 2 {
					waiting = false
					overlay.removeFromParent()
					waiting1.removeFromParent()
					waiting2.removeFromParent()
					waiting3.removeFromParent()
					waiting4.removeFromParent()
					startGameMusic()
					
					for (player, infoView) in infoViews {
						if !player.inGame {
							infoView.removeFromParent()
						}
					}
				}
			case _: break
			}
		} else {
			for player in players {
				player.handleKeyDown(theEvent.keyCode)
			}
		}
	}
	
	override func mouseDown(theEvent: NSEvent) {
		let location = theEvent.locationInNode(self)
		// addChild(Mirror(position: location, angle: 0))
	}
	
	override func mouseDragged(theEvent: NSEvent) {
		
	}
	
	override func keyUp(theEvent: NSEvent) {
		if waiting {
			
		} else {
			for player in players {
				player.handleKeyUp(theEvent.keyCode)
			}
		}
	}
    
	override func update(currentTime: CFTimeInterval) {
		var elapsedTime = currentTime - time
		time = currentTime
		
		if firstTime == nil && !waiting {
			firstTime = currentTime
		}
		if firstTime != nil && !waiting {
			let gameLength = 3
			
			let minutes = Int(currentTime - firstTime!) / 60
			let seconds = (Int(currentTime - firstTime!) % 60)
			let milliseconds = 100 - Int(((currentTime - firstTime!) - Double(seconds)) * 100)
			let formatted = NSString(format: "%02d:%02d",gameLength-1 - minutes, 60 - seconds)
			countdown.text = formatted
			
			if minutes >= gameLength {
				moveToGameOversScene()
			}
		}

		for player in players {
			player.update(elapsedTime)
		}
    }
	
	func moveToGameOversScene() {
		players.sort({$0.score < $1.score})
		
		//let scoreboard = players.map { player in [player.name: player.score] }
		
		let scene = GameOverScene(players: players)
		/* Set the scale mode to scale to fit the window */
		scene.scaleMode = .AspectFit
			
		let transition = SKTransition.crossFadeWithDuration(0.3)
		self.view?.presentScene(scene)
		
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
		case PhysicsType.PowerUp.rawValue | PhysicsType.Player.rawValue:
			if let player = contact.bodyA.node as? Player {
				player.health = min(player.health + 30, 100)

				contact.bodyB.node?.removeFromParent()
			}
			return
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
				if contact.bodyA.categoryBitMask == PhysicsType.Projectile.rawValue {
					if let node = contact.bodyA.node {
						map.removeChildrenInArray([node])
					}
				}
				if let player = contact.bodyA.node as? Player {
					//player.lastReceivedDamageFrom = node.firedBy
					player.health -= 2
					
					let fire = SKSpriteNode(texture: SKTexture(imageNamed: "fire"))
					
					// This is fucked now
					//fire.position = convertPoint(contact.contactPoint, toNode: map)
					
					let offset = CGPoint(x: size.width / 2, y: size.height / 2)
					fire.position = contact.contactPoint - offset
					//fire.zPosition = 100
					map.addChild(fire)
					
					let scale = SKAction.scaleBy(3, duration: 0.2)
					let fade = SKAction.fadeOutWithDuration(0.2)
					let sound = SKAction.playSoundFileNamed("Hit.wav", waitForCompletion: false)
					let group = SKAction.group([scale, fade, sound])
					let remove = SKAction.runBlock { fire.removeFromParent() }
					let action = SKAction.sequence([group, remove])
					fire.runAction(action)
				}
				if let player = contact.bodyB.node as? Player {
					//player.lastReceivedDamageFrom = node.firedBy
					player.health -= 1
					
					let fire = SKSpriteNode(texture: SKTexture(imageNamed: "fire"))
					
					// This is fucked now
					//fire.position = convertPoint(contact.contactPoint, toNode: map)
					
					let offset = CGPoint(x: size.width / 2, y: size.height / 2)
					fire.position = contact.contactPoint - offset
					//fire.zPosition = 100
					map.addChild(fire)
					
					let scale = SKAction.scaleBy(3, duration: 0.2)
					let fade = SKAction.fadeOutWithDuration(0.2)
					let sound = SKAction.playSoundFileNamed("Hit.wav", waitForCompletion: false)
					let group = SKAction.group([scale, fade, sound])
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
//			player
			player.score += 1
			player.dead = true
			player.hidden = true
			player.physicsBody = nil
			let sound = SKAction.playSoundFileNamed("Dead.wav", waitForCompletion: false)
			player.runAction(SKAction.sequence([sound, SKAction.waitForDuration(3), SKAction.runBlock({ [weak self] in
				if player.health > 0 { return }
				player.setupPhysics()
				player.hidden = false
				player.health = 100
				player.dead = false
				let sound = SKAction.playSoundFileNamed("Respawn.wav", waitForCompletion: false)
				self?.runAction(sound)
			})]))
		}
	}
}
