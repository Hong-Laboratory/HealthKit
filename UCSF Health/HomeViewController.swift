//
//  HomeViewController.swift
//  UCSF Health
//
//  Created by Shawn Patel on 3/9/20.
//  Copyright © 2020 Shawn Patel. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var health: Health!
    
    var steps: [Date : Double]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        health = Health()
        
        health.getSteps { response in
            switch response {
            case .success(let steps):
                self.steps = steps
            case .failure(let error):
                print(error)
            }
        }
    }
}

