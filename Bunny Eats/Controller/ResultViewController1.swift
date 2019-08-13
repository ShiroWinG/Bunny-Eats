//
//  ResultViewController.swift
//  Bunny Eats
//
//  Created by Zhi Wei Zhang on 8/12/19.
//  Copyright © 2019 Zhi Wei Zhang. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = topView.bounds
        topView.addSubview(blurView)
        
        topView.alpha = 0.85
        topView.layer.cornerRadius = 10
        topView.layer.masksToBounds = true
        
    }
}
