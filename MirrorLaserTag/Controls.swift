//
//  Controls.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 06/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import SpriteKit

enum Command {
	case Forward
	case TurnLeft
	case TurnRight
	case Fire
}

struct Controls {
	weak var player: Player?
	let mappings: [Key: Command]
	
	enum Key : Int {
		case Up = 126
		case Down = 125
		case Right = 124
		case Left = 123
		case Backspace = 51
		
		case A = 0
		case W = 1
		case D = 2
		case S = 3
		case Tab = 48
		
		case G = 5
		case Y = 16
		case J = 38
		case H = 4
		case Space = 49
	}
	
	static var mappings: [[Key: Command]] {
		get {
			return [
				[
					.A: 			.TurnLeft,
					.D: 			.TurnRight,
					.W: 			.Forward,
					.Tab: 			.Fire
				],
				[
					.Left: 			.TurnLeft,
					.Right: 		.TurnRight,
					.Up: 			.Forward,
					.Backspace: 	.Fire
				],
				[
					.G: 			.TurnLeft,
					.J: 			.TurnRight,
					.Y: 			.Forward,
					.Space: 		.Fire
				]
			]
		}
	}
}