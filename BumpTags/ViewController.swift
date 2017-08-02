//
//  ViewController.swift
//  BumpTags
//
//  Created by Tanner Welton on 7/17/17.
//  Copyright © 2017 Lyaze Technology. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var helper: NFCReader?
    var payloadText = ""
    var userScanResponse = ""
    
    @IBOutlet weak var readNFC: UIButton!
    @IBOutlet weak var tapToScanLabel: UILabel!
    @IBOutlet weak var tapToScanArrow: UIImageView!
    
    
    override func viewDidLoad() {
        let logo = UIImage(named: "title.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha:1.0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let savedTags = segue.destination as! SavedTagsTVC
        if let records = helper?.records {
            for record in records {
                savedTags.records.append(record)
            }
        }
        
    }
    
    
    // Called by NFCHelper when a tag is read, or fails to read
    // Sets userScanResponse to help user know if success or not
    
    func onNFCResult(success: Bool, message: String) {
        if success {
            
            //stores
            payloadText = "\(payloadText)\(message)"
            print(payloadText)
            
            //success response for user
            userScanResponse = "Success"
        }
        else {
            // stores message and prints to console
            payloadText = message
//            print(payloadText)
            
            // failure response for user
            userScanResponse = "Try Again"
        }
        
        // Update UI on main thread
        
//        DispatchQueue.main.async() {
//            self.tapToScanTransition(duration: 0.5, fadeIn: true)
//            self.tapToScanLabel.text = self.userScanResponse
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.tapToScanTransition(duration: 0.5, fadeIn: false)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            self.tapToScanLabel.text = "Tap to scan"
//            self.tapToScanTransition(duration: 0.5, fadeIn: true, arrow: true)
//
//        }
        
    }
    @IBAction func readNFC(_ sender: Any) {
        didTapReadNFC()
    }
    
    // custom alert dialog function
    func alertDialog(title: String , message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // Custom Function to fade text on tapToScanLabel and arrow
    func tapToScanTransition(duration: Float, fadeIn: Bool, arrow: Bool = false) {
        
        //fade in label and arrow
        if fadeIn && arrow{
            UIView.animate(withDuration: TimeInterval(duration), animations: {
                self.tapToScanLabel.alpha = 0.25
                self.tapToScanArrow.alpha = 1
            })
        }
        
        //fade in only label
        if fadeIn {
            UIView.animate(withDuration: TimeInterval(duration), animations: {
                self.tapToScanLabel.alpha = 0.25
            })
        }
            
            //fade out label and arrow
        else if arrow{
            UIView.animate(withDuration: TimeInterval(duration), animations: {
                self.tapToScanLabel.alpha = 0
                self.tapToScanArrow.alpha = 0
            })
        }
            
            //fade out only label
        else {
            UIView.animate(withDuration: TimeInterval(duration), animations: {
                self.tapToScanLabel.alpha = 0
            })
        }
    }
    
    
    // Called when user taps Read NFC Button
    func didTapReadNFC() {
        
        // hide label and arrow
//        tapToScanTransition(duration: 1.0, fadeIn: false, arrow: true)
        
        
        
        if helper == nil {
            helper = NFCReader()
            helper?.onNFCResult = self.onNFCResult(success:message:)
        }
        helper?.restartSession()
    }
    
    
}



