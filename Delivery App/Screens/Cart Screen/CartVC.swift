//
//  CartVC.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 30.06.2023.
//

import UIKit
import CoreLocation

class CartVC: UIViewController {
    
    let dateFormatter = DateFormatter()
    let locationManager = CLLocationManager()
    var location = String()

    var cartView: CartView { return self.view as! CartView}
    
    

    override func loadView() {
        self.view = CartView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        setupLocationManager()
        
        cartView.cartTable.fullPriceIsChanged = {
            self.calculateFullPrice()
        }
        
        cartView.cartTable.onPriceIsChange = {
            self.calculateFullPrice()
        }
    }
    
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")

        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    
    func passProductListToTable() {
        calculateFullPrice()
        cartView.cartTable.loadProductList(location, getCurrentDate())
        cartView.cartTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculateFullPrice()
        cartView.cartTable.configure()
        cartView.cartTable.reloadData()

    }
    
    func calculateFullPrice() {
        let archiver = CartProductsArchieverService(key: "test5")
        var price = 0
        
        let arr = archiver.retrieve()
        
        for (key, value) in arr {
            price += key.price * value
            print(key.price, value, price)
        }
        
        cartView.fullPrice = price
        cartView.updatePayButtonTitle()
    }

    
}

extension CartVC: CLLocationManagerDelegate {

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first,
                  let city = placemark.locality else {
                print("City not found")
                return
            }
            
            DispatchQueue.main.async {
                self.location = city
                self.passProductListToTable()
            }
        }
        
        locationManager.stopUpdatingLocation()
    }
}
