//
//  PhotoTakingHelper.swift
//  Keepmystuff
//
//  Created by Default on 7/24/16.
//  Copyright © 2016 LabuTech. All rights reserved.
//

import UIKit

class PhotoTakingHelper: UIViewController {
    
    @IBOutlet var imageView :UIImageView!
    var imagePicker: UIImagePickerController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func captureImage(){
        //        print("capture image called")
        imagePicker = UIImagePickerController()
        //        print("created image picker controller")
        
        imagePicker!.delegate = self
        imagePicker!.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            imagePicker!.sourceType = UIImagePickerControllerSourceType.Camera
            
        }
        else{
            imagePicker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        //        print("configured image picker controller")
        
        self.presentViewController(imagePicker!, animated: true, completion: nil) // {
        //            print("done showing image picker controller")
        //        }
         imageView.contentMode = .ScaleAspectFit
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        if segue.identifier == "enterDetails" {
            let controller = segue.destinationViewController as? ViewController
            controller?.image = imageView.image
        }
    }

}

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image = image
        self.dismissViewControllerAnimated(true, completion: {})
    }
}