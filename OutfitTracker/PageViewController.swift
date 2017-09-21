//
//  PageViewController.swift
//  OutfitTracker
//
//  Created by Pete Connor on 9/17/17.
//  Copyright © 2017 c0nman. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let firstVC = pageArray.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController(name: "1"),
                self.newColoredViewController(name: "2"),
                self.newColoredViewController(name: "3"),
                self.newColoredViewController("4"),
                self.newColoredViewController("5")
        ]
    }()
    
    private func newColoredViewController(color: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("\(color)ViewController")
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
