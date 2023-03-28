//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Ashakiran Thatavarthi on 24/03/23.
//

import Foundation

class WeatherViewModel {
    
    private var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    private var data: WeatherDataModel?
    private var forecastData: ForecastModel?
    private var weather: [WeatherModel]?
    
    private let service: NetworkProtocol?
    
    init(service: NetworkProtocol? = APIServices()) {
        self.service = service
    }
    
    func fetchWeatherData(city: String, completionHandler: @escaping (Bool, String) -> Void) {
        var url: String = ""
        if isRunningTests {
            url = city
        }else{
            let cityName = city.replacingOccurrences(of: " ", with: "%20")
            url = AppURL.geoURL + "\(cityName)&appid=\(AppConstants.appID)"
        }
        self.service?.request(urlString: url, model: [WeatherModel].self, completionHandler: { response in
            switch response {
            case .success(let data):
                self.weather = data
                guard let lat = data.first?.lat else { return }
                guard let lng = data.first?.lon else { return }
                self.fetchWeatherData(lat: lat, lng: lng) { status, error in
                    Defaults.lastCity = city
                    completionHandler(status, error)
                }
            case .failure(let error):
                completionHandler(false, error.localizedDescription)
            }
        })
    }
    
    func fetchWeatherData(lat: Double, lng: Double, completionHandler: @escaping (Bool, String) -> Void) {
        var url: String = ""
        if isRunningTests {
            url = "WeatherDataModel"
        }else{
            url = AppURL.weatherURL + "lat=\(lat)&lon=\(lng)&appid=\(AppConstants.appID)"
        }
        self.service?.request(urlString: url, model: WeatherDataModel.self, completionHandler: { response in
            switch response {
            case .success(let data):
                self.data = data
                guard let lattitude = self.data?.coord?.lat else { return }
                guard let longitude = self.data?.coord?.lon else { return }
                self.hourlyForecast(lat: lattitude, lng: longitude) { status, error in
                    completionHandler(status, error)
                }
            case .failure(let error):
                completionHandler(false, error.localizedDescription)
            }
        })
    }
    
    func hourlyForecast(lat: Double, lng: Double, completionHandler: @escaping (Bool, String) -> Void) {
        var url: String = ""
        if isRunningTests {
            url = "ForecastModel"
        }else{
            url = AppURL.forecastURL + "lat=\(lat)&lon=\(lng)&cnt=15&exclude=daily,hourly&appid=\(AppConstants.appID)"
        }
        self.service?.request(urlString: url, model: ForecastModel.self, completionHandler: { response in
            switch response {
            case .success(let data):
                self.forecastData = data
                completionHandler(true, "")
            case .failure(let error):
                completionHandler(false, error.localizedDescription)
            }
        })
    }
    
    func getWeatherData() -> WeatherDataModel? {
        return data
    }
    
    func getForecastData() -> ForecastModel? {
        return forecastData
    }
    
    func getWeather() -> [WeatherModel]? {
        return weather
    }
}
