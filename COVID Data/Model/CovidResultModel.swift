//
//  CovidResultModel.swift
//  COVID Data
//
//  Created by David Kababyan on 10/04/2020.
//  Copyright © 2020 David Kababyan. All rights reserved.
//

import Foundation

struct TotalData {
    
    let confirmed: Int
    let deaths: Int
    let critical: Int
    let recovered: Int
    
    var fatalityRate: Double {
        return (100.00 * Double(deaths)) / Double(confirmed)
    }
    
    var recoveredRate: Double {
        return (100.00 * Double(recovered)) / Double(confirmed)
    }
}
//
//struct CountryData {
//    
//    let country: String
//    let longitude: Double
//    let latitude: Double
//    let confirmed: Int
//    let deaths: Int
//    let critical: Int
//    let recovered: Int
//    
//    var fatalityRate: Double {
//        return (100.00 * Double(deaths)) / Double(confirmed)
//    }
//    
//    var recoveredRate: Double {
//        return (100.00 * Double(recovered)) / Double(confirmed)
//    }
//}
