//
//  HelpViewController.swift
//  Daimler
//
//  Created by Suresh on 15/07/16.
//  Copyright © 2016 benz. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController
{
    @IBOutlet var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.textView.setContentOffset(CGPointZero, animated: false)
    }
    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
