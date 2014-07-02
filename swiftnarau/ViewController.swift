//
//  ViewController.swift
//  swiftnarau
//
//  Created by Tokunbo George on 6/20/14.
//  Copyright (c) 2014 Rackspace. All rights reserved.
//

import UIKit

class ViewController: UIKit.UIViewController {

    
    @IBOutlet var myButton : UIButton
    @IBOutlet var myTextfield1 : UITextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    func handler(response: NSURLResponse!, returneddata : NSData!, error : NSError!) {
        if(error){
            println(error)
        }
        var mydata = NSString(data:returneddata, encoding:NSUTF8StringEncoding)
        NSOperationQueue.mainQueue().addOperationWithBlock {
            if(error) {
                self.myTextfield1.text = error.localizedDescription
            }
            else{
                self.myTextfield1.text = mydata
            }
        }
    }
    
    
    func getStockPrice(sym : String, funcptr: (response: NSURLResponse!, returneddata : NSData!, error: NSError!) -> Void )  {
        let urlPath: String = "http://download.finance.yahoo.com/d/quotes.csv?s="+sym+"&f=sb2b3jk"
        var url = NSURL(string: urlPath)
        var req = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue(), completionHandler:funcptr)
        //Why did I make getStockPrice take a function pointer instead of just putting "handler" directly?
        //Because doing it this way allows me specify my own callback function when making a unittest for it.
        // ---
        //Check out the unittest for this function.
    }

    
    @IBAction func buttonPress(sender : AnyObject) {
       getStockPrice(myTextfield1.text,handler)
    }
    
    @IBAction func viewTapped(sender : AnyObject) {
        myTextfield1.resignFirstResponder()
    }
    
}

