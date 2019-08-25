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
    @IBOutlet weak var landingLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    var returnedLabel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup blurred view and landing label
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = blurredView.bounds
        blurView.alpha = 0.75
        blurredView.addSubview(blurView)
        
        blurredView.layer.cornerRadius = 10
        blurredView.layer.masksToBounds = true
        
        blurredView.bringSubviewToFront(landingLabel)
        
        //Setup camera function
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        //Setup ML model
        guard let manifestPath = Bundle.main.path(forResource: "manifest",
                                                  ofType: "json",
                                                  inDirectory: "model") else { return }
        let localModel = LocalModel(
            name: "localModel",
            path: manifestPath
        )
        ModelManager.modelManager().register(localModel)
    }
    
    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Get result via ML model
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let processImage = VisionImage(image: userImage)
            
            let labelerOptions = VisionOnDeviceAutoMLImageLabelerOptions(
                remoteModelName: nil,
                localModelName: "localModel"
            )
            labelerOptions.confidenceThreshold = 0
            
            let labeler = Vision.vision().onDeviceAutoMLImageLabeler(options: labelerOptions)
            
            labeler.process(processImage) { labels, error in
                guard error == nil, let labels = labels else { return }
                
                self.returnedLabel = labels[0].text
                
                //Pass data and go to next view
                self.imagePicker.dismiss(animated: true, completion: nil)
                
                let vc = ResultViewController(nibName: "ResultViewController", bundle: nil)
                vc.weatherResult = self.returnedLabel
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
