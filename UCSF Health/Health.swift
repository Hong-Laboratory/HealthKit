//
//  Health.swift
//  UCSF Health
//
//  Created by Shawn Patel on 3/9/20.
//  Copyright © 2020 Shawn Patel. All rights reserved.
//

import Foundation
import HealthKit

class Health {
    
    private let healthStore: HKHealthStore
    
    init() {
        healthStore = HKHealthStore()
        
        requestAuthorization()
    }
    
    public func getSteps(completion: @escaping(Result<[Date : Double], Error>) -> Void) {
        let today = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: today)!
        
        var interval = DateComponents()
        interval.day = 1

        var anchorComponents = Calendar.current.dateComponents([.day, .month, .year], from: today)
        anchorComponents.hour = 0
        
        let anchorDate = Calendar.current.date(from: anchorComponents)!
        
        guard let steps = HKSampleType.quantityType(forIdentifier: .stepCount) else { fatalError() }
        let stepsQuery = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil, options: [.cumulativeSum], anchorDate: anchorDate, intervalComponents: interval)
        
        stepsQuery.initialResultsHandler = { query, results, error in
            guard let stepSamples = results else {
                completion(.failure(error!))
                return
            }
            
            var stepsCollection: [Date : Double] = [:]
            stepSamples.enumerateStatistics(from: startDate, to: today) { statistics, error in
                if let dailySteps = statistics.sumQuantity() {
                    let steps = dailySteps.doubleValue(for: .count())
                    stepsCollection[statistics.startDate] = steps
                }
            }
            
            completion(.success(stepsCollection))
        }
        
        healthStore.execute(stepsQuery)
    }
    
    private func requestAuthorization() {
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!, HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!, HKObjectType.quantityType(forIdentifier: .flightsClimbed)!])

        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if !success {
                print(error!)
            }
        }
    }
}
