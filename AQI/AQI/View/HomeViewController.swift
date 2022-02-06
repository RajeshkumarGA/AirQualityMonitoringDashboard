//
//  HomeViewController.swift
//  AQI
//
//  Created by RajeshKumar G A on 05/02/22.
//

import UIKit

import UIKit
class HomeViewController: UIViewController {
   
 
    @IBOutlet weak var airQualityTableView: UITableView!
    private let airQualityViewModel = AirQualityViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        airQualityViewModel.startAQIEvents()
        airQualityViewModel.aqiCallback = { [weak self] in
            self?.airQualityTableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        setupUI()
    }
    
    private func setupUI() {

        title = Constants.homeVC
        airQualityTableView.register(AQIndexTableViewCell.self, forCellReuseIdentifier: "AQTableViewCell")
        airQualityTableView.dataSource = self
        airQualityTableView.delegate = self
        airQualityTableView.separatorColor = .clear
        airQualityTableView.backgroundColor = #colorLiteral(red: 0.09373370558, green: 0.6062930226, blue: 0.5646792054, alpha: 1)
        self.view.backgroundColor = .white
        self.view.addSubview(airQualityTableView)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(airQualityViewModel.airQualityData[indexPath.row])")
        
        let vc = AQIChartViewController()
        let viewModel = AQIChartViewModel()
        vc.viewModel = viewModel
        airQualityViewModel.aqiDelegate = viewModel
        airQualityViewModel.selectedCity = airQualityViewModel.airQualityData[indexPath.row].city
        viewModel.city = airQualityViewModel.selectedCity
        self.navigationController?.pushViewController(vc, animated: false)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airQualityViewModel.airQualityData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AQTableViewCell", for: indexPath as IndexPath) as? AQIndexTableViewCell, airQualityViewModel.airQualityData.count > indexPath.row {
            cell.configureCell(data: airQualityViewModel.airQualityData[indexPath.row])
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
