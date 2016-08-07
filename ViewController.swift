//
//  ViewController.swift
//  keep my Stuff
//
//  Created by Default on 7/14/16.
//  Copyright © 2016 LabuTech. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
  
    @IBOutlet weak var itemName: UITextField!
    
    @IBOutlet weak var itemLocation: UITextField!
    
    @IBOutlet weak var itemDescription: UITextView!
   
    
    var image: UIImage?
    var item: Item?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        if let image = image {
            print(image)
            
        }
        
        if let item = item {
            itemName.text = item.itemname
            itemLocation.text = item.itemlocation
            itemDescription.text = item.itemdescription
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.KeyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.KeyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addItem(){
        
        let mike = populateItem()
        
        RealmHelper.addItem(mike)
        
        /*
        let realm = try! Realm()
        try! realm.write(){
            realm.add(mike)
            print("Added \(mike.itemname)")
        }
         */
    }
    
    func updateItem(item: Item) {
        let newItem = populateItem()
        newItem.imageData = item.imageData
        RealmHelper.update(item, newItem: newItem)
    }
    
    func populateItem() -> Item {
        let mike = Item()
        mike.itemname = itemName.text!
        mike.itemlocation = itemLocation.text!
        mike.itemdescription = itemDescription.text!
        if let image = image {
            mike.imageData = UIImageJPEGRepresentation(image, 1.5)!
        }
        
        return mike
    }
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveItem" {
            
            if let item = item {
                updateItem(item)
            } else {
                addItem()
            }
  
        }
    }
    
    func KeyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 170
            }
        }
    }
    
    func KeyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height - 170
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
                NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}



