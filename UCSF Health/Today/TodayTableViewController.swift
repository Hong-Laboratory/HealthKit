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
    
    var healthData: HealthData!
    
    var availableHealthData: [HealthMetric]!

    override func viewDidLoad() {
        super.viewDidLoad()

        getHealthData()
        setupTableView()
    }
    
    func getHealthData() {
        HealthData.health.getData(days: 1) { response in
            switch response {
            case .success(let healthData):
                self.healthData = healthData
                self.parseHealthData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupTableView() {
        tableView.allowsSelection = false
    }
    
    func parseHealthData() {
        availableHealthData = []
        
        if let distance = healthData.distances.first {
            availableHealthData.append(distance)
        }
        
        if let flight = healthData.flights.first {
            availableHealthData.append(flight)
        }
        
        if let step = healthData.steps.first {
            availableHealthData.append(step)
        }
        
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableHealthData != nil ? availableHealthData.count : 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayHealthData", for: indexPath) as! TodayTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateString = dateFormatter.string(from: Date()).lowercased()
        
        cell.background.layer.cornerRadius = 15
        
        let metric = availableHealthData[indexPath.row]
        
        cell.icon.image = metric.icon
        cell.title.text = metric.title
        cell.background.backgroundColor = metric.color
        cell.details.text = "\(dateString) – \(metric.value.rounded(toPlaces: 1)) \(metric.units)"

        return cell
    }
}
