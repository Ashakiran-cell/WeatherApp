//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Ashakiran Thatavarthi on 24/03/23.
//

import UIKit
import MapKit
import SDWebImage

class WeatherViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    
    var weatherViewModel = WeatherViewModel()
    
    @IBOutlet weak var dewPointLbl: UILabel!
    @IBOutlet weak var visibilityLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var weatherDescLbl: UILabel!
    @IBOutlet weak var degreesLbl: UILabel!
    @IBOutlet weak var weatherIconRef: UIImageView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var weatherDataViewRef: UIView!
    @IBOutlet weak var tableViewRef: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        // As per the requirement fetching API with the last city upon App launch.
        if let lastCity = Defaults.lastCity {
            self.fetchWeatherData(city: lastCity)
        }
    }
    
    func setupUI() {
        // MARK: - SearchController
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "search city here"
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        
        // MARK: - Location
        self.locationManager = CLLocationManager()
        // Ask for Authorization from the User.
        self.locationManager?.requestWhenInUseAuthorization()
        DispatchQueue.global().async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                switch self?.locationManager?.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    print("permission granted")
                case .restricted, .denied:
                    self?.showAlert(title: "Alert", message: "please enable location permissions")
                default:
                    print("permission not granted")
                }
                self?.locationManager?.delegate = self
                self?.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                self?.locationManager?.startUpdatingLocation()
            }
        }
        
        self.weatherDataViewRef.roundCorners([.allCorners], radius: 20)
        
        self.tableViewRef.register(UINib(nibName: "ForecastViewCell", bundle: nil), forCellReuseIdentifier: "ForecastViewCell")
        self.tableViewRef.showsVerticalScrollIndicator = false
    }
    
    func fetchWeatherData(city: String) {
        self.showLoader()
        self.weatherViewModel.fetchWeatherData(city: city) { status, error in
            self.hideLoader()
            if status {
                DispatchQueue.main.async { [weak self] in
                    self?.configureUI()
                    self?.tableViewRef.reloadData()
                }
            }else{
                self.showAlert(title: "Alert", message: error)
            }
        }
    }
    
    func configureUI() {
        // MARK: - Weather View
        if let data = self.weatherViewModel.getWeatherData() {
            if let dateValue = data.dt, let timeZone = data.timezone {
                let date = Date(timeIntervalSince1970: TimeInterval(dateValue))
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(secondsFromGMT: timeZone)
                dateFormatter.dateFormat = "MMM d, h:mm a"
                self.dateTimeLbl.text = dateFormatter.string(from: date)
            }
            if let city = data.name, let country = data.sys?.country {
                self.locationLbl.text = city + ", " + country
            }
            if let icon = data.weather?.first?.icon {
                guard let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else { return }
                self.weatherIconRef.sd_setImage(with: url) { img, err, cache, url in }
            }
            if let temp = data.main?.temp {
                self.degreesLbl.text = String(format: "%.0f", temp - 273.15) + "°C"
            }
            if let feelsLike = data.main?.feelsLike, let weather = data.weather?.first?.description {
                self.weatherDescLbl.text = "Feels Like \(String(format: "%.0f", feelsLike - 273.15) + "°C"). \(weather). Fresh Breeze"
            }
            if let speed = data.wind?.speed, let pressure = data.main?.pressure, let humidity = data.main?.humidity {
                self.speedLbl.text = "\(Double(speed).rounded(toPlaces: 1))" + "m/s WSW"
                self.pressureLbl.text = "\(pressure)" + "hPa"
                self.humidityLbl.text = "Humidity : \(humidity)%"
            }
            if let visibility = data.visibility {
                self.visibilityLbl.text = "Visibility : " + "\(Double(visibility).rounded(toPlaces: 2) / 1000)" + "km"
            }
            
            self.dewPointLbl.text = "Dew Point : 6°C"
        }
    }
}

extension WeatherViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        guard let text = searchBar.text else { return }
        self.fetchWeatherData(city: text)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                if let placemark = placemarks?.first {
                    guard let city = placemark.locality else { return }
                    self?.locationManager?.stopUpdatingLocation()
                    self?.locationManager?.delegate = nil
                    
                    self?.fetchWeatherData(city: city)
                }
            }
        }
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherViewModel.getForecastData()?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableViewRef.dequeueReusableCell(withIdentifier: "ForecastViewCell") as? ForecastViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(data: self.weatherViewModel.getForecastData()?.list?[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
