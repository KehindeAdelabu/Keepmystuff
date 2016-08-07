//
//  about.swift
//  Keepmystuff
//
//  Created by Default on 8/1/16.
//  Copyright © 2016 LabuTech. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController:UIViewController{
    
    @IBOutlet weak var aboutTextView: UITextView!
    
    override func viewDidLoad() {
        aboutTextView.editable = false
        aboutTextView.selectable = false
    }


}

