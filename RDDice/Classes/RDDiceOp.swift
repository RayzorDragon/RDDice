//
//  RDDiceOp.swift
//  RDDice
//
//  Created by Raymond Gatz on 06/01/2016.
//  Copyright (c) 2016 Raymond Gatz. All rights reserved.
//

// the end goal of this class is to handle taking in string inputs in the form of human readable dice short hand (3d6, roll 3 six-sided dice. 3d4+3, roll 3 four-sided dice and add 3 to the total)
// once this basic functionality is operational, then see about other dice formats (Fudge: 1dF produces a 1, 0, or -1, StoryTeller: Where rolling so many ten-sided dice produces so many successes, counting 7 or greater as a success, and 10 is a double success)
// implement way to get random number generators that aren't the standard (Example: Web call out to random.org api)
// improve dice op to 1.) Handle assumed multiplication if a number is presented before a BBP and 2.) handle modulus operations

open class RDDiceOp {
	
	fileprivate let diceSymbol = "d"
	fileprivate let diceOp = "~^"
	fileprivate let fateSymbol = "f"
	fileprivate let fateOp = ""
	fileprivate let targetSymbol = "t"
	fileprivate let targetOp = ""
	
	class fileprivate func equationCleanUp(_ equationString: String) -> String {
		
		let simplifiedString = pbbCheckAndClean(equationString)
		var exclusionSet = CharacterSet.letters
		exclusionSet.formUnion(CharacterSet.whitespacesAndNewlines)
		let components = simplifiedString.components(separatedBy: exclusionSet)
		var trimmedString = components.joined(separator: "")
		
		let ops = getOps(trimmedString)
		let nums = getNums(trimmedString)
		let cleanedEquation = makeNewEquation(ops, nums: nums)
		return cleanedEquation
	}
	
	class fileprivate func pbbCheckAndClean(_ equationString: String) -> String {
		var newString = equationString
		
		// check string for following items [..], {..}, and (..). If they exist, evaluate them to a single number and then replace
		let enderSet = CharacterSet.init(charactersIn: "]})")
		let starterSet = CharacterSet.init(charactersIn: "[{(")
		let brackets = CharacterSet.init(charactersIn: "[]")
		let braces = CharacterSet.init(charactersIn: "{}")
		let parenthis = CharacterSet.init(charactersIn: "()")
		
		while let rangeEnder = newString.rangeOfCharacter(from: enderSet) {
			// step 1, find first ender
			let ender = newString.substring(with: rangeEnder)
			// step 2, find the matching starter
			var starter = ""
			if ender == "]" {
				starter = "["
			} else if ender == "}" {
				starter = "{"
			} else if ender == ")" {
				starter = "("
			}
			
			let subString = newString.substring(to: rangeEnder.lowerBound)
			let rangeStarter = subString.range(of: starter, options: .backwards)
			// step 3, evaluate everything between them by sending that string through equationCleanup
			var newEqu = subString.substring(from: (rangeStarter?.upperBound)!)
			newEqu = equationToTotal(newEqu)
			// step 4, replace old string along with starters and enders with new value
			let clRange: Range = (rangeStarter?.lowerBound)!..<rangeEnder.upperBound
			newString.replaceSubrange(clRange, with: newEqu)
			// take new string and repeat process until no more ender/starter pairs are found
		}
		
		return newString
	}
	
	class fileprivate func getOps(_ equationString: String) -> [String] {
		
		var opFinderSet = CharacterSet.alphanumerics
		opFinderSet.formUnion(CharacterSet.init(charactersIn: ""))

		let noDecimalStringComponents = equationString.components(separatedBy: CharacterSet.init(charactersIn: "."))
		let noDecString = noDecimalStringComponents.joined(separator: "")
		
		var ops = noDecString.components(separatedBy: opFinderSet)
		var indexs = [Int]()
		
		for (index, op) in ops.enumerated() {
			if op == "" {
				indexs.append(index)
			}
		}
		for index in indexs.reversed() {
			ops.remove(at: index)
		}
		
		return ops
	}
	
	class fileprivate func getNums(_ equationString: String) -> [String] {
		var numberFinderSet = CharacterSet.symbols
		numberFinderSet.formUnion(CharacterSet.init(charactersIn: "-*/"))
		
		// need to seperate numbers out from operators, and then remove multiple decimals
		var numbers = equationString.components(separatedBy: numberFinderSet)
		var indexs = [Int]()
		for (index, num) in numbers.enumerated() {
			if num == "" {
				indexs.append(index)
			}
		}
		for index in indexs.reversed() {
			numbers.remove(at: index)
		}
		
		var newNums = [String]()
		print(numbers)
		for var num in numbers {
			let subNums = num.components(separatedBy: CharacterSet.init(charactersIn: "."))
			if subNums.count > 1 {
				num = subNums[0] + "."
				for count in 1...subNums.count-1 {
					num = num + subNums[count]
				}
			} else {
				num = num + ".0"
			}
			newNums.append(num)
		}
		print(newNums)
		return newNums
	}
	
	class fileprivate func makeNewEquation(_ ops: [String], nums: [String]) -> String {
		// recreate string with new modifications
		var trimmedString = ""
		if nums.count == 1 && ops.count == 0 {
			// looks like we only have one thing?!
			trimmedString = nums.first!
		} else if abs(nums.count - ops.count) == 0 {
			// if equal, assume we start with an op at the beginning
			print("Do A Thing")
			for index in 0...ops.count-1 {
				if index == 0 && ops.first != "-" {
					trimmedString = trimmedString+nums[index]
				} else {
					trimmedString = trimmedString+ops[index]+nums[index]
				}
			}
		} else if abs(nums.count - ops.count) == 1 && nums.count > ops.count {
			// if not equal, and we have more numbers than operators, assume we start with numbers
			print("Do Another Thing")
			for index in 0...ops.count-1 {
				trimmedString = trimmedString+nums[index]+ops[index]
			}
			
			trimmedString = trimmedString+nums.last!
		} else {
			// otherwise, this doesn't make any since... at all
			print("wtf?")
		}
		
		return trimmedString
	}

    class open func equationToTotal(_ equationString: String) -> String {
		
		let newString = equationCleanUp(equationString)
		
		var mathValue = Double(0.0)
		
		do {
			print("New String: \(newString)")
			let mathExp = try NSExpression(format: newString)
			mathValue = try (mathExp.expressionValue(with: nil, context: nil))! as! Double
		} catch {
			mathValue = Double.nan
		}
		
        return String("\(mathValue)")
    }
    
    
}
