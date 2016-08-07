//
//  DetailDisplayVC.swift
//  Keepmystuff
//
//  Created by Default on 7/22/16.
//  Copyright © 2016 LabuTech. All rights reserved.
//

import UIKit
import RealmSwift
class DetailDisplayVC: UIViewController {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemLocation: UILabel!
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var item:Item?
    
    
    
    @IBAction func editDetails(sender: AnyObject) {
        print("edit")
    }
    
    override func viewDidLoad() {
        if let item = item {
//            print(item.itemname)
            itemName.text = item.itemname
            itemLocation.text = item.itemlocation
            itemDescription.text = item.itemdescription
            timeLabel.text = item.modificationTime.convertToString()
            itemImage.image = UIImage(data: item.imageData)
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DetailDisplayVC.handleTap(_:)))
            tapGesture.numberOfTouchesRequired = 1
            tapGesture.numberOfTapsRequired = 1
            itemImage.userInteractionEnabled = true
            
            itemImage.addGestureRecognizer(tapGesture)
            
            //self.view.addSubview(imageView1)
            
        }
        
        
    }
    
    
    func handleTap(sender: UITapGestureRecognizer) {
        let imageView : UIImageView = sender.view as! UIImageView
        //let image : UIImage = imageView.image!
//        print("Taped UIImageVIew"+String( imageView.tag))
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("ZoomViewController") as? ZoomViewController
        controller?.image = imageView.image
        self.presentViewController(controller!, animated: true, completion: nil)
        
  
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as? ViewController
        controller?.item = item
      
       
    }
    
    
}