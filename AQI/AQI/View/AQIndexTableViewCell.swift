//
//  AQIndexTableViewCell.swift
//  AQI
//
//  Created by RajeshKumar G A on 05/02/22.
//

import Foundation
import UIKit

class AQIndexTableViewCell: UITableViewCell {
    var cityNameLabel = UILabel()
    var aqiValueLabel = UILabel()
    var updatedLabel = UILabel()
    var bgView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    func configureCell(data: AirQualityElement) {
        setupUI()
        aqiValueLabel.text = "AQI:" + String(format: "%.2f", data.aqi)
        let date = Date(timeIntervalSince1970: (Double(Date().currentTimeMillis()) / 1000.0))
        let airQuality = AirQualityGrade.getAirQualityFor(aqi: data.aqi)
        cityNameLabel.text = data.city + ": \(airQuality.getAirQualityLevel())"
        cityNameLabel.numberOfLines = 0
        updatedLabel.text = "Updated \(Date().timeAgoSince(date))"
        bgView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        bgView.backgroundColor = airQuality.getLabelColor()
        self.backgroundColor = #colorLiteral(red: 0.09373370558, green: 0.6062930226, blue: 0.5646792054, alpha: 1)
        aqiValueLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cityNameLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        updatedLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func setupUI() {
        
        cityNameLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
        aqiValueLabel.font = UIFont(name:"Helvetica Neue", size: 14.0)
        updatedLabel.font = UIFont(name:"Helvetica Neue", size: 14.0)
        bgView.layer.borderWidth = 2
        bgView.layer.cornerRadius = 8
        bgView.frame.size.height = 200
        updatedLabel.textAlignment = .right
        contentView.backgroundColor = .clear
        
        self.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        aqiValueLabel.translatesAutoresizingMaskIntoConstraints = false
        updatedLabel.translatesAutoresizingMaskIntoConstraints = false
        bgView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(bgView)
        bgView.addSubview(cityNameLabel)
        bgView.addSubview(aqiValueLabel)
        bgView.addSubview(updatedLabel)
        
        let views: [String: Any] = [
            "cityName": cityNameLabel,
            "valueLbl": aqiValueLabel,
            "qualityValue": updatedLabel,
            "bgView": bgView]
        
        var constraints: [NSLayoutConstraint] = []
        
        
        let nameLabelVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[cityName]-(>=5)-[valueLbl]-5-|",
            metrics: nil,
            views: views)
        constraints += nameLabelVerticalConstraints
        
        let countryLabelVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[cityName]-(>=5)-[qualityValue]-5-|",
            metrics: nil,
            views: views)
        constraints += countryLabelVerticalConstraint
        
        let topRowHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[cityName]-10-|",
            metrics: nil,
            views: views)
        constraints += topRowHorizontalConstraints
        
        let bottomRowHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[valueLbl]-10-[qualityValue]-10-|",
            metrics: nil,
            views: views)
        constraints += bottomRowHorizontalConstraints
        
        let bgViewVerticalConstraint = NSLayoutConstraint.constraints(
        withVisualFormat: "V:|-10-[bgView]-10-|",
        metrics: nil,
        views: views)
        constraints += bgViewVerticalConstraint
        
        let bgViewHorizontalConstraint = NSLayoutConstraint.constraints(
        withVisualFormat: "H:|-10-[bgView]-10-|",
        metrics: nil,
        views: views)
        constraints += bgViewHorizontalConstraint
        
        NSLayoutConstraint.activate(constraints)
        
        aqiValueLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for:.horizontal)
        updatedLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for:.horizontal)
        
        updatedLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal);
    }

}


enum AirQualityGrade {
    case good, satisfactory, moderate, poor, veryPoor, severe
    
    static func getAirQualityFor(aqi : Double) -> AirQualityGrade {
        if aqi < 51 {
            return .good
        }
        else if aqi < 101 {
            return .satisfactory
        }
        else if aqi < 201 {
            return .moderate
        }
        else if aqi < 301 {
            return .poor
        }
        else if aqi < 401 {
            return .veryPoor
        }
        else {
            return .severe
        }
    }
    
    func getLabelColor() -> UIColor {
        switch self {
        case .good:
            return #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        case .satisfactory:
            return #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
        case .moderate:
            return #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
        case .poor:
            return #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        case .veryPoor:
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .severe:
            return #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }
    
    func getAirQualityLevel() -> String {
        switch self {
        case .good:
            return "Good"
        case .satisfactory:
            return "Satisfactory"
        case .moderate:
            return "Moderate"
        case .poor:
            return "Poor"
        case .veryPoor:
            return "Very Poor"
        case .severe:
            return "Severe"
        }
    }
}

