//
//  SmartPosterClass.swift
//  BumpTags
//
//  Created by Tanner Welton on 7/23/17.
//  Copyright © 2017 Lyaze Technology. All rights reserved.
//
//

import Foundation
import CoreNFC
import UIKit

extension String {
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
}

struct BTSmartPoster {
    
    var records: [BTRecord] = []
    var lastRecord = false
    

    
    init(payload: Data) {
        
        // Payload position
        var payloadPosition = 0
        
        while (!lastRecord) {

            // Converts payload to UInt8 array
            var array = [UInt8](payload)
//            print(array)
            
            // Obtains first byte from array and converts to binary string
            let header = array[payloadPosition]
            var headerBinary = String(header, radix: 2)
            
            
            // Ensures 8 values in byte by adding zeros that may have been removed from front of value
            while (headerBinary.count != 8) {
                headerBinary.insert("0", at: headerBinary.startIndex)
            }
            
//            print(headerBinary)
            
            // Generate mb flag
            let mb = headerBinary[headerBinary.index(headerBinary.startIndex , offsetBy: 0)]
            let mbFlag = mb == "1" ? true: false
//            print("MB: \(mbFlag)")
            
            // Generate me flag
            let me = headerBinary[headerBinary.index(headerBinary.startIndex , offsetBy: 1)]
            let meFlag = me == "1" ? true: false
//            print("ME: \(meFlag)")
            
            // Set lastRecord to true if meFlag is true
            self.lastRecord = meFlag ? true:false

            // Generate cf flag
            let cf = headerBinary[headerBinary.index(headerBinary.startIndex , offsetBy: 2)]
            let cfFlag = cf == "1" ? true: false
//            print("CF: \(cfFlag)")
            
            // Generate sr flag
            let sr = headerBinary[headerBinary.index(headerBinary.startIndex , offsetBy: 3)]
            let srFlag = sr == "1" ? true: false
//            print("SR: \(srFlag)")
            
            // Generate il flag
            let il = headerBinary[headerBinary.index(headerBinary.startIndex , offsetBy: 4)]
            let ilFlag = il == "1" ? true: false
//            print("IL: \(ilFlag)")
            
            // Parse type name format
            let tnf = String(headerBinary[headerBinary.index(headerBinary.startIndex , offsetBy: 5) ... headerBinary.index(headerBinary.startIndex , offsetBy: 7)])
//            print("TNF: \(tnf)")
            
            
            
            // Type length
            let typeLength = array[payloadPosition + 1]
            payloadPosition += 1
//            print(typeLength)

//            Payload length
            var payloadLength: Int
            
            if (srFlag) { // SR flag true means payload length is 1 byte long
                payloadLength = Int(array[payloadPosition + 1])
                payloadPosition += 1
            }
                
            else { // SR flag false means payload length is 4 bytes long
                
                // Convert 4 bytes into Int value
                let payloadLengthStart = payloadPosition + 1
                let payloadLengthEnd = payloadPosition + 4
                let payloadLengthArray = array[payloadLengthStart ... payloadLengthEnd]
                let payloadLengthData = Data(bytes: payloadLengthArray)
                let payloadLengthUInt32 = UInt32(bigEndian: payloadLengthData.withUnsafeBytes { $0.pointee})
                // Converted payload length
                payloadLength = Int(payloadLengthUInt32)
                // Increment by 4
                payloadPosition += 4
            }
            
            
//            print(payloadLength)
            // id length
            if (ilFlag) {
                payloadPosition += 1
            }
            
            // payload type
            var payloadType = ""
            if (typeLength > 0) {
                let index = payloadPosition + 1
                let endIndex = payloadPosition + Int(typeLength)
                let typeArray = array[index ... endIndex]
                let converted = Data(bytes: typeArray)
                payloadType = String(data: converted , encoding: .utf8)!
//                print(typeArray)
//                print(payloadType)
                
//                print("payload Position: \(payloadPosition) Value: \(array[payloadPosition])")
                payloadPosition += Int(typeLength)
//                print("payload Position: \(payloadPosition) Value: \(array[payloadPosition])")
            }
            
            // Create new record object and add to array
            self.records.append(BTRecord(array: array, tnf: tnf, payloadType: payloadType, payloadPosition: payloadPosition, payloadLength: payloadLength))
            payloadPosition += payloadLength + 1
        } // end loop
    }
}

struct BTRecord {
    
    //
    var tnf: String
    var payloadType: String
    var payloadArray: [UInt8]
    var payload: String?
    
    
    init(array: [UInt8] , tnf: String , payloadType: String , payloadPosition: Int, payloadLength: Int) {
        
        self.tnf = tnf
        self.payloadType = payloadType
        self.payloadArray = [UInt8](array[(payloadPosition + 1)...(payloadPosition + payloadLength)])
        // Run Parser
//        print(self.payloadArray)
        self.payloadParser()
    }
    
    init(tnf: UInt8 , payloadType: Data , payloadData: Data) {
        
        if let tnf = String.init(data: payloadData , encoding: .utf8) {
            self.tnf = tnf
        }
        else {
            self.tnf = "Unknown"
        }
        
        if let type = String.init(data: payloadType , encoding: .utf8) {
            self.payloadType = type
        }
        else {
            self.payloadType = "Unknown"
        }
        
        self.payloadArray = [UInt8](payloadData)
        
        // Run Parser
        self.payloadParser()
    }
    
