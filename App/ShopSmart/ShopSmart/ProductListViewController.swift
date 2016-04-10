//
//  CategoryViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 3/5/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import UIKit
import Alamofire

class ProductListViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var prodTblView: UITableView!
    
    var productLine = String()
    var prodArray=[Product]()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add the pan gesture to the view.
        
     //   self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        
        self.prodTblView.backgroundColor = UIColor(patternImage: UIImage(named: "whitebg.jpeg")!)

        
        
        // Do any additional setup after loading the view.
        
        loadData()
        
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Step5
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prodArray.count
    }
    
    
    //Step6
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let product = self.prodTblView.dequeueReusableCellWithIdentifier("product_list_item", forIndexPath: indexPath) as! ProductListTableViewCell
        
        //Step 8
        
        // this needs to be modified
        product.productTitle.text = prodArray[indexPath.row].productTitle
        product.backgroundColor = UIColor(patternImage: UIImage(named: "whitebg.jpeg")!)

        
        //Change color on cell selection
        
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = UIColor.backgroundColorDark()
        product.selectedBackgroundView = myCustomSelectionColorView
        product.productTitle.highlightedTextColor = UIColor.whiteColor()
        

        
        
        return product
        
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        
        self.prodTblView.deselectRowAtIndexPath(indexPath, animated: true)

        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        var numOfSection: NSInteger = 0
        
        if prodArray.count > 0 {
            
            self.prodTblView.backgroundView = nil
            numOfSection = 1
            
            
        } else {
            
            var noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.prodTblView.bounds.size.width, self.prodTblView.bounds.size.height))
            noDataLabel.text = "No Data to Display"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.Center
            self.prodTblView.backgroundView = noDataLabel
            
        }
        return numOfSection
        
        
        
    }
    
    func loadData(){
        
        
        
        //http://127.0.0.1:8000/smartretailapp/api/products/Nuts/?format=json
        
        let url = "\(Constant.baseURL)/smartretailapp/api/products/" + productLine
        let prod_url = url + "/?format=json"
        
        let modUrl = prod_url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        Alamofire.request(.GET, modUrl!)
            .responseJSON {  response in
                switch response.result {
                case .Success(let JSON):
                    self.populateData(JSON as! NSArray)
                    
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    
                }
        }
    }
    
    
    func populateData(jsonData: NSArray){
        
        if(jsonData.count>0){
            
            // let jsonArray = response.result.value as! NSMutableArray
            for item in jsonData{
                
                let dict = item as! NSMutableDictionary
                
                // let url = dict["offer_img_url"] as? String
                
                let productItem = Product(data: dict)
                self.prodArray.append(productItem)
                
                
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.prodTblView.reloadData()
                
                
            };
            
            
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "product_info"){
            let indexPath = self.prodTblView.indexPathForCell(sender as! ProductListTableViewCell)
            
            let product = self.prodArray[indexPath!.row] as! Product
            
            let dvc = segue.destinationViewController as! ProductInfoViewController
            
            
            dvc.product = product
        }
    }
    
    
    
    
    
    
}
