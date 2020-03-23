//
//  HealthData.swift
//  UCSF Health
//
//  Created by Shawn Patel on 3/21/20.
//  Copyright © 2020 Shawn Patel. All rights reserved.
//

import Foundation

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

class Step: HealthCount {
    override init(_ date: Date, _ count: Double) {
        super.init(date, count)
    }
}

class Distance: HealthMetric {
    public var date: Date
    public var length: Double
    
    init(_ date: Date, _ length: Double) {
        self.date = date
        self.length = length
    }
}

class Flight: HealthCount {
    override init(_ date: Date, _ count: Double) {
        super.init(date, count)
    }
}