    static func URLSession(session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: (URLRequest!) -> Void) -> URL? {
        
        completionHandler(nil)
        return response.url
    }
    
    mutating func payloadParser() {
        
        // Used for separating message from other describers
        var header = 0
        var messageLength = payloadArray.count - 1
        
        // ----------------------------------- URI Types ------------------------------------
        
        if (payloadType == "U") {
            let uriID = Int(payloadArray[header])
            header += 1
            messageLength -= 1
            
            // URI 0 - Non-standard URL's ex: sms:18015551234 or instagram://profile
            if (uriID == 0) {
                let URLString = getPayload(header: header, messageLength: messageLength)
                if let questionIndex = URLString.index(of: "?") {
                    self.payload = URLString.substring(to: questionIndex)
                }
                else {
                    self.payload = URLString
                }
            }
            
            // URI 1
            else if (uriID == 1) {
                let prefix = "http://www."
                self.payload = prefix + getPayload(header: header, messageLength: messageLength) 
            }
            
            // URI 2
            else if (uriID == 2) {
                let prefix = "https://www."
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 3
            else if (uriID == 3) {
                let prefix = "http://"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 4
            else if (uriID == 4) {
                let prefix = "https://"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 5
            else if (uriID == 5) {
                let prefix = "tel:"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 6
            else if (uriID == 6) {
                let prefix = "mailto:"
                let URLString = getPayload(header: header, messageLength: messageLength)
                if let questionIndex = URLString.index(of: "?") {
                    self.payload = prefix + URLString.substring(to: questionIndex)
                }
                else{
                    self.payload = prefix + getPayload(header: header, messageLength: messageLength)
                }
            }
            
            // URI 7
            else if (uriID == 7) {
                let prefix = "ftp://anonymous:anonymous@"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 8
            else if (uriID == 8) {
                let prefix = "ftp://ftp."
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 9
            else if (uriID == 9) {
                let prefix = "ftps://"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 10
            else if (uriID == 10) {
                let prefix = "sftp://"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 11
            else if (uriID == 11) {
                let prefix = "smb://"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 12
            else if (uriID == 12) {
                let prefix = "nfs://"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 13
            else if (uriID == 13) {
                let prefix = "ftp://"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 14
            else if (uriID == 14) {
                let prefix = "dav://"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 15
            else if (uriID == 15) {
                let prefix = "news:"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 16
            else if (uriID == 16) {
                let prefix = "telnet://"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 17
            else if (uriID == 17) {
                let prefix = "imap:"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 18
            else if (uriID == 18) {
                let prefix = "rtsp://"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 19
            else if (uriID == 19) {
                let prefix = "urn:"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 20
            else if (uriID == 20) {
                let prefix = "pop:"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 21
            else if (uriID == 21) {
                let prefix = "sip:"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 22
            else if (uriID == 22) {
                let prefix = "sips:"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 23
            else if (uriID == 23) {
                let prefix = "tftp:"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 24
            else if (uriID == 24) {
                let prefix = "btspp://"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 25
            else if (uriID == 25) {
                let prefix = "btl2cap://"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 26
            else if (uriID == 26) {
                let prefix = "btgoep://"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 27
            else if (uriID == 27) {
                let prefix = "tcpobex://"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 28
            else if (uriID == 28) {
                let prefix = "irdaobex://"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 29
            else if (uriID == 29) {
                let prefix = "file://"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 30
            else if (uriID == 30) {
                let prefix = "urn:epc:id:"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 31
            else if (uriID == 31) {
                let prefix = "urn:epc:tag:"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 32
            else if (uriID == 32) {
                let prefix = "urn:epc:pat"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 33
            else if (uriID == 33) {
                let prefix = "urn:epc:raw:"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 34
            else if (uriID == 34) {
                let prefix = "urn:epc"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            // URI 35
            else if (uriID == 35) {
                let prefix = "urn:nfc:"
                self.payload = prefix + getPayload(header: header, messageLength: messageLength)
            }
            
            
//            print(self.payload)
        }
        
        // ----------------------------------- Text Types -----------------------------------
        
        
        if (payloadType == "T") {
            
            // get language code byte length
            let langLength = Int(payloadArray[header])
            header += 1
            messageLength -= 1
//            print(langLength)
            
            // get language code
//            let langArray = array[header + 1 ... header + 2]
//            let langData = Data(bytes: langArray)
//            let lang = String(data: langData , encoding: .utf8)
            header += langLength
            messageLength -= langLength
            
            self.payload = getPayload(header: header, messageLength: messageLength)
        }
    }

    func getPayload(header: Int , messageLength: Int) -> String {
        
        var payloadString = ""
        
//        if (self.tnf == "001") {
            let payloadStart = header
            let payloadEnd = header + messageLength
            let payloadUint8 = self.payloadArray[payloadStart...payloadEnd]
            let payloadConverted = Data(bytes:payloadUint8)
            if let value = String(data: payloadConverted , encoding: .utf8) {
                payloadString = value
            }
//        }
//        else {
//            payloadString = "Unsupported Type"
//        }
        return payloadString
    }
}

    

