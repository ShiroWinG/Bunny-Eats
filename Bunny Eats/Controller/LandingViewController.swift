//
//  ViewController.swift
//  Bunny Eats
//
//  Created by Zhi Wei Zhang on 8/7/19.
//  Copyright © 2019 Zhi Wei Zhang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMLCommon

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
        
        guard let manifestPath = Bundle.main.path(forResource: "manifest",
                                                  ofType: "json",
                                                  inDirectory: "model") else { return }
        let localModel = LocalModel(
            name: "localModel",
            path: manifestPath
        )
        ModelManager.modelManager().register(localModel)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let processImage = VisionImage(image: userImage)
            
            let labelerOptions = VisionOnDeviceAutoMLImageLabelerOptions(
                remoteModelName: nil,
                localModelName: "localModel"
            )
            labelerOptions.confidenceThreshold = 0.5
            
            let labeler = Vision.vision().onDeviceAutoMLImageLabeler(options: labelerOptions)
            
            labeler.process(processImage) { labels, error in
                guard error == nil, let labels = labels else { return }
                
                for label in labels {
                    let labelText = label.text
                    _ = label.confidence
                    
                    print(labelText)
                }
            }
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
}
