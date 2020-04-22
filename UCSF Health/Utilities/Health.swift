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
    private let healthTypeObjects: Set<HKObjectType>
    private let healthTypeSamples: Set<HKSampleType>
    
    init() {
        healthStore = HKHealthStore()
        
        healthTypeObjects = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!, HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!, HKObjectType.quantityType(forIdentifier: .flightsClimbed)!])
        healthTypeSamples = Set([HKSampleType.quantityType(forIdentifier: .stepCount)!, HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!, HKObjectType.quantityType(forIdentifier: .flightsClimbed)!])
    }
    
    public func getData(_ days: Int, completion: @escaping(Result<HealthData, Error>) -> Void) {
        var steps: [Step]!
        var distances: [Distance]!
        var flights: [Flight]!
        
        let myGroup = DispatchGroup()
        
        myGroup.enter()
        getSteps(days) { response in
            switch response {
            case .success(let stepsResult):
                steps = stepsResult
                myGroup.leave()
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        myGroup.enter()
        getDistances(days) { response in
            switch response {
            case .success(let distancesResult):
                distances = distancesResult
                myGroup.leave()
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        myGroup.enter()
        getFlights(days) { response in
            switch response {
            case .success(let flightsResult):
                flights = flightsResult
                myGroup.leave()
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        myGroup.notify(queue: .main) {
            completion(.success(HealthData(steps, distances, flights)))
        }
    }
    
    private func getSteps(_ days: Int, completion: @escaping(Result<[Step], Error>) -> Void) {
        let today = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: today)!
        
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
            
            var steps: [Step] = []
            stepSamples.enumerateStatistics(from: startDate, to: today) { statistics, error in
                if let dailyStep = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let count = dailyStep.doubleValue(for: .count())
                    let step = Step(date, count)
                    
                    steps.append(step)
                }
            }
            
            completion(.success(steps))
        }
        
        healthStore.execute(stepsQuery)
    }
    
    private func getDistances(_ days: Int, completion: @escaping(Result<[Distance], Error>) -> Void) {
        let today = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: today)!
        
        var interval = DateComponents()
        interval.day = 1
        
        var anchorComponents = Calendar.current.dateComponents([.day, .month, .year], from: today)
        anchorComponents.hour = 0
        
        let anchorDate = Calendar.current.date(from: anchorComponents)!
        
        guard let distances = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else { fatalError() }
        let distancesQuery = HKStatisticsCollectionQuery(quantityType: distances, quantitySamplePredicate: nil, options: [.cumulativeSum], anchorDate: anchorDate, intervalComponents: interval)
        
        distancesQuery.initialResultsHandler = { query, results, error in
            guard let distanceSample = results else {
                completion(.failure(error!))
                return
            }
            
            var distances: [Distance] = []
            distanceSample.enumerateStatistics(from: startDate, to: today) { statistics, error in
                if let dailyDistance = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let length = dailyDistance.doubleValue(for: .mile())
                    let distance = Distance(date, length)
                    
                    distances.append(distance)
                }
            }
            
            completion(.success(distances))
        }
        
        healthStore.execute(distancesQuery)
    }
    
    private func getFlights(_ days: Int, completion: @escaping(Result<[Flight], Error>) -> Void) {
        let today = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: today)!
        
        var interval = DateComponents()
        interval.day = 1
        
        var anchorComponents = Calendar.current.dateComponents([.day, .month, .year], from: today)
        anchorComponents.hour = 0
        
        let anchorDate = Calendar.current.date(from: anchorComponents)!
        
        guard let flights = HKSampleType.quantityType(forIdentifier: .flightsClimbed) else { fatalError() }
        let flightsQuery = HKStatisticsCollectionQuery(quantityType: flights, quantitySamplePredicate: nil, options: [.cumulativeSum], anchorDate: anchorDate, intervalComponents: interval)
        
        flightsQuery.initialResultsHandler = { query, results, error in
            guard let flightSample = results else {
                completion(.failure(error!))
                return
            }
            
            var flights: [Flight] = []
            flightSample.enumerateStatistics(from: startDate, to: today) { statistics, error in
                if let dailyFlight = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let count = dailyFlight.doubleValue(for: .count())
                    let flight = Flight(date, count)
                    
                    flights.append(flight)
                }
            }
            
            completion(.success(flights))
        }
        
        healthStore.execute(flightsQuery)
    }
    
    public func getBackgroundUpdates() {
        for healthType in healthTypeSamples {
            let query = HKObserverQuery(sampleType: healthType, predicate: nil) { (query, completionHandler, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                self.getData(1) { response in
                    switch response {
                    case .success(let healthData):
                        let step = healthData.steps.last
                        let distance = healthData.distances.last
                        let flight = healthData.flights.last
                        
                        print("\(step?.value ?? 0) steps, \(distance?.value ?? 0) mi, \(flight?.value ?? 0) floors")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
                completionHandler()
            }
            
            healthStore.execute(query)
            
            healthStore.enableBackgroundDelivery(for: healthType, frequency: .immediate) { (success, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    public func requestAuthorization() {
        HKHealthStore().requestAuthorization(toShare: nil, read: healthTypeObjects) { (success, error) in
            if !success {
                print(error!)
            }
        }
    }
}
