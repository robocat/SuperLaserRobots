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
		// Player 1
		case A = 0
		case W = 13
		case D = 2
		case S = 1
		case Tab = 48
		
		// Player 2
		case Up = 126
		case Down = 125
		case Right = 124
		case Left = 123
		case Backspace = 51
		
		// Player 3
		case G = 5
		case Y = 16
		case J = 38
		case H = 4
		case Space = 49
		
		// Player 4
		case P = 35
		case L = 37
		case Colon = 41
		case Comma = 39
		case Plus = 24
		
		// Other
		case Enter = 36
		case Escape = 53
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
				],
				[
					.L:				.TurnLeft,
					.Comma:			.TurnRight,
					.P:				.Forward,
					.Plus:			.Fire
				]
			]
		}
	}
}