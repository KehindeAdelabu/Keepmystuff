//
//  ViewController.swift
//  keep my Stuff
//
//  Created by Default on 7/14/16.
//  Copyright © 2016 LabuTech. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var imageView :UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func captureImage(){
        var imageFromSource = UIImagePickerController()
        imageFromSource.delegate = self
        imageFromSource.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            imageFromSource.sourceType = UIImagePickerControllerSourceType.Camera
            
        }
        else{
            imageFromSource.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController(imageFromSource, animated: true, completion:nil)
        
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithImage Image: NSDictionary!){
        var temp : UIImage = Image[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = temp
        self.dismissViewControllerAnimated(true, completion: {})
    }
}

