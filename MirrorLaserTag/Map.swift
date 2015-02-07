//
//  Map.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 06/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import SpriteKit

class Map: SKSpriteNode {
    var players: [Player] = []
	var level: Level!

	convenience init(players: [Player], level: Level, size: CGSize) {
		let texture: SKTexture! = nil
		
		self.init(texture: texture, color: NSColor.blueColor(), size: size)
		self.players = players
		self.level = level
		
		for x in 0...(Int(size.width) / 50) {
			for y in 0...(Int(size.height) / 50) {
				let tile = SKSpriteNode(texture: SKTexture(imageNamed: "tile"))
				tile.position = CGPoint(
					x: -size.width / 2 + 25 + CGFloat(x) * 50,
					y: -size.height / 2 + 25 + CGFloat(y) * 50)
				addChild(tile)
			}
		}
		
		setupLevel()
		setupPlayers()
	}
	
	override init(texture: SKTexture!, color: NSColor!, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func setupLevel() {
		for op in level.obstacles {
			let node = Obstacle(type: op.type)
//			let x = -(anchorPoint.x * size.width) + op.position.x
//			let y = -(anchorPoint.y * size.height) + op.position.y
			node.size = op.size
			node.position = op.position
			node.zRotation = op.angle
			node.zPosition = 2
			
			addChild(node)
		}
	}
	
	func setupPlayers() {
		for player in players {
			addChild(player)
		}
	}
}
