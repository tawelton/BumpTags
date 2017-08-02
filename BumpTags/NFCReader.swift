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
    
    // ReaderSession failed
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        guard let onNFCResult = self.onNFCResult else {
            return
        }
        onNFCResult(false, error.localizedDescription)
    }
    
    // ReaderSession succeeded
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        guard let onNFCResult = self.onNFCResult else {
            return
        }
        
        // Parse message
        for message in messages {
            for record in message.records {
                if let payloadType = String.init(data: record.type , encoding: .utf8) {

                    // URL type
                    if (payloadType == "U") {
                        
                        let record = BTRecord(tnf: record.typeNameFormat.rawValue, payloadType: record.type, payloadData: record.payload)

                        //push to table array
                        records.insert(record, at: 0)

                    }
                    
                    //Smart Poster Type
                    if (payloadType == "Sp") {
                        
                        let smartPoster = BTSmartPoster(payload: record.payload)
                        
                        for record in smartPoster.records {
                            if (record.payload != nil) {
                                // push to table array
                                records.insert(record, at: 0)
                            }
                        }
                        
                    }
                    
                }
            }
        }
        onNFCResult(true, "Success")
        records = []
    }
}

