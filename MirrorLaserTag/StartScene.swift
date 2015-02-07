//
//  StartScene.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 07/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
	
	override func didMoveToView(view: SKView) {
		backgroundColor = NSColor.blackColor()
		anchorPoint = CGPoint(x: 0.5, y: 0.5)
		
		let title = SKLabelNode(text: "Press   Enter   to   Start")
		title.fontColor = NSColor.whiteColor()
		title.fontSize = 32
		title.fontName = "Pixeleris"
		title.position = CGPoint(x: 0, y: 0)
		
		addChild(title)
	}
	
	override func keyDown(theEvent: NSEvent) {
		let key = Controls.Key(rawValue: Int(theEvent.keyCode))
		switch key {
		case .Some(.Enter): moveToGameScene()
		case _: break
		}
	}
	
	func moveToGameScene() {
		if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
			/* Set the scale mode to scale to fit the window */
			scene.scaleMode = .AspectFit
			
			let transition = SKTransition.crossFadeWithDuration(0.3)
			self.view?.presentScene(scene)
		}
	}
}
