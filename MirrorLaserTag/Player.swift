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
	var controls: Controls!

	var shouldTurnLeft: Bool = false
	var shouldTurnRight: Bool = false
	
	
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
	
	func update(timePassed: CFTimeInterval) {
		var rotationsPerSecond: CGFloat = 1.2
		var rotation = (π * 2) * rotationsPerSecond * CGFloat(timePassed)

		if shouldTurnLeft {
			direction += rotation
		} else if shouldTurnRight {
			direction -= rotation
		}
	}
	
	func performCommand(command: Command) {
		switch command {
		case .TurnLeft: shouldTurnLeft = true
		case .TurnRight: shouldTurnRight = true
		case _: break
		}
	}
	
	func handleKeyDown(keyCode: UInt16) {
		if let key = Controls.Key(rawValue: Int(keyCode)) {
			if let command = controls.mappings[key] {
				performCommand(command)
			}
		}
	}
	
	func handleKeyUp(keyCode: UInt16) {
		if let key = Controls.Key(rawValue: Int(keyCode)) {
			if let command = controls.mappings[key] {
				switch command {
				case .TurnLeft: shouldTurnLeft = false
				case .TurnRight: shouldTurnRight = false
				case _: break
				}
			}
		}
	}
}
