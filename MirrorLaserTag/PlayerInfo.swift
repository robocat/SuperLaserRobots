//
//  PlayerInfo.swift
//  MirrorLaserTag
//
//  Created by Ulrik Damm on 07/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerInfo : SKNode {
	let leftMode : Bool
	let playerColor: String
	
	init(leftMode : Bool, playerColor: String) {
		self.playerColor = playerColor
		self.leftMode = leftMode
		super.init()
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var image: SKSpriteNode!
	var healthBar = HealthBar()
	var killCount = SKLabelNode(text: "0")
	
	var size : CGSize = CGSize(width: 200, height: 70)
	
	var numberOfKills : Int = 0 { didSet { killCount.text = "\(numberOfKills)" } }
	
	func setup() {
		image = SKSpriteNode(imageNamed: "avatar_\(playerColor)")
		
		addChild(healthBar)
		addChild(image)
		addChild(killCount)
		
		killCount.fontName = "Pixeleris"
		killCount.fontColor = .whiteColor()
		killCount.fontSize = 32
		
		if leftMode {
			healthBar.position = CGPoint(x: -55, y: 0)
			image.position = CGPoint(x: 60, y: 0)
			image.size = CGSize(width: 48, height: 50)
			killCount.position = CGPoint(x: -82, y: -20)
			killCount.horizontalAlignmentMode = .Left
		} else {
			healthBar.position = CGPoint(x: -25, y: 0)
			image.position = CGPoint(x: -60, y: 0)
			image.size = CGSize(width: 48, height: 50)
			killCount.position = CGPoint(x: 82, y: -20)
			killCount.horizontalAlignmentMode = .Right
		}
	}
}

class HealthBar : SKNode {
	override init() {
		super.init()
		setup()
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var health : Int = 100 { didSet { updateHealth() } }
	var size : CGSize = CGSize(width: 84, height: 22) { didSet { updateHealth() } }
	
	var filledBar = SKSpriteNode(texture: SKTexture(imageNamed: "healthgreen"))
	var emptyBar = SKSpriteNode(texture: SKTexture(imageNamed: "healthempty"))
//	var divider = SKSpriteNode(texture: SKTexture(imageNamed: "health bar divider"))
	
	func setup() {
		addChild(emptyBar)
		addChild(filledBar)
//		addChild(divider)
		
		filledBar.anchorPoint = CGPoint(x: 0, y: 0.5)
		emptyBar.anchorPoint = CGPoint(x: 0, y: 0.5)
//		divider.anchorPoint = CGPoint(x: 0, y: 0.5)
		
		filledBar.position = CGPoint(x: 0, y: 0)
		
		updateHealth()
	}
	
	func updateHealth() {
		emptyBar.size = size
		filledBar.size = size
		
		let x = positionForHealth(min(max(health, 0), 100))
		filledBar.size = CGSize(width: x, height: size.height)
//		divider.position = CGPoint(x: x - 5, y: 0)
	}
	
	func positionForHealth(health : Int) -> CGFloat {
		let padding : CGFloat = 0
		let x = ((size.width - padding * 2) / 100) * CGFloat(health)
		return x + padding
	}
}
