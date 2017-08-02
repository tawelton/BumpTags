//
//  NFCReader.swift
//  BumpTags
//
//  Created by Tanner Welton on 7/17/17.
//  Copyright © 2017 Lyaze Technology. All rights reserved.
//

import Foundation
import CoreNFC
import UIKit

class NFCReader: NSObject, NFCNDEFReaderSessionDelegate {
    
    var onNFCResult: ((Bool, String) -> ())?
    var records = [BTRecord]()
    
    func restartSession() {
        let session =
            NFCNDEFReaderSession(delegate: self,
                                 queue: nil,
                                 invalidateAfterFirstRead: true)
        session.begin()
    }
    // MARK: NFCNDEFReaderSessionDelegate
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        guard let onNFCResult = onNFCResult else {
            return
        }
        onNFCResult(false, error.localizedDescription)
    }
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        guard let onNFCResult = onNFCResult else {
            return
        }
        
        for message in messages {
            for record in message.records {
                if(record.payload.count > 0) {
                    if let payloadString = String.init(data: record.payload, encoding: .utf8) {
                        onNFCResult(true, payloadString)
                    }
                }
                if let payloadType = String.init(data: record.type , encoding: .utf8) {
                    if (payloadType == "U") {
                        print(record.typeNameFormat.rawValue)
                        print(payloadType)
                        print([UInt8](record.payload))
                        let record = BTRecord(tnf: record.typeNameFormat.rawValue, payloadType: record.type, payloadData: record.payload)
                        
                        // determine action
                        record.performAction(withDelay: 2.0)
                        //push to table array
                        records.insert(record, at: 0)
                    }
                    if (payloadType == "Sp") {
                        var smartPoster = BTSmartPoster(payload: record.payload)
                        for record in smartPoster.records {
                            if let payload = record.payload {
                                print(payload)
                                record.performAction(withDelay: 2.0)
                                
                                // push to table array
                                records.insert(record, at: 0)
                            }
                        }
                    }
                }
            }
        }
    }
}

