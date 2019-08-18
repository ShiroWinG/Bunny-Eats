//
//  ResultViewController.swift
//  Bunny Eats
//
//  Created by Zhi Wei Zhang on 8/16/19.
//  Copyright © 2019 Zhi Wei Zhang. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var blurredView: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var food: UILabel!
    @IBOutlet weak var foodDescription: UILabel!
    
    var weatherResult: String = ""
    var foodDict = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup blurred view and landing label
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = blurredView.bounds
        blurredView.addSubview(blurView)
        
        blurredView.alpha = 0.85
        blurredView.layer.cornerRadius = 10
        blurredView.layer.masksToBounds = true
        
        blurredView.bringSubviewToFront(food)
        blurredView.bringSubviewToFront(foodDescription)
        
        print(weatherResult)
        weatherResult = weatherResult.filter { !$0.isNewline && !$0.isWhitespace }
        adaptiveResult(weather: weatherResult)
    }
    
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
}
