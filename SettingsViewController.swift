//
//  SettingsViewController.swift
//  Keepmystuff
//
//  Created by Default on 8/1/16.
//  Copyright © 2016 LabuTech. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, ABPadLockScreenSetupViewControllerDelegate, ABPadLockScreenViewControllerDelegate  {
    
    @IBOutlet weak var enablePassword: UISwitch!
    
    private(set) var thePin: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let defaults = NSUserDefaults(suiteName: "Passcode")
        
        if let flag = defaults?.boolForKey("passcodeEnabled") {
            enablePassword.on = flag
        } else {
            enablePassword.on = false
        }
        
        thePin = defaults?.stringForKey("passcodePin")
        
        // Do any additional setup after loading the view.
        
        ABPadSetAppearance()
     
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enablePassword(sender: UISwitch) {
    
        let defaults = NSUserDefaults(suiteName: "Passcode")
        
        if sender.on {
            defaults?.setBool(true, forKey: "passcodeEnabled")
        } else {
            defaults?.setBool(false, forKey: "passcodeEnabled")
        }
        
        //defaults?.boolForKey("passcodeEnabled")
        
        defaults?.synchronize()

    }

    @IBAction func changePassword(sender: AnyObject) {
        lockApp()
    }
    
    func ABPadSetAppearance() {
        ABPadLockScreenView.appearance().backgroundColor = UIColor(hue:0.61, saturation:0.55, brightness:0.64, alpha:1)
        
        ABPadLockScreenView.appearance().labelColor = UIColor.whiteColor()
        
        let buttonLineColor = UIColor(red: 229/255, green: 180/255, blue: 46/255, alpha: 1)
        ABPadButton.appearance().backgroundColor = UIColor.clearColor()
        ABPadButton.appearance().borderColor = buttonLineColor
        ABPadButton.appearance().selectedColor = buttonLineColor
        ABPinSelectionView.appearance().selectedColor = buttonLineColor
    }
    
    func setPin() {
        
        let lockSetupScreen = ABPadLockScreenSetupViewController(delegate: self, complexPin: false, subtitleLabelText: "Select a pin")
        lockSetupScreen.tapSoundEnabled = true
        lockSetupScreen.errorVibrateEnabled = true
        lockSetupScreen.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        lockSetupScreen.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(lockSetupScreen, animated: true, completion: nil)
    }
    
    func lockApp() {
        
        if thePin == nil {
            let alertController = UIAlertController(title: "You must set a pin first", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        let lockScreen = ABPadLockScreenViewController(delegate: self, complexPin: false)
        lockScreen.setAllowedAttempts(3)
        lockScreen.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        lockScreen.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(lockScreen, animated: true, completion: nil)
    }
    
    //MARK: Lock Screen Setup Delegate
    func pinSet(pin: String!, padLockScreenSetupViewController padLockScreenViewController: ABPadLockScreenSetupViewController!) {
        thePin = pin
        
        
        let defaults = NSUserDefaults(suiteName: "Passcode")
        
        defaults?.setBool(true, forKey: "passcodeEnabled")
        defaults?.setObject(thePin, forKey: "passcodePin")
        
       // let controller = storyboard?.instantiateViewControllerWithIdentifier("SettingsViewController")
       // self.navigationController?.popToViewController(controller!, animated: true)
        dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func unlockWasCancelledForSetupViewController(padLockScreenViewController: ABPadLockScreenAbstractViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Lock Screen Delegate
    func padLockScreenViewController(padLockScreenViewController: ABPadLockScreenViewController!, validatePin pin: String!) -> Bool {
        print("Validating Pin \(pin)")
        return thePin == pin
    }
    
    func unlockWasSuccessfulForPadLockScreenViewController(padLockScreenViewController: ABPadLockScreenViewController!) {
        print("Unlock Successful!")
        dismissViewControllerAnimated(true, completion: nil)
        setPin()
    }
    
    func unlockWasUnsuccessful(falsePin: String!, afterAttemptNumber attemptNumber: Int, padLockScreenViewController: ABPadLockScreenViewController!) {
        print("Failed Attempt \(attemptNumber) with incorrect pin \(falsePin)")
    }
    
    func unlockWasCancelledForPadLockScreenViewController(padLockScreenViewController: ABPadLockScreenViewController!) {
        print("Unlock Cancled")
        //exit(0)
        dismissViewControllerAnimated(true, completion: nil)
    }

}
