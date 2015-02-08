//
//  AppDelegate.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 06/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
	
	var musicPlayer : MusicPlayer?
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
//		let scene = StartScene(size: CGSize(width: 1024, height: 768))
//		scene.scaleMode = .AspectFit
		
		if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
			/* Set the scale mode to scale to fit the window */
			scene.scaleMode = .AspectFit
			
			let transition = SKTransition.crossFadeWithDuration(0.3)
			self.skView?.presentScene(scene)
		}
		
//		self.skView!.presentScene(scene)
		
		/* Sprite Kit applies additional optimizations to improve rendering performance */
		self.skView!.ignoresSiblingOrder = true
		
//		self.skView!.showsFPS = true
//		self.skView!.showsNodeCount = true
			
		setupMusic()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
	
	func setupMusic() {
		let path = NSBundle.mainBundle().URLForResource("LaserMusic", withExtension: "mp3")!
		musicPlayer = MusicPlayer(fileURL: path)
		musicPlayer?.play()
	}
}
