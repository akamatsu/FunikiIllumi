//
//  InterfaceController.swift
//  FunikiIllumi WatchKit Extension
//
//  Created by aka on 2015/04/22.
//  Copyright (c) 2015年 Matilde Inc. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

	let selectedColor = UIColor(hue: 0.5861, saturation: 1.0, brightness: 1.0, alpha: 1.0)
	//let unselectedColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 1.0, alpha: 1.0)
	let unselectedColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.2, alpha: 1.0)

	@IBOutlet weak var toumeiButton: WKInterfaceButton!
	@IBOutlet weak var yuruyakaButton: WKInterfaceButton!
	@IBOutlet weak var bonyariButton: WKInterfaceButton!
	@IBOutlet weak var chikachikaButton: WKInterfaceButton!
	@IBOutlet weak var dotabataButton: WKInterfaceButton!
	@IBOutlet weak var tokidokiButton: WKInterfaceButton!
	
	var selectedButton: WKInterfaceButton?
	
	override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
		
		selectedButton = toumeiButton
		changeButtonColor(toumeiButton)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
		
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	
	func changeButtonColor(button: WKInterfaceButton) {
		selectedButton?.setBackgroundColor(unselectedColor)
		button.setBackgroundColor(selectedColor)
		selectedButton = button
	}

	@IBAction func toumeiPushed() {
		changeButtonColor(toumeiButton)
		WKInterfaceController.openParentApplication(["buttonPushed": "Tou Mei"],reply: nil)
	}
	@IBAction func yuruyakaPushed() {
		changeButtonColor(yuruyakaButton)
		WKInterfaceController.openParentApplication(["buttonPushed": "Yuru Yaka"],reply: nil)
	}
	@IBAction func bonyariPushed() {
		changeButtonColor(bonyariButton)
		WKInterfaceController.openParentApplication(["buttonPushed": "Bon Yari"],reply: nil)
	}
	@IBAction func chikachikaPushed() {
		changeButtonColor(chikachikaButton)
		WKInterfaceController.openParentApplication(["buttonPushed": "Chika Chika"],reply: nil)
	}
	@IBAction func dotabataPushed() {
		changeButtonColor(dotabataButton)
		WKInterfaceController.openParentApplication(["buttonPushed": "Dota Bata"],reply: nil)
	}
	@IBAction func tokidokiPushed() {
		changeButtonColor(tokidokiButton)
		WKInterfaceController.openParentApplication(["buttonPushed": "Toki Doki"],reply: nil)
	}
}
