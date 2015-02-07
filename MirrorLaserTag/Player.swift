//
//  Player.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 06/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import SpriteKit

class Player : SKSpriteNode {
	var direction : CGFloat = 0 { didSet { updateDirection() } }
	var health : Int = 100
	
	override init() {
		let texture = SKTexture(imageNamed: "Spaceship")
		super.init(texture: texture, color: nil, size: CGSize(width: 96, height: 96))
		direction = 0
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updateDirection() {
		zRotation = direction
	}
}
