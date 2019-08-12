//
//  ViewController.swift
//  Bunny Eats
//
//  Created by Zhi Wei Zhang on 8/7/19.
//  Copyright © 2019 Zhi Wei Zhang. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var blurredView: UIView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = blurredView.bounds
        blurredView.addSubview(blurView)
        
        blurredView.alpha = 0.85
        blurredView.layer.cornerRadius = 10
        blurredView.layer.masksToBounds = true
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
        }
    }
    
    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
}
