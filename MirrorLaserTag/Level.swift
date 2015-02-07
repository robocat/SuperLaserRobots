//
//  Level.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 07/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import SpriteKit

struct ObstaclePosition {
	let type: ObstacleType
	let position: CGPoint
	let angle: CGFloat
}

struct Level {
	let obstacles: [ObstaclePosition] = []
	
	static var all: [Level] {
		get {
			return [
				Level(obstacles: [
					ObstaclePosition(type: .Plant, position: CGPoint(x: 0, y: 0), angle: 0)
				])
			]
		}
	}
}
