//
//  Created by Matilde Inc.
//  Copyright (c) 2015 FUN'IKI Project. All rights reserved.
//  Modified by Masayuki Akamatsu
//  Copyright (c) 2015 Masayuki Akamatsu. All rights reserved.
//

import UIKit
import iAd

class FunikiIllumiViewController: UIViewController, MAFunikiManagerDelegate, MAFunikiManagerDataDelegate {
	
	let demo = false	// スクリーン・キャプチャを取る場合は、これをtrueにする
	
	let appGroup = "group.org.akamatsu.FunikiIllumi"
	var wormhole: MMWormhole!

	let toumeiID = "Tou Mei"
	let yuruyakaID = "Yuru Yaka"
	let bonyariID = "Bon Yari"
	let chikachikaID = "Chika Chika"
	let dotabataID = "Dota Bata"
	let tokidokiID = "Toki Doki"

	let funikiManager = MAFunikiManager.sharedInstance()
	var illuminationTimer: NSTimer?
	var rightColor : UIColor?
	var leftColor : UIColor?
	var hue: CGFloat = 0.0
	var saturation: CGFloat = 1.0
	var brightness: CGFloat = 1.0
	var counter = 0
	var timerDuration = 0.25
	var presetID = ""
	let selectedColor = UIColor(hue: 0.5861, saturation: 1.0, brightness: 1.0, alpha: 1.0)
	let unselectedColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 1.0, alpha: 1.0)
	
	@IBOutlet var connectionLabel:UILabel!
    @IBOutlet var batteryLabel:UILabel!
	@IBOutlet var presetButtonsGroup: [UIButton]!
	@IBOutlet var defaultButton: UIButton!
	
	// ---------------------------------------------------------------------
	// MARK: - FUN'IKI Update
	// ---------------------------------------------------------------------

	func updateConnectionStatus() {
        if funikiManager.connected {
            self.connectionLabel.text = NSLocalizedString("Connected", comment: "")
        }else {
            self.connectionLabel.text = NSLocalizedString("Not Connected", comment: "")
        }
		
		if demo {
			self.connectionLabel.text = NSLocalizedString("Connected", comment: "")
		}
	}
    
    func updateBatteryLevel(){
		let batteryLevelString = NSLocalizedString("Battery Level: ", comment: "")
        switch funikiManager.batteryLevel {
        case .Unknown:
            self.batteryLabel.text = batteryLevelString + NSLocalizedString("Unknow", comment: "")
            
        case .Low:
            self.batteryLabel.text = batteryLevelString + NSLocalizedString("Low", comment: "")
			
        case .Medium:
            self.batteryLabel.text = batteryLevelString + NSLocalizedString("Midium", comment: "")
            
        case .High:
            self.batteryLabel.text = batteryLevelString + NSLocalizedString("High", comment: "")
            
        default:
            self.batteryLabel.text = batteryLevelString + NSLocalizedString("Unknow", comment: "")
        }
		
		if demo {
			self.batteryLabel.text = batteryLevelString + NSLocalizedString("High", comment: "")
		}
    }

	
	// ---------------------------------------------------------------------
	// MARK: - View Controls
	// ---------------------------------------------------------------------
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if demo == false {
			self.canDisplayBannerAds = true
		}
		
		// Watchとの通信
		wormhole = MMWormhole(applicationGroupIdentifier:appGroup, optionalDirectory:"FunikiIllumi")
		// Watchからの受信
		self.wormhole.listenForMessageWithIdentifier("fromWatch", listener: { (messageObject) -> Void in
			if let command = messageObject.objectForKey("command") as? String {
				if command == "getPresetID" {
					self.wormhole.passMessageObject(["presetID": self.presetID], identifier: "fromApp")
				}
			}
		})
		
		// ボタンの初期状態
		presetSelected(defaultButton)
	}
	
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

		funikiManager.delegate = self
		funikiManager.dataDelegate = self
   }
	

	// ---------------------------------------------------------------------
	// MARK: - FUN'IKI Delegates
	// ---------------------------------------------------------------------

	func funikiManagerDidConnect(manager: MAFunikiManager!) {
        println("SDK Version\(MAFunikiManager.funikiSDKVersionString())")
        println("Firmware Revision\(manager.firmwareRevision)")
        updateConnectionStatus()
        updateBatteryLevel()
    }
    
    func funikiManagerDidDisconnect(manager: MAFunikiManager!, error: NSError!) {

        if let actualError = error {
            println(actualError)
        }
        updateConnectionStatus()
        updateBatteryLevel()
    }
    
    func funikiManager(manager: MAFunikiManager!, didUpdateBatteryLevel batteryLevel: MAFunikiManagerBatteryLevel) {
        updateBatteryLevel()
    }
    
    func funikiManager(manager: MAFunikiManager!, didUpdateCentralState state: CBCentralManagerState) {
        updateConnectionStatus()
        updateBatteryLevel()
    }
    
    // MARK: - MAFunikiManagerDataDelegate
    func funikiManager(manager: MAFunikiManager!, didUpdateMotionData motionData: MAFunikiMotionData!) {
        println(motionData)
    }
    
    func funikiManager(manager: MAFunikiManager!, didPushButton buttonEventType: MAFunikiManagerButtonEventType) {
        
    }
	
	// ---------------------------------------------------------------------
	// MARK: - Actions
	// ---------------------------------------------------------------------
	
	@IBAction func presetSelected(sender: UIButton) {
		presetID = sender.restorationIdentifier!
		
		for button:UIButton in presetButtonsGroup {
			let id = button.restorationIdentifier!
			if id == presetID {
				button.backgroundColor = selectedColor
				button.setTitleColor(unselectedColor, forState: UIControlState.Normal)
			} else {
				button.backgroundColor = unselectedColor
				button.setTitleColor(selectedColor, forState: UIControlState.Normal)
			}
		}
		
		if presetID == toumeiID {
			toumei()
			illuminationTimer?.invalidate()
			illuminationTimer = nil
		} else {
			if illuminationTimer == nil {
				illuminationTimer = NSTimer.scheduledTimerWithTimeInterval(timerDuration, target: self, selector: "timerFired:", userInfo: nil, repeats: true)
			}
		}
		
		wormhole.passMessageObject(["presetID": presetID], identifier: "fromApp")
	}
	
	func timerFired(timer:NSTimer) {
		switch presetID {
			case toumeiID:		toumei()
			case yuruyakaID:	yuruyaka()
			case bonyariID:		bonyari()
			case chikachikaID:	chikachika()
			case dotabataID:	dotabata()
			case tokidokiID:	tokidoki()
			default:			toumei()
		}
	}
	
	// ---------------------------------------------------------------------
	// MARK: - Watch
	// ---------------------------------------------------------------------
	
	func buttonPushed(buttonID: String) {
		for button:UIButton in presetButtonsGroup {
			let id = button.restorationIdentifier
			if id == buttonID {
				presetSelected(button)
			}
		}
	}

	
	// ---------------------------------------------------------------------
	// MARK: - Light presets
	// ---------------------------------------------------------------------
	
	func toumei() {
		funikiManager.changeLeftColor(UIColor.blackColor(), rightColor: UIColor.blackColor(), duration: 0.0)
		leftColor = nil
		rightColor = nil
	}
	
	func yuruyaka() {
		if counter == 0 {
			hue = hue + CGFloat(arc4random_uniform(100)) * 0.01 * 0.1 - 0.05
			if hue > 1.0 {
				hue = 1.0
			} else if hue < 0.0 {
				hue = 0.0
			}
			saturation = saturation + CGFloat(arc4random_uniform(100)) * 0.01 * 0.1 - 0.05
			if saturation > 0.7 {
				saturation = 0.7
			} else if saturation < 0.3 {
				saturation = 0.3
			}
			brightness = brightness + CGFloat(arc4random_uniform(100)) * 0.01 * 0.1 - 0.05
			if brightness > 0.2 {
				brightness = 0.2
			} else if brightness < 0.0 {
				brightness = 0.0
			}
			leftColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
			rightColor = leftColor
			funikiManager.changeLeftColor(leftColor, rightColor: rightColor, duration: 1.0)
			//println("\(hue) \(saturation) \(brightness)")
		}
		
		counter = (counter + 1) % 10
	}
	
	func bonyari() {
		if counter == 0 {
			hue = CGFloat(arc4random_uniform(100)) * 0.01
			saturation = CGFloat(arc4random_uniform(100)) * 0.01 * 0.5 + 0.25
			brightness = 0.05
			leftColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
			rightColor = leftColor
			funikiManager.changeLeftColor(leftColor, rightColor: rightColor, duration: 2.0)
		} else if (counter == 20) {
			funikiManager.changeLeftColor(UIColor.blackColor(), rightColor: UIColor.blackColor(), duration: 2.0)
			leftColor = nil
			rightColor = nil
		}
		
		counter = (counter + 1) % 30
	}

	func chikachika() {
		if counter == 0 {
			hue = hue + 0.005
			if hue > 1.0 {
				hue = 0.0
			}
			leftColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
			rightColor = leftColor
			funikiManager.changeLeftColor(leftColor, rightColor: rightColor, duration: 0.0)
		} else if (counter == 1) {
			funikiManager.changeLeftColor(UIColor.blackColor(), rightColor: UIColor.blackColor(), duration: 0.0)
			leftColor = nil
			rightColor = nil
		}
		
		counter = (counter + 1) % 4
	}
	
	func dotabata() {
		if arc4random_uniform(2) == 0 {
			hue = CGFloat(arc4random_uniform(100)) * 0.01
			leftColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
		} else {
			leftColor = UIColor.blackColor()
		}
		if arc4random_uniform(2) == 0 {
			hue = CGFloat(arc4random_uniform(100)) * 0.01
			rightColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
		} else {
			rightColor = UIColor.blackColor()
		}
		funikiManager.changeLeftColor(leftColor, rightColor: rightColor, duration: 0.0)
	}

	func tokidoki() {
		if leftColor == nil && rightColor == nil {
			if arc4random_uniform(100) == 0 {
				hue = CGFloat(arc4random_uniform(100)) * 0.01
				leftColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
				if arc4random_uniform(5) == 0 {
					hue = CGFloat(arc4random_uniform(100)) * 0.01
					rightColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
				} else {
					rightColor = leftColor
				}
				funikiManager.changeLeftColor(leftColor, rightColor: rightColor, duration: 0.0)
			}
		} else {
			funikiManager.changeLeftColor(UIColor.blackColor(), rightColor: UIColor.blackColor(), duration: 0.0)
			leftColor = nil
			rightColor = nil
		}
	}
}

