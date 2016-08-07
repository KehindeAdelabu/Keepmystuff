//
//  DisplayItemViewController.swift
//  MakeSchoolItem
//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift
class DisplayItemViewController: UIViewController {
    var item: Item?
    
    @IBOutlet weak var itemContentTextView: UITextView!
    @IBOutlet weak var itemTitleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let listItemTableViewController = segue.destinationViewController as! ListItemTableViewController
        if segue.identifier == "Save" {
            if let item = item {
                let newItem = Item()
                newItem.title = itemTitleTextField.text ?? ""
                newItem.content = itemContentTextView.text ?? ""
                RealmHelper.updateItem(item, newItem: newItem)
                
            } else {
                // 3
                let item = Item()
                item.title = itemTitleTextField.text ?? ""
                item.content = itemContentTextView.text ?? ""
                //item.modificationTime = NSDate()
                // 2
                RealmHelper.addItem(item)
            }
            listItemTableViewController.item = RealmHelper.retrieveItem()
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 1
        if let item = item {
            // 2
            itemTitleTextField.text = item.title
            itemContentTextView.text = item.content
        } else {
            // 3
            // 1
            itemTitleTextField.text = ""
            itemContentTextView.text = ""
        }
        
    }
}
