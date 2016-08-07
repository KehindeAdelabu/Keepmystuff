//
//  zoomViewController.swift
//  Keepmystuff
//
//  Created by Default on 7/25/16.
//  Copyright © 2016 LabuTech. All rights reserved.
//

import UIKit

class ZoomViewController: UIViewController, UIScrollViewDelegate {
    
    
    var scrollV : UIScrollView!
    var imageView : UIImageView!
    var image: UIImage?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBarHidden = true
        
        scrollV=UIScrollView()
        scrollV.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollV.minimumZoomScale=1
        scrollV.maximumZoomScale=3
        scrollV.bounces=false
        scrollV.delegate=self;
        self.view.addSubview(scrollV)
        
        imageView=UIImageView()
        imageView.image = image
        imageView.contentMode = .ScaleAspectFit
        imageView.frame = CGRectMake(0, 0, scrollV.frame.width, scrollV.frame.height)
        imageView.backgroundColor = .blackColor()
        //imageView.contentMode = .ScaleToFill
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ZoomViewController.handleTap(_:)))
       // tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 2
        imageView.userInteractionEnabled = true
        
        imageView.addGestureRecognizer(tapGesture)
        
        
        scrollV.addSubview(imageView)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return imageView
        
        
    }
    func handleTap(sender: UITapGestureRecognizer) {
  
        print("Taped UIImageVIew"+String( imageView.tag))
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
