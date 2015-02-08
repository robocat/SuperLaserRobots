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
		title.fontName = "Pixeleris"
		title.position = CGPoint(x: 0, y: 100)
		
		
		
		for i in 0..<players!.count
		{
			let player = players![i]
			if !player.inGame {
				continue
			}
			let scoreName = SKLabelNode(fontNamed: "Pixeleris")
			scoreName.fontSize = 40
			scoreName.horizontalAlignmentMode = .Left
			switch player.playerColor {
				case "red":
				scoreName.fontColor = .redColor()
				case "green":
				scoreName.fontColor = .greenColor()
				case "blue":
				scoreName.fontColor = .blueColor()
				case "purple":
				scoreName.fontColor = .purpleColor()
				default:
				scoreName.fontColor = .whiteColor()
			}
			scoreName.position = CGPoint(x: -160, y: -50 * (i+1))
			scoreName.text = "\(player.playerName)"
			addChild(scoreName)
			
			let scorePoint = SKLabelNode(fontNamed: "Pixeleris")
			scorePoint.fontSize = 40
			scorePoint.horizontalAlignmentMode = .Left
			switch player.playerColor {
			case "red":
				scorePoint.fontColor = .redColor()
			case "green":
				scorePoint.fontColor = .greenColor()
			case "blue":
				scorePoint.fontColor = .blueColor()
			case "purple":
				scorePoint.fontColor = .purpleColor()
			default:
				scorePoint.fontColor = .whiteColor()
			}
			scorePoint.position = CGPoint(x: 140, y: -50 * (i+1))
			scorePoint.text = "\(player.score)"
			addChild(scorePoint)
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