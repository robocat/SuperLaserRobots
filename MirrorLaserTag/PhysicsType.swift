//
//  PhysicsType.swift
//  MirrorLaserTag
//
//  Created by Kristian Andersen on 06/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import Foundation

enum PhysicsType: UInt32 {
	case Player = 1
	case Obstacle = 2
	case Mirror = 4
	case Projectile = 8
	case PowerUp = 16
}
