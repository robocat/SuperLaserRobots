//
//  extensions.swift
//  BuddyBuilder
//
//  Created by Ulrik Damm on 06/02/15.
//  Copyright (c) 2015 Robocat. All rights reserved.
//

import Foundation
import Cocoa
import SpriteKit

let π = CGFloat(M_PI)

extension NSEvent {
    enum Key : Int {
        case Up = 126
        case Down = 125
        case Right = 124
        case Left = 123
        case Space = 49
		case A = 0
		case W = 1
		case D = 2
		case S = 3
		case LShift = 4
		case RShift = 5
		case G = 6
		case Y = 7
		case J = 8
		case H = 9
    }
    
    var key : Key? {
        return Key(rawValue: Int(keyCode))
    }
}

extension SKTexture {
    func cut(horizontalSprites : Int, _ verticalSprites : Int) -> [SKTexture] {
        var sprites : [SKTexture] = []
        
        let width = CGFloat(1) / CGFloat(horizontalSprites)
        let height = CGFloat(1) / CGFloat(verticalSprites)
        let size = CGSize(width: width, height: height)
        
        for y in 0..<verticalSprites {
            for x in 0..<horizontalSprites {
                let point = CGPoint(x: width * CGFloat(x), y: height * CGFloat(y))
                let rect = CGRect(origin: point, size: size)
                sprites.append(SKTexture(rect: rect, inTexture: self))
            }
        }
        
        return sprites
    }
}

extension CGPoint {
    func clampToRect(rect : CGRect) -> CGPoint {
        var x = self.x
        var y = self.y
        
        if x < rect.origin.x {
            x = rect.origin.x
        } else if x > rect.origin.x + rect.size.width {
            x = rect.origin.x + rect.size.width
        }
        
        if y < rect.origin.y {
            y = rect.origin.y
        } else if y > rect.origin.y + rect.size.height {
            y = rect.origin.y + rect.size.height
        }
        
        return CGPoint(x: x, y: y)
    }
}

extension Int {
    static func random(range: Range<UInt32>) -> UInt32 {
        return range.startIndex + arc4random_uniform(range.endIndex - range.startIndex + 1)
    }
}

extension Array {
	
	// Stack - LIFO
	mutating func push(newElement: T) {
		self.append(newElement)
	}
	
	mutating func pop() -> T? {
		return self.removeLast()
	}
	
	func peekAtStack() -> T? {
		return self.last
	}
	
	// Queue - FIFO
	mutating func enqueue(newElement: T) {
		self.append(newElement)
	}
	
	mutating func dequeue() -> T? {
		return self.removeAtIndex(0)
	}
	
	func peekAtQueue() -> T? {
		return self.first
	}
}

func *(vector : CGVector, value : CGFloat) -> CGVector {
	return CGVector(dx: vector.dx * value, dy: vector.dy * value)
}
func -(left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
func +(left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
func /(left: CGPoint, factor: CGFloat) -> CGPoint {
	return CGPoint(x: left.x / factor, y: left.y / factor)
}
func *(left: CGPoint, factor: CGFloat) -> CGPoint {
	return left / (1/factor)
}

func random() -> CGFloat {
	let max : UInt32 = 10000
	let r = arc4random_uniform(max)
	return CGFloat(r) / CGFloat(max)
}
