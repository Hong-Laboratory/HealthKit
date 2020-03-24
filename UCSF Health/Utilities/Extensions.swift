//
//  Extensions.swift
//  UCSF Health
//
//  Created by Shawn Patel on 3/23/20.
//  Copyright © 2020 Shawn Patel. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
