//
//  Extensions.swift
//  WeatherApp
//
//  Created by Ashakiran Thatavarthi on 24/03/23.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: - Show Loader
    func showLoader() {
        DispatchQueue.main.async {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            view.tag = 101
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .white
            activityIndicator.center = view.center
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
            
            view.addSubview(activityIndicator)
            
            SceneDelegate.sharedSceneDelegate()?.window?.addSubview(view)
        }
    }
    
    // MARK: - Hide Loader
    func hideLoader() {
        DispatchQueue.main.async {
            SceneDelegate.sharedSceneDelegate()?.window?.viewWithTag(101)?.removeFromSuperview()
        }
    }
    
    // MARK: - Alert
    func showAlert(title: String?, message: String?, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { okBtnAction in
                completion?()
            }))
            self.present(alert, animated: true)
        }
    }
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension Double {
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
