//
//  AQIChartViewController.swift
//  AQI
//
//  Created by RajeshKumar G A on 05/02/22.
//

import Foundation
import UIKit
import Charts

class AQIChartViewController : UIViewController {
    
    var viewModel = AQIChartViewModel()
    var lineChart = LineChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.updateChartCallabck = { [weak self] in
            self?.lineChartUpdate()
        }
    }
    
    override func viewDidLayoutSubviews() {
        setupUI()
        lineChartUpdate()
    }
    
    private func setupUI() {
        let barHeight: CGFloat = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        title = viewModel.city
        self.view.addSubview(lineChart)
        lineChart.frame = CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight)
        lineChart.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    }
        
    @objc func lineChartUpdate() {
        let dataSet = LineChartDataSet(entries: viewModel.arrAQI)
        let data = LineChartData(dataSets: [dataSet])
        lineChart.data = data
        lineChart.chartDescription.text = Constants.chartLabel
        lineChart.notifyDataSetChanged()
    }
}
