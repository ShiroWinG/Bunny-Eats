//
//  WeatherResultViewController.swift
//  Bunny Eats
//
//  Created by Zhi Wei Zhang on 8/16/19.
//  Copyright © 2019 Zhi Wei Zhang. All rights reserved.
//

import UIKit

class WeatherResultViewController: UIViewController {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var foodLabel: UILabel!
    
    var label = "holder"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        //Setup blurred view and landing label
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = blurredView.bounds
        blurredView.addSubview(blurView)
        
        blurredView.alpha = 0.85
        blurredView.layer.cornerRadius = 10
        blurredView.layer.masksToBounds = true
        
        foodLabel.text = label
        blurredView.bringSubviewToFront(foodLabel)
 */
        print(label)
    
    }
}
