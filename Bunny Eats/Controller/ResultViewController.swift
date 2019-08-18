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
    
    var weatherResult: String = ""
    
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
        
        print(weatherResult)
        weatherResult = weatherResult.filter { !$0.isNewline && !$0.isWhitespace }
        adaptiveResult(weather: weatherResult)
    }
    
    func adaptiveResult(weather: String){
        bgImage.image = UIImage(named: weather)
    }
}
