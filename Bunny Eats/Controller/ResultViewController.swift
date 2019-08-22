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
    var foodDict = [String: String]()
    var result = FoodResultModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup blurred view and landing labels
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = blurredView.bounds
        blurredView.addSubview(blurView)
        
        blurredView.alpha = 0.85
        blurredView.layer.cornerRadius = 10
        blurredView.layer.masksToBounds = true
        
        blurredView.bringSubviewToFront(food)
        blurredView.bringSubviewToFront(foodDescription)
        
        //Setup blurred view for table view
        let blurEffect2 = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView2 = UIVisualEffectView(effect: blurEffect2)
        blurView2.frame = tableView.bounds
        tableView.backgroundView = blurView2
        
        tableView.alpha = 0.60
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true

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
    
    //Food result and its descriptions
    func adaptiveResult(weather: String){
        bgImage.image = UIImage(named: weather)
        
        switch weather {
        case "sunny":
            foodDict = ["Outdoor BBQ": "Enjoy the weather with your friends and some good ol' barbecue!"]
        case "cloudy":
            foodDict = ["Coffee House": "Is there a better way to spend a cloudy afternoon than doing some work with great coffee?"]
        case "rainy":
            foodDict = ["Ramen": "Hey you! Did you know that ramen goes really well with a rainy day? The more you know!"]
        case "snowy":
            foodDict = ["Hot Pot": "A tasty hot pot with friendos can easily warm up your soul in this cold!"]
        default:
            print("Error D:")
        }
        
        let componentArray = Array(foodDict.keys)
        food.text = componentArray[0]
        foodDescription.text = foodDict[componentArray[0]]
    }
    
    //Location related methods
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
    
    //Yelp query
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
                }
            }
        }

        SVProgressHUD.dismiss()
        tableView.reloadData()
    }
    
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
