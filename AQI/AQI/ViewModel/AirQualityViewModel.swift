//
//  AirQualityViewModel.swift
//  AQI
//
//  Created by RajeshKumar G A on 05/02/22.
//

import UIKit

typealias AQICallback = () -> ()

protocol AirQualityDelegate {
    func updateAQIForCity(aqi : Double)
}

class AirQualityViewModel {
    
    var airQualityData = AirQuality()
    var aqiCallback : AQICallback?
    var aqiDelegate : AirQualityDelegate?
    var selectedCity = ""
    
    func startAQIEvents() {
        SocketManager.shared.connect()
        SocketManager.delegate = self
    }
}

extension AirQualityViewModel: AQDelegate {
    
    func didUpdateData(serverData: AirQuality) {
        //TODO : Add .barrier to avoid race condition(UI refresh while changing the data)
        var tempDict = [String: AirQualityElement]()
        for obj in airQualityData {
            tempDict[obj.city] = obj
        }
        
        for obj in serverData {
            tempDict[obj.city] = obj
            
            if obj.city == selectedCity {
                self.aqiDelegate?.updateAQIForCity(aqi: obj.aqi)
            }
        }
        
        airQualityData = Array(tempDict.values)
        airQualityData = airQualityData.sorted { $0.city < $1.city }
        
        DispatchQueue.main.async {
            //Comment this callback to see if connection test case fails
            self.aqiCallback?()
        }
    }
}
