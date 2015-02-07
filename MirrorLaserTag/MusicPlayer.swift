//
//  MusicPlayer.swift
//  MirrorLaserTag
//
//  Created by Ulrik Damm on 07/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import Foundation
import AVFoundation

class MusicPlayer {
	var player: AVAudioPlayer!
	
	init(fileURL: NSURL) {
		var error: NSError?
		
		player = AVAudioPlayer(contentsOfURL: fileURL, error: &error)
		player.numberOfLoops = -1
		player.volume = 0.7
		player.prepareToPlay()
	}
	
	func play() {
		//player.play()
	}
	
	func pause() {
		player.pause()
	}
}
