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
    var healthData: HealthData!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        health = Health()
        
        health.getData { response in
            switch response {
            case .success(let healthData):
                self.healthData = healthData
                self.visualizeDate()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func visualizeDate() {
        print("Steps")
        for step in healthData.steps {
            print("\(step.date) ----- \(step.count)")
        }
        
        print("\nDistances")
        for distance in healthData.distances {
            print("\(distance.date) ----- \(distance.length)")
        }
        
        print("\nFlights")
        for flight in healthData.flights {
            print("\(flight.date) ----- \(flight.count)")
        }
    }
}

