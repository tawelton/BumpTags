//
//  ViewController.swift
//  BumpTags
//
//  Created by Tanner Welton on 7/17/17.
//  Copyright © 2017 Lyaze Technology. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var helper: NFCReader?
    var payloadText = ""
    var userScanResponse = ""
    var records = [BTRecord]()
    var openRecord = false
    
    @IBOutlet weak var readNFC: UIButton!
    @IBOutlet weak var tapToScanLabel: UILabel!
    @IBOutlet weak var tapToScanArrow: UIImageView!
    
    // Sets image
    override func viewDidLoad() {
        let logo = UIImage(named: "title.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

    }

    // passes records to SavedTagsTVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let savedTags = segue.destination as! SavedTagsTVC
        
        for record in self.records {
            savedTags.records.append(record)
        }
        
    }
    
    
//     Called by NFCHelper when a tag is read, or fails to read
//     Sets userScanResponse to help user know if success or not
//    Processes opening or saving
    
    func onNFCResult(success: Bool, message: String) {
        if (success) {
          print(success)
            //stores
            payloadText = message
            print("text!: " + payloadText)
            
            //success response for user
            userScanResponse = "Success"
            
            if let records = helper?.records {
                
                var title: String?
                var urlExists = false
                var textExists = false
                
                // determines if smartposter with url and title
                for record in records {
                    if (record.payloadType == "U") {
                        // determine action
                        urlExists = true
                    }
                    if (record.payloadType == "T") {
                        textExists = true
                    }
                }
                if (urlExists && textExists) {
                    // saves title from text record
                    for record in records {
                        if (record.payloadType == "T") {
                            title = record.payload!
                        }
                    }
                    // pushes title url record and inserts in records array and performs action
                    for record in records {
                        if (record.payloadType == "U") {
                            actionAlert(title: "Tag contains a link", message: "Would you like to open now or save for later?", record: record)
                            
                            var record = record
                            if let title = title {
                                record.setTitleAs(title: title)
                            }
                            self.records.insert(record, at: 0)
                        }
                    }
                }
                else {
                    for record in records {
                        
                        
                        var typeMessage: String
                        
                        if (record.payloadType == "U") {
                           typeMessage = "a link"
                        }
                        else if (record.payloadType == "T") {
                            typeMessage = "text"
                        }
                        else {
                            typeMessage = "unknown content"
                        }
                        
                        actionAlert(title: "Tag contains \(typeMessage)", message: "Would you like to open now or save for later?", record: record)
                        
                        if (openRecord) {
                            // determine action
                            record.performAction(withDelay: 1.0)
                            self.openRecord = false
                        }
                        
                        // insert in array
                        self.records.insert(record, at: 0)
                    }
                }
            }

        } // end success = true
        
    } // end onNFCResult
    
    
    // Called when user taps Read NFC Button
    @IBAction func readNFC(_ sender: Any) {
        didTapReadNFC()
    }

    // Called from readNFC() after user tap
    func didTapReadNFC() {
        
        if helper == nil {
            helper = NFCReader()
            helper?.onNFCResult = self.onNFCResult(success:message:)
        }
        helper?.restartSession()
    }
    
    func actionAlert(title: String, message: String, record: BTRecord) {
        
        // Create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create the actions
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            UIAlertAction in
            
        }
        let openAction = UIAlertAction(title: "Open", style: .cancel) {
            UIAlertAction in
            record.performAction(withDelay: 0.0)
            
        }
        
        // Add the actions
        alertController.addAction(saveAction)
        alertController.addAction(openAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
}



