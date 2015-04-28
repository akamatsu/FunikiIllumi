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

	let appGroup = "group.org.akamatsu.FunikiIllumi"
	var wormhole: MMWormhole!

	let toumeiID = "Tou Mei"
	let yuruyakaID = "Yuru Yaka"
	let bonyariID = "Bon Yari"
	let chikachikaID = "Chika Chika"
	let dotabataID = "Dota Bata"
	let tokidokiID = "Toki Doki"
	
	let selectedColor = UIColor(hue: 0.5861, saturation: 1.0, brightness: 1.0, alpha: 1.0)
	let unselectedColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.2, alpha: 1.0)

	@IBOutlet weak var toumeiButton: WKInterfaceButton!
	@IBOutlet weak var yuruyakaButton: WKInterfaceButton!
	@IBOutlet weak var bonyariButton: WKInterfaceButton!
	@IBOutlet weak var chikachikaButton: WKInterfaceButton!
	@IBOutlet weak var dotabataButton: WKInterfaceButton!
	@IBOutlet weak var tokidokiButton: WKInterfaceButton!
	
	override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
		changeButtonColor(toumeiButton)

		// iOSとの通信
		wormhole = MMWormhole(applicationGroupIdentifier:appGroup, optionalDirectory:"FunikiIllumi")
		// iOSからの受信
		self.wormhole.listenForMessageWithIdentifier("fromApp", listener: { (messageObject) -> Void in
			if let presetID = messageObject.objectForKey("presetID") as? String {
				self.changeButtonColorByID(presetID)
			}
		})
	}
	
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
		
        super.willActivate()
		WKInterfaceController.openParentApplication(["getPresetID": "getPresetID"],
			reply: {replyInfo, error in
				if let presetID = replyInfo["presetID"] as? String {
					self.changeButtonColorByID(presetID)
				}
			})
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	
	func changeButtonColorByID(presetID: String) {
		switch presetID {
			case self.toumeiID:		self.changeButtonColor(self.toumeiButton)
			case self.yuruyakaID:	self.changeButtonColor(self.yuruyakaButton)
			case self.bonyariID:	self.changeButtonColor(self.bonyariButton)
			case self.chikachikaID:	self.changeButtonColor(self.chikachikaButton)
			case self.dotabataID:	self.changeButtonColor(self.dotabataButton)
			case self.tokidokiID:	self.changeButtonColor(self.tokidokiButton)
			default:				self.changeButtonColor(self.toumeiButton)
		}
	}
	
	func changeButtonColor(button: WKInterfaceButton) {
		toumeiButton.setBackgroundColor(unselectedColor)
		yuruyakaButton.setBackgroundColor(unselectedColor)
		bonyariButton.setBackgroundColor(unselectedColor)
		chikachikaButton.setBackgroundColor(unselectedColor)
		dotabataButton.setBackgroundColor(unselectedColor)
		tokidokiButton.setBackgroundColor(unselectedColor)

		button.setBackgroundColor(selectedColor)
	}

	@IBAction func toumeiPushed() {
		changeButtonColor(toumeiButton)
		WKInterfaceController.openParentApplication(["buttonPushed": toumeiID],reply: nil)
	}
	@IBAction func yuruyakaPushed() {
		changeButtonColor(yuruyakaButton)
		WKInterfaceController.openParentApplication(["buttonPushed": yuruyakaID],reply: nil)
	}
	@IBAction func bonyariPushed() {
		changeButtonColor(bonyariButton)
		WKInterfaceController.openParentApplication(["buttonPushed": bonyariID],reply: nil)
	}
	@IBAction func chikachikaPushed() {
		changeButtonColor(chikachikaButton)
		WKInterfaceController.openParentApplication(["buttonPushed": chikachikaID],reply: nil)
	}
	@IBAction func dotabataPushed() {
		changeButtonColor(dotabataButton)
		WKInterfaceController.openParentApplication(["buttonPushed": dotabataID],reply: nil)
	}
	@IBAction func tokidokiPushed() {
		changeButtonColor(tokidokiButton)
		WKInterfaceController.openParentApplication(["buttonPushed": tokidokiID],reply: nil)
	}
}
