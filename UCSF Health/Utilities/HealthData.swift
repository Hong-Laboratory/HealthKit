//
//  HealthData.swift
//  UCSF Health
//
//  Created by Shawn Patel on 3/21/20.
//  Copyright © 2020 Shawn Patel. All rights reserved.
//

import Foundation
import UIKit

struct HealthData {
    public var steps: [Step]
    public var distances: [Distance]
    public var flights: [Flight]
    
    init(_ steps: [Step], _ distances: [Distance], _ flights: [Flight]) {
        self.steps = steps
        self.distances = distances
        self.flights = flights
    }
}


protocol HealthMetric {
    var title: String { get }
    var units: String { get set }
    var icon: UIImage { get }
    var color: UIColor { get }
    
    var date: Date { get set }
    var value: Double { get set }
}

class Distance: HealthMetric {
    public var title = "Distance"
    public var units = "mi"
    public var icon = UIImage(named: "Distance")!
    public var color = UIColor(red: 185 / 255, green: 0, blue: 0, alpha: 1)
    
    var date: Date
    var value: Double
    
    init(_ date: Date, _ value: Double) {
        self.date = date
        self.value = value
    }
}

class Flight: HealthMetric {
    public var title = "Flights"
    public var units = "flts"
    public var icon = UIImage(named: "Flight")!
    public var color = UIColor(red: 0, green: 185 / 255, blue: 33 / 255, alpha: 1)
    
    var date: Date
    var value: Double
    
    init(_ date: Date, _ value: Double) {
        self.date = date
        self.value = value
    }
}

class Step: HealthMetric {
    public var title = "Steps"
    public var units = "stps"
    public var icon = UIImage(named: "Step")!
    public var color = UIColor(red: 0, green: 51 / 255, blue: 185 / 255, alpha: 1)
    
    var date: Date
    var value: Double
    
    init(_ date: Date, _ value: Double) {
        self.date = date
        self.value = value
    }
}
