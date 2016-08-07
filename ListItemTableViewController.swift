//
//  ListItemTableViewController.swift
//  MakeSchoolItem

//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift

class ListItemTableViewController: UITableViewController , ABPadLockScreenSetupViewControllerDelegate, ABPadLockScreenViewControllerDelegate {
    
    
    private(set) var thePin: String?
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Ask for the pin if it is not set
        // Show the pin if it set.
        
        ABPadSetAppearance()
        
        let defaults = NSUserDefaults(suiteName: "Passcode")
        
        if defaults?.objectForKey("passcodeEnabled") != nil {
            if let flag = defaults?.boolForKey("passcodeEnabled") {
                // show me the passcode screen
                if flag {
                    thePin = defaults?.stringForKey("passcodePin")
                    lockApp()
                }
            }
        } else {
            setPin()
        }
        
        
        
        items = RealmHelper.retrieveItem()
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        //self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = UIColor(red: 77.0/255.0, green: 172.0/255.0,blue: 241.0/255.0, alpha: 1.0)
        
       let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

        searchBar.delegate = self
        self.searchBar.delegate = self
    }
    
    
    var items: Results<Item>! {
        didSet {
            filteredData = items
            tableView.reloadData()
        }
    }
    
    
    var filteredData: Results<Item>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(true)
        searchBar.text = ""
        filteredData = items
    }
    
    
    // 1
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 2
        if editingStyle == .Delete {
            // 3
            RealmHelper.deleteItem(items[indexPath.row])
            // 4
            items = RealmHelper.retrieveItem()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "detailDisplayPage" {
                print("Table view cell tapped")
                // 1
                let indexPath = tableView.indexPathForSelectedRow!
                // 2
                let item = filteredData[indexPath.row]
                // 3
                //let displayItemViewController = segue.destinationViewController as! DisplayItemViewController
                // 4
                // displayItemViewController.item = item
                
                let controller = segue.destinationViewController as? DetailDisplayVC
                controller?.item = item
                
            } else if identifier == "addItem" {
                print("+ button tapped")
            }
        }
        
    }
    
    
    @IBAction func unwindToListItemViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        items = RealmHelper.retrieveItem()
        tableView.reloadData()
        
    }
    
    // 1
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
        UIView.animateWithDuration(1.0) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    
    
    // 2
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listItemTableViewCell", forIndexPath: indexPath) as! ListItemTableViewCell
        
        // 1
        let row = indexPath.row
        
        // 2
        let item = filteredData[row]
        
        
        // 3
        cell.itemNameLabel.text = item.itemname
        
        // 4
        cell.itemLocationLabel.text = item.itemlocation
        
        cell.itemDescriptionLabel.text = item.itemdescription
        
        //5
        cell.timeLabel.text = item.modificationTime.convertToString()
        
        
        
        return cell
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
        
        dismissViewControllerAnimated(true, completion: nil)
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
    }
    
    func unlockWasUnsuccessful(falsePin: String!, afterAttemptNumber attemptNumber: Int, padLockScreenViewController: ABPadLockScreenViewController!) {
        print("Failed Attempt \(attemptNumber) with incorrect pin \(falsePin)")
    }
    
    func unlockWasCancelledForPadLockScreenViewController(padLockScreenViewController: ABPadLockScreenViewController!) {
        print("Unlock Cancled")
        exit(0)
        // dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension ListItemTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        /*
         filteredData = items.filter({ (item) -> Bool in
         return item.itemname.containsString(searchBar.text)
         })
         */
        
        
        if searchBar.text?.characters.count > 0 {
            filteredData = items.filter("itemname contains[c] %@", searchBar.text!)
        } else {
            filteredData = items
        }
        self.searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    // To add cancel button to my search bar
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        filteredData = items
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
     
    
    func textfieldShouldReturn(textfield: UISearchBar) -> Bool{
        print("in the event")
        
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.characters.count == 0 {
            filteredData = items
            self.searchBar.endEditing(true)
        }
    }
    
}

