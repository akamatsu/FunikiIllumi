//
//  Created by Matilde Inc.
//  Copyright (c) 2015 FUN'IKI Project. All rights reserved.
//

import UIKit
import iAd

class FunikiIllumiViewController: UIViewController, MAFunikiManagerDelegate, MAFunikiManagerDataDelegate {

    let funikiManager = MAFunikiManager.sharedInstance()
	var illuminationTimer: NSTimer?
	var rightColor : UIColor?
	var leftColor : UIColor?
	var hue: CGFloat = 0.0
	var saturation: CGFloat = 1.0
	var brightness: CGFloat = 1.0
	var counter = 0
	var timerDuration = 0.25
	var variationID = ""
	let selectedColor = UIColor(hue: 0.5861, saturation: 1.0, brightness: 1.0, alpha: 1.0)
	let unselectedColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 1.0, alpha: 1.0)
	
	@IBOutlet var connectionLabel:UILabel!
    @IBOutlet var batteryLabel:UILabel!
	@IBOutlet var variations: [UIButton]!
	@IBOutlet var defaultButton: UIButton!
	
    // MARK: -
    func updateConnectionStatus() {
        if funikiManager.connected {
            self.connectionLabel.text = NSLocalizedString("Connected", comment: "")
        }else {
            self.connectionLabel.text = NSLocalizedString("Not Connected", comment: "")
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
    }

	
	// ---------------------------------------------------------------------
	// MARK: - View Controls
	// ---------------------------------------------------------------------
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.canDisplayBannerAds = true
		
  		funikiManager.delegate = self
		funikiManager.dataDelegate = self
		
		variationSelected(defaultButton)
   }
	
    override func viewWillAppear(animated: Bool) {
   
        super.viewWillAppear(animated)
    }
	

	// ---------------------------------------------------------------------
	// MARK: - Funiki Delegates
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
	
	@IBAction func variationSelected(sender: UIButton) {
		variationID = sender.restorationIdentifier!
		
		for button:UIButton in variations {
			let id = button.restorationIdentifier!
			if id == variationID {
				button.backgroundColor = selectedColor
				button.setTitleColor(unselectedColor, forState: UIControlState.Normal)
			} else {
				button.backgroundColor = unselectedColor
				button.setTitleColor(selectedColor, forState: UIControlState.Normal)
			}
		}
		
		if variationID == "(None)" {
			toumei()
			illuminationTimer?.invalidate()
			illuminationTimer = nil
		} else {
			if illuminationTimer == nil {
				illuminationTimer = NSTimer.scheduledTimerWithTimeInterval(timerDuration, target: self, selector: "timerFired:", userInfo: nil, repeats: true)
			}
		}
	}
	
	func timerFired(timer:NSTimer) {
		switch variationID {
			case "(None)":
				toumei()
			case "Yuru Yaka":
				yuruyaka()
			case "Bon Yari":
				bonyari()
			case "Chika Chika":
				chikachika()
			case "Dota Bata":
				dotabata()
			case "Toki Doki":
				tokidoki()
			default:
				toumei()
		}
	}
	
	// ---------------------------------------------------------------------
	// MARK: - Watch
	// ---------------------------------------------------------------------
	
	func buttonPushed(buttonTitle: String) {
		for button:UIButton in variations {
			let title = button.titleLabel!.text!
			if title == buttonTitle {
				variationSelected(button)
			}
		}
	}

	
	// ---------------------------------------------------------------------
	// MARK: - Light Variations
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
			println("\(hue) \(saturation) \(brightness)")
		}
		
		counter = (counter + 1) % 20
	}
	
	func bonyari() {
		if counter == 0 {
			hue = CGFloat(arc4random_uniform(100)) * 0.01
			saturation = CGFloat(arc4random_uniform(100)) * 0.01 * 0.5 + 0.25
			brightness = CGFloat(arc4random_uniform(100)) * 0.01 * 0.1 + 0.05
			leftColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
			rightColor = leftColor
			funikiManager.changeLeftColor(leftColor, rightColor: rightColor, duration: 0.5)
		} else if (counter == 20) {
			funikiManager.changeLeftColor(UIColor.blackColor(), rightColor: UIColor.blackColor(), duration: 0.5)
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

