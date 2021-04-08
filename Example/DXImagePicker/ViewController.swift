//
//  ViewController.swift
//  DXImagePicker
//
//  Created by Eric on 04/08/2021.
//  Copyright (c) 2021 Eric. All rights reserved.
//

import UIKit
import DXImagePicker

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapButton(_ sender: Any) {
        showImagePicker(sourceType: .photoLibrary) { [unowned self] (image) in
            self.imageView.image = image
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

