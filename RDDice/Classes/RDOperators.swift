//
//  RDOperators.swift
//  RDDice
//
//  Created by Raymond Gatz on 11/14/16.
//  Copyright (c) 2016 Raymond Gatz. All rights reserved.
//

import Foundation

protocol RegularExpressionDice {
	func dice(number: Int, sides: Int)
}

infix operator ~^: AdditionPrecedence
public func ~^ (numOfDice: Int, diceSides: Int) -> [Int] {
	var dicePool = [Int]()
	for index in 0..<numOfDice {
		let roll = arc4random_uniform(UInt32(diceSides))+1 // because 0 isn't a side
		dicePool.append(Int(roll))
	}
	return dicePool
}
