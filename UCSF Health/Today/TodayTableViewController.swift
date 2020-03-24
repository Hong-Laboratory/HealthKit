//
//  TodayTableViewController.swift
//  UCSF Health
//
//  Created by Shawn Patel on 3/23/20.
//  Copyright © 2020 Shawn Patel. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var details: UILabel!
}

class TodayTableViewController: UITableViewController {
    
    var health: Health!
    var healthData: HealthData!

    override func viewDidLoad() {
        super.viewDidLoad()

        health = Health()
        getHealthData()
        setupTableView()
    }
    
    func getHealthData() {
        health.getData(days: 1) { response in
            switch response {
            case .success(let healthData):
                self.healthData = healthData
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupTableView() {
        tableView.allowsSelection = false
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return healthData != nil ? 3 : 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayHealthData", for: indexPath) as! TodayTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm a"
        
        cell.background.layer.cornerRadius = 10

        switch indexPath.row {
        case 0:
            // Distance
            if let distance = healthData.distances.first {
                cell.icon.image = distance.icon
                cell.title.text = distance.title
                cell.background.backgroundColor = distance.color
                cell.details.text = "\(dateFormatter.string(from: distance.date).lowercased()) – \(distance.length.rounded(toPlaces: 1)) mi"
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        case 1:
            // Flights
            if let flight = healthData.flights.first {
                cell.icon.image = flight.icon
                cell.title.text = flight.title
                cell.background.backgroundColor = flight.color
                cell.details.text = "\(dateFormatter.string(from: flight.date).lowercased()) – \(Int(flight.count))"
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        case 2:
            // Steps
            if let step = healthData.steps.first {
                cell.icon.image = step.icon
                cell.title.text = step.title
                cell.background.backgroundColor = step.color
                cell.details.text = "\(dateFormatter.string(from: step.date).lowercased()) – \(Int(step.count))"
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        default:
            break
        }

        return cell
    }
}
