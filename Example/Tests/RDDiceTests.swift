//
//  RDDiceTests.swift
//  RDDice
//
//  Created by Raymond Gatz on 11/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import RDDice

class RDDiceTests: XCTestCase {
	override func setUp() {
		super.setUp()
	}
	
	func testSimpleOpAdd() {
		let testString = "1+2"
		
		let answer = RDDiceOp.equationToTotal(testString)
		expect(answer).to(match("3.0"))
	}
	
	func testSimpleOpSub() {
		let testString = "3-2"
		
		let answer = RDDiceOp.equationToTotal(testString)
		expect(answer).to(match("1.0"))
	}
	
	func testSimpleOpMulti() {
		let testString = "1*2"
		
		let answer = RDDiceOp.equationToTotal(testString)
		expect(answer).to(match("2.0"))
	}
	
	func testSimpleOpDiv() {
		let testString = "1/2"
		
		let answer = RDDiceOp.equationToTotal(testString)
		expect(answer).to(match("0.5"))
	}
	
	func testSimpleOpExp() {
		let testString = "2**2"
		
		let answer = RDDiceOp.equationToTotal(testString)
		expect(answer).to(match("4.0"))
	}
	
	func testDecimalOpAdd() {
		let testString = "1.11+2"
		
		let answer = RDDiceOp.equationToTotal(testString)
		expect(answer).to(match("3.11"))
	}
	
	func testDecimalOpSub() {
		let testString = "1.11-2"
		
		let answer = RDDiceOp.equationToTotal(testString)
		expect(answer).to(match("-0.89"))
	}
	
	func testDecimalOpMulti() {
		let testString = "1.33*2.97"
		
		let answer = RDDiceOp.equationToTotal(testString)
		expect(answer).to(match("3.9501"))
	}
	
	func testDecimalOpDiv() {
		let testString = "9.0/2.5"
		
		let answer = RDDiceOp.equationToTotal(testString)
		expect(answer).to(match("3.6"))
	}
	
	func testDecimalOpExp() {
		let testString = "3.5**3"
		
		let answer = RDDiceOp.equationToTotal(testString)
		expect(answer).to(match("42.875"))
	}
	
	func testDivByZero() {
		let testString = "3/0"
		
		let answer = RDDiceOp.equationToTotal(testString)
		expect(answer).to(match("inf"))
	}
}