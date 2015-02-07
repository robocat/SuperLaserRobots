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
	
	init(leftMode : Bool) {
		self.leftMode = leftMode
		super.init()
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var image = SKSpriteNode(imageNamed: "avatar1")
	var nameLabel = SKLabelNode(text: "Robot name")
	var healthBar = HealthBar()
	
	var size : CGSize = CGSize(width: 425, height: 100)
	
	func setup() {
		addChild(healthBar)
		addChild(image)
		addChild(nameLabel)
		
		if leftMode {
			nameLabel.position = CGPoint(x: 160, y: 30)
			healthBar.position = CGPoint(x: 150, y: -30)
			image.position = CGPoint(x: 70, y: 0)
			image.size = CGSize(width: 130, height: 130)
			nameLabel.horizontalAlignmentMode = .Left
		} else {
			nameLabel.position = CGPoint(x: 260, y: 30)
			healthBar.position = CGPoint(x: 0, y: -30)
			image.position = CGPoint(x: 350, y: 0)
			image.size = CGSize(width: 130, height: 130)
			nameLabel.horizontalAlignmentMode = .Right
		}
		
		nameLabel.fontName = "Helvetica"
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
	var size : CGSize = CGSize(width: 272, height: 62) { didSet { updateHealth() } }
	
	var filledBar = SKSpriteNode(texture: SKTexture(imageNamed: "health bar filled"))
	var emptyBar = SKSpriteNode(texture: SKTexture(imageNamed: "health bar empty"))
	var divider = SKSpriteNode(texture: SKTexture(imageNamed: "health bar divider"))
	
	func setup() {
		addChild(emptyBar)
		addChild(filledBar)
		addChild(divider)
		
		filledBar.anchorPoint = CGPoint(x: 0, y: 0.5)
		emptyBar.anchorPoint = CGPoint(x: 0, y: 0.5)
		divider.anchorPoint = CGPoint(x: 0, y: 0.5)
		
		filledBar.position = CGPoint(x: 10, y: 0)
		
		updateHealth()
	}
	
	func updateHealth() {
		emptyBar.size = size
		filledBar.size = size
		
		let x = positionForHealth(min(max(health, 0), 100))
		filledBar.size = CGSize(width: x - 10, height: size.height - 12)
		divider.position = CGPoint(x: x - 5, y: 0)
	}
	
	func positionForHealth(health : Int) -> CGFloat {
		let padding : CGFloat = 10
		let x = ((size.width - padding * 2) / 100) * CGFloat(health)
		return x + padding
	}
}
