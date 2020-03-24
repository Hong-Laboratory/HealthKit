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
    var date: Date { get set }
}

class HealthCount: HealthMetric {
    public var date: Date
    public var count: Double
    
    init(_ date: Date, _ count: Double) {
        self.date = date
        self.count = count
    }
}

class Distance: HealthMetric {
    let title = "Distance"
    let icon = UIImage(named: "Distance")!
    let color = UIColor(red: 185 / 255, green: 0, blue: 0, alpha: 1)
    
    public var date: Date
    public var length: Double
    
    init(_ date: Date, _ length: Double) {
        self.date = date
        self.length = length
    }
}

class Flight: HealthCount {
    let title = "Flights"
    let icon = UIImage(named: "Flight")!
    let color = UIColor(red: 0, green: 185 / 255, blue: 33 / 255, alpha: 1)
    
    override init(_ date: Date, _ count: Double) {
        super.init(date, count)
    }
}

class Step: HealthCount {
    let title = "Steps"
    let icon = UIImage(named: "Step")!
    let color = UIColor(red: 0, green: 51 / 255, blue: 185 / 255, alpha: 1)
    
    override init(_ date: Date, _ count: Double) {
        super.init(date, count)
    }
}
