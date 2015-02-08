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
	let flipped: Bool
	let size: CGSize
}

struct Level {
	let obstacles: [ObstaclePosition] = []
	
	static var all: [Level] {
		get {
			return [
				Level(obstacles: [
					// Destructables
//					ObstaclePosition(type: .Plant,
//						position: CGPoint(x: 0, y: 0),
//						angle: 0,
//						size: CGSize(width: 52, height: 58)),
//					// Walls
					ObstaclePosition(type: .Wall,
						position: CGPoint(x: -372, y: 0),
						angle: 0,
						flipped: false,
						size: CGSize(width: 254, height: 14)),
					ObstaclePosition(type: .Wall,
						position: CGPoint(x: -20, y: 331),
						angle: π/2,
						flipped: true,
						size: CGSize(width: 254, height: 14)),
					ObstaclePosition(type: .Wall,
						position: CGPoint(x: 40, y: -331),
						angle: -π/2,
						flipped: true,
						size: CGSize(width: 254, height: 14)),
					ObstaclePosition(type: .Wall,
						position: CGPoint(x: 372, y: 0),
						angle: 0,
						flipped: true,
						size: CGSize(width: 254, height: 14)),
					ObstaclePosition(type: .Computer,
						position: CGPoint(x: 76, y: 302),
						angle: 0,
						flipped: false,
						size: CGSize(width: 156, height: 204)),
					ObstaclePosition(type: .Tube,
						position: CGPoint(x: 401, y: -99),
						angle: 0,
						flipped: false,
						size: CGSize(width: 98, height: 98)),
					ObstaclePosition(type: .Tube,
						position: CGPoint(x: -49, y: -299),
						angle: 0,
						flipped: false,
						size: CGSize(width: 98, height: 98))
				])
			]
		}
	}
}
