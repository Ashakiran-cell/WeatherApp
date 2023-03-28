//
//  ForecastViewCell.swift
//  WeatherApp
//
//  Created by Ashakiran Thatavarthi on 25/03/23.
//

import UIKit

class ForecastViewCell: UITableViewCell {

    @IBOutlet weak var iconRef: UIImageView!
    @IBOutlet weak var degreesLbl: UILabel!
    @IBOutlet weak var weatherLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(data: List?) {
        if let time = data?.dtTxt {
            self.dateLbl.text = time
        }
        if let icon = data?.weather?.first?.icon {
            guard let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else { return }
            self.iconRef.sd_setImage(with: url) { img, err, cache, url in }
        }
        if let weather = data?.weather?.first?.description {
            self.weatherLbl.text = weather
        }
        if let temp = data?.main?.temp {
            self.degreesLbl.text = String(format: "%.0f", temp - 273.15) + "°C"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
