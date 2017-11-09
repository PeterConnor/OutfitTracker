//
//  FinalInstructionViewController.swift
//  OutfitTracker
//
//  Created by Pete Connor on 10/8/17.
//  Copyright © 2017 c0nman. All rights reserved.
//

import UIKit

class FinalInstructionViewController: UIViewController {
    
  
    @IBAction func doneButton(_ sender: Any) {
        navigationController!.popToViewController(navigationController!.viewControllers[0] as
        UIViewController, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
