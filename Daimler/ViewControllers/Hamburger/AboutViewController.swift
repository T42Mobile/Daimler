//
//  AboutViewController.swift
//  Daimler
//
//  Created by Suresh on 26/07/16.
//  Copyright © 2016 benz. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
