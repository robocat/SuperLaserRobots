//
//  GameOverScreen.swift
//  MirrorLaserTag
//
//  Created by Robo Cat on 07/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import SpriteKit

class GameOverScene : SKScene {
	
	var players: [Player]?
	
	convenience init (players: [Player]) {
		self.init(size: CGSize(width: 1024, height: 768))
		self.players = players
	}
	
	override func didMoveToView(view: SKView) {
		backgroundColor = NSColor.blackColor()
		anchorPoint = CGPoint(x: 0.5, y: 0.5)
		
		let title = SKLabelNode(text: "gg wp")
		title.fontColor = NSColor.whiteColor()
		title.fontSize = 52
		title.fontName = "Helvetica"
		title.position = CGPoint(x: 0, y: 100)
		
		
		
		for i in 0..<players!.count
		{
			let player = players![i]
			let score = SKLabelNode(fontNamed: "Helvetica")
			score.fontSize = 40
			switch player.playerColor {
				case "red":
				score.fontColor = .redColor()
				case "green":
				score.fontColor = .greenColor()
				case "blue":
				score.fontColor = .blueColor()
				case "purple":
				score.fontColor = .purpleColor()
				default:
				score.fontColor = .whiteColor()
			}
			
			score.position = CGPoint(x: 0, y: -50 * (i+1))
			score.text += "\(player.playerName)\t\t\(player.score)"
			addChild(score)
		}
		
		addChild(title)
	}
	
	override func keyDown(theEvent: NSEvent) {
		let key = Controls.Key(rawValue: Int(theEvent.keyCode))
		switch key {
		case .Some(.Enter): return
		case _: break
		}
	}

}