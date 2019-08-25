//
//  ResultViewController.swift
//  Bunny Eats
//
//  Created by Zhi Wei Zhang on 8/16/19.
//  Copyright © 2019 Zhi Wei Zhang. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ResultViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var blurredView: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var food: UILabel!
    @IBOutlet weak var foodDescription: UILabel!
    @IBOutlet var tableView: UITableView!
    
    let YELP_URL = "https://api.yelp.com/v3/businesses/search"
    let API_KEY = "zg-HdaMM_6ULbi8bL_xSBJLrFPUI7FxgMQpPIL25MS3niImiOYxPwBh-VPvQK2MvYlSZUVsnf1HqCrsQ86C8vblUKjZ2LrI7f0CJ0ISjkUZj4-3Y9v9u21jFvSxaXXYx"
    let cellReuseIdentifier = "cell"
    let locationManager = CLLocationManager()
    
    var weatherResult: String = ""
    var foodDict: [String: String] = [:]
    var result = FoodResultModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up blurred view and landing labels
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = blurredView.bounds
        blurView.alpha = 0.75
        blurredView.addSubview(blurView)
        
        blurredView.layer.cornerRadius = 10
        blurredView.layer.masksToBounds = true
        
        blurredView.bringSubviewToFront(food)
        blurredView.bringSubviewToFront(foodDescription)
        
        //Set up blurred view for table view
        let blurEffect2 = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView2 = UIVisualEffectView(effect: blurEffect2)
        blurView2.frame = tableView.bounds
        blurView2.alpha = 0.75
        tableView.backgroundView = blurView2
        
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true

        //Set up table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        //Format weather result
        weatherResult = weatherResult.filter { !$0.isNewline && !$0.isWhitespace }
        adaptiveResult(weather: weatherResult)
        
        //Set up the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        SVProgressHUD.show()
    }
    
    //MARK: - setting background based on weather and getting randomized food result
    
    func adaptiveResult(weather: String){
        bgImage.image = UIImage(named: weather)
        
        switch weather {
        case "sunny":
            foodDict = Sunny().foodResult
        case "cloudy":
            foodDict = Cloudy().foodResult
        case "rainy":
            foodDict = Rainy().foodResult
        case "snowy":
            foodDict = Snowy().foodResult
        default:
            print("Error D:")
        }
        
        let randomResult = foodDict.randomElement()
        food.text = randomResult?.key
        foodDescription.text = randomResult?.value
    }
    
    //MARK: - location related methods and using result to query for nearby eats
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longtitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["term": food.text!, "latitude": latitude, "longitude": longtitude]
            
            let header : [String: String] = ["Authorization": "Bearer \(API_KEY)"]
            
            getFoodData(url: YELP_URL, parameters: params, AuthHeader: header)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        food.text = "Location Unavailable :["
        foodDescription.text = ""
    }
    
    //MARK: - using Yelp REST API to get eats and saving them
    
    func getFoodData(url: String, parameters: [String: String], AuthHeader: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters, headers: AuthHeader).responseJSON {
            response in
            if response.result.isSuccess {
                let foodJSON : JSON = JSON(response.result.value!)
                self.updateFoodData(json: foodJSON)
            }
            else {
                self.food.text = "Connection Issues"
                self.foodDescription.text = ""
            }
        }
    }
    
    func updateFoodData(json: JSON) {
        if let bizArray = json["businesses"].array {
            
            for bizDict in bizArray {
                if let name = bizDict["name"].string {
                    result.name.append(name)
                }
                if let rating = bizDict["rating"].double {
                    result.rating.append(rating)
                }
                if let address1 = bizDict["location"]["address1"].string {
                    result.location.append(address1)
                } else {
                    result.location.append("Location unavailable")
                }
            }
        }
        
        SVProgressHUD.dismiss()
        tableView.reloadData()
    }
    
    //MARK: - table view editing and using custom cells
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.result.name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CustomCell
        
        cell.name.text = self.result.name[indexPath.row]
        cell.rating.text = String(self.result.rating[indexPath.row])
        cell.location.text = self.result.location[indexPath.row]

        return cell
    }
}
