//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Ashakiran Thatavarthi on 24/03/23.
//

import XCTest
@testable import WeatherApp

final class WeatherAppTests: XCTestCase {
    
    var weatherViewModel: WeatherViewModel?

    override func setUp() {
        super.setUp()
        
        self.weatherViewModel = WeatherViewModel(service: MockAPIServices())
    }

    override func tearDown() {
        super.tearDown()
        
        self.weatherViewModel = nil
    }
    
    func testForecastModel() {
        self.weatherViewModel?.hourlyForecast(lat: 0.0, lng: 0.0, completionHandler: { status, _ in
            if status {
                if let forecastData = self.weatherViewModel?.getForecastData() {
                    XCTAssertTrue((forecastData.list?.first?.main?.temp as? Double) != nil)
                    XCTAssertTrue((forecastData.list?.first?.main?.pressure as? Int) != nil)
                    XCTAssertTrue((forecastData.list?.first?.main?.humidity as? Int) != nil)
                }
            }
        })
    }
    
    func testWeatherModel() {
        self.weatherViewModel?.fetchWeatherData(city: "WeatherModel", completionHandler: { status, _ in
            if status {
                if let weather = self.weatherViewModel?.getWeather() {
                    XCTAssertTrue((weather.first?.country as? String) != nil)
                    XCTAssertTrue((weather.first?.name as? String) != nil)
                    XCTAssertTrue((weather.first?.lat as? Double) != nil)
                    XCTAssertTrue((weather.first?.lon as? Double) != nil)
                }
            }
        })
    }
    
    func testWeatherDataModel() {
        self.weatherViewModel?.fetchWeatherData(lat: 0.0, lng: 0.0, completionHandler: { status, _ in
            if let weatherData = self.weatherViewModel?.getWeatherData() {
                XCTAssertTrue((weatherData.main?.temp as? Double) != nil)
                XCTAssertTrue((weatherData.main?.pressure as? Int) != nil)
                XCTAssertTrue((weatherData.main?.humidity as? Int) != nil)
            }
        })
    }
}
