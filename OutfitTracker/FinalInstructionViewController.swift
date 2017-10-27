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
        print("check")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
