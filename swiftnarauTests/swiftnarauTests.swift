//
//  swiftnarauTests.swift
//  swiftnarauTests
//
//  Created by Tokunbo George on 6/20/14.
//  Copyright (c) 2014 Rackspace. All rights reserved.
//

import XCTest
import UIKit
import swiftnarau

class swiftnarauTests: XCTestCase {
    
    var isTestComplete:Bool = false
    
    //I've heard that async events in unittests are bad, especially network bound stuff, but I have this simple way to deal with them
    //so... why not. :)
    func waitForAsync() {
        var timeout = 30.0
        var startTime:NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
        while(!isTestComplete){
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow:1))
            var elapsedTime:NSTimeInterval = NSDate.timeIntervalSinceReferenceDate() - startTime
            if(elapsedTime > timeout) {
                XCTFail("This unittest took too long. More than "+timeout.description+" seconds")
                self.isTestComplete = true
                break
            }
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.isTestComplete = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
        
    func testGetStockPrice_successful() {
        
        //I'm aware that this test is more an API test that shouldn't be done in an iOS unittest at all,
        //but I'm doing this just to demonstrate how to write a unittest & deal with async in swift.
        var stocksymbol:NSString = "GOOG"
        
        func mycallback(response: NSURLResponse!, returneddata : NSData!, error : NSError!) {
            self.isTestComplete = true
            var mydata = NSString(data:returneddata, encoding:NSUTF8StringEncoding)
            if(error != nil){
                XCTFail(error.localizedDescription)
            }
            if ( !((mydata! as NSString).containsString(stocksymbol)) ) {
                XCTFail("Didn't find stock symbol "+stocksymbol+" in returned data: "+mydata!)
            }
        }

        var smvc = UIStoryboard(name:"Main",bundle:nil).instantiateViewControllerWithIdentifier("StockMarketViewController") as swiftnarau.StockMarketViewController
        
        //The fact that I had to make methods public in the application code for the sole purpose of allowing
        //this unittest to be able to call its methods, kinda bothers me. Perhaps that means I shouldn't have
        //the getStockPrice() method as part of the ViewController at all. Maybe every method that I'd like to unittest
        //should be a method of a standalone class(e.g. "class MyAppCoreActions"), in its own file called MyAppCoreActions.swift
        smvc.getStockPrice(stocksymbol,mycallback)
        self.waitForAsync()
    }
    
}
