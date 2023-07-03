//
//  ViewController.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 29.06.2023.
//

import UIKit
import CoreLocation

final class MainPageVC: UIViewController {
    
    let dateFormatter = DateFormatter()
    let locationManager = CLLocationManager()
    var foodCategories: FoodCategories?
    var service: FoodCategoriesProtocol?
    var location = String()
    
    var mainPageView: MainPageView { return self.view as! MainPageView}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        fetchData()
        
        events()
    }
    override func loadView() {
        self.view = MainPageView(frame: UIScreen.main.bounds)
    }
    
    func fetchData() {
        service?.loadFoodCategoriesData { [weak self] result in
            switch result {
            case .success(let categories):
                DispatchQueue.main.async {
                    self?.foodCategories = categories
                    self?.passCategoriesToTable()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func events() {
        mainPageView.foodTable.onCategorySelected = { [weak self] categoryName in
            let vc = ScreenFactory.makeDishesVC(category: categoryName)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }



    
    func passCategoriesToTable() {
        mainPageView.foodTable.loadCategories(foodCategories?.сategories ?? [], location, getCurrentDate())
    }
    
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")

        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    
    
}

extension MainPageVC: CLLocationManagerDelegate {

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
            }
        }
        
        locationManager.stopUpdatingLocation()
    }
}

