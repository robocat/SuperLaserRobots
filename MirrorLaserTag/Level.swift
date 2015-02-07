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
	let size: CGSize
}

struct Level {
	let obstacles: [ObstaclePosition] = []
	
	static var all: [Level] {
		get {
			return [
				Level(obstacles: [
					// Destructables
					ObstaclePosition(type: .Plant,
						position: CGPoint(x: 0, y: 0),
						angle: 0,
						size: CGSize(width: 52, height: 58)),
					// Walls
					ObstaclePosition(type: .Wall,
						position: CGPoint(x: -400, y: -400),
						angle: 0,
						size: CGSize(width: 10, height: 400))
				])
			]
		}
	}
}
