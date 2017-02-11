//
//  AboutViewController.swift
//  Daimler
//
//  Created by Suresh on 26/07/16.
//  Copyright © 2016 benz. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController
{

    @IBOutlet weak var aboutLabel: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.aboutLabel.text = "MIT - Mobile Incident Tracker\nVersion - " + self.applicationVersion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func applicationVersion() -> String
    {
        if let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
        {
            return version
        }
        
        return ""
    }

}
