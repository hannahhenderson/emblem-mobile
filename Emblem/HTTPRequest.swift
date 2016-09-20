//
//  HTTPRequest.swift
//  Emblem
//
//  Created by Dane Jordan on 8/10/16.
//  Copyright © 2016 Hadashco. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import SwiftyJSON

enum DataType {
    case JSON
    case OCTETSTREAM
}


class HTTPRequest {
    
    class func get(url:NSURL, getCompleted: (response: NSHTTPURLResponse, data: NSData) -> ()) {
        var url = url
        
        //TODO: enable without internet access
        if (Store.accessToken != "") {
            if let newUrl = NSURL(string: url.absoluteString + "?access_token=\(Store.accessToken)") {
                url = newUrl
            }
        } else {
            print("No access token")
        }
        
        print(url.absoluteString)
        //TODO: Replace with NSURLRequest
        let session = NSURLSession.sharedSession()

        let task = session.dataTaskWithURL(url) {(data, response, error) in
            
            if let httpresponse = response as? NSHTTPURLResponse {
                if error != nil {
                    print("GET Request Error: \(error!.localizedDescription)")
                } else {
                    print("GET Server Response: \(httpresponse.statusCode)")
                    print("GET Server URL: \(httpresponse.URL!.absoluteString)")
                    getCompleted(response: httpresponse, data: data!)
                }
            } else if let error = error {
                print("GET Request error: \(error.localizedDescription)")
            } else {
                print("No Server Response")
            }
        }
        task.resume()
        
    }
    
    class func post(params: Dictionary<String, AnyObject>, dataType: DataType, url: NSURL, postCompleted: (succeeded: Bool, msg: JSON) -> ()){
        var url = url
        if (Store.accessToken != "") {
            if let newUrl = NSURL(string: url.absoluteString + "?access_token=\(Store.accessToken)") {
                url = newUrl
            }
        } else {
            print("No access token")
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        var dataTypeString = ""
        switch dataType {
        case .JSON:
            dataTypeString = "application/json"
        case .OCTETSTREAM:
            dataTypeString = "application/octet-stream"
        }
        request.addValue(dataTypeString, forHTTPHeaderField: "Content-Type")
        request.addValue(dataTypeString, forHTTPHeaderField: "Accept")
        request.addValue("close", forHTTPHeaderField: "Connection")
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.timeoutIntervalForRequest = 180.0
        sessionConfig.timeoutIntervalForResource = 180.0
        let session = NSURLSession(configuration: sessionConfig)
        
        if dataType == .JSON {
            do {
                let json = try NSJSONSerialization.dataWithJSONObject(params, options: [])
                request.HTTPBody = json
            } catch {
                print("HTTPBody set error: \(error)")
            }
        } else if dataType == .OCTETSTREAM {
            request.HTTPBody = params["image"] as? NSData
            request.addValue("png", forHTTPHeaderField: "File-Type")
            let imageLength = String(params["imageLength"] as! Int)
            request.addValue(imageLength, forHTTPHeaderField: "Content-Length")
        }


        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if let error = error {
                print(error)
                return
            }
            let statusCode = (response as! NSHTTPURLResponse).statusCode
            print("POST URL: \(response!.URL) \nPOST Response Status Code: \(statusCode)")
            
            let resString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            print("Post Response Body: \(resString)")
            
            
            let json = JSON(data: data!)
            print("POST RESPONSE: \(json)")
            if statusCode == 200 {
                if resString != "" {
                    postCompleted(succeeded: true, msg: JSON(["response":resString]))
                } else {
                    postCompleted(succeeded: true, msg: json)
                }
            } else {
                postCompleted(succeeded: false, msg: JSON(["response":resString]))
            }
        }
        task.resume()
    }
}