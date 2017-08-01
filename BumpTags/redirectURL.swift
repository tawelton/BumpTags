//
//  redirectURL.swift
//  BumpTags
//
//  Created by Tanner Welton on 7/29/17.
//  Copyright © 2017 Lyaze Technology. All rights reserved.
//

import Foundation

class MySession: NSObject,URLSessionDelegate, URLSessionTaskDelegate {
    
    // to prevent redirection
    func URLSession(session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: (URLRequest!) -> Void) {
        completionHandler(nil)
    }
    
    // fetch data from URL with NSURLSession
    class func getDataFromServerWithSuccess(myURL: String, noRedirect: Bool, success: (_ response: String?) -> Void) {
        var myDelegate: MySession? = nil
        if noRedirect {
            myDelegate = MySession()
        }
        let session = URLSession(configuration: URLSessionConfiguration.defaultSessionConfiguration(), delegate: myDelegate! , delegateQueue: nil)
        let loadDataTask = session.dataTaskWithURL(NSURL(string: myURL)!) { (data: NSData!, response: URLResponse!, error: NSError!) -> Void in
            // OMITTING ERROR CHECKING FOR BREVITY
            success(response: NSString(data: data!, encoding: NSASCIIStringEncoding) as String)
        }
        loadDataTask.resume()
    }
    
    // extract data from redirect
    class func getRedirectionInfo(url: String) {
        getDataFromServerWithSuccess(myURL: url, noRedirect: true, success: <#(String?) -> Void#>)
    }
}

MySession.getRedirectionInfo("http://bit.ly/filmenczer")
