	//
//  ViewController.swift
//  RDDice
//
//  Created by Raymond Gatz on 06/01/2016.
//  Copyright (c) 2016 Raymond Gatz. All rights reserved.
//

import UIKit
import RDDice

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var outputLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func computeAction(_ sender: AnyObject) {
        print(inputField.text)
		if let exp = inputField.text {
			
			let ans = RDDiceOp.equationToTotal(exp)
			outputLabel.text = ans
		}
    }
}

