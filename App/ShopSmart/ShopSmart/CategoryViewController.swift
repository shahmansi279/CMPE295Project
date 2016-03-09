//
//  CategoryViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 3/5/16.
//  Copyright © 2016 Mansi Modi. All rights reserved.
//

import UIKit
import Alamofire

class CategoryViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {
    
    
        var categoryName = String()
        var categoryArray=[String]()
    
      @IBOutlet var categoryTblView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add the pan gesture to the view.
        
        //self.view.addGestureRecognizer(self.revealViewContro//ller().panGestureRecognizer());
        
        
        
        // Do any additional setup after loading the view.
        
        loadData()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Step5
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    
    //Step6
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let category = self.categoryTblView.dequeueReusableCellWithIdentifier("category", forIndexPath: indexPath) as! CategoryTableViewCell
        
        //Step 8
        
        // this needs to be modified
        category.categoryLbl.text = categoryArray[indexPath.row]
        
        
        return category
        
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    
    func loadData(){
        
        //http://127.0.0.1:8000/smartretailapp/api/subcategory/?dept=Produce
        
        let url="http://54.153.9.205:8000/smartretailapp/api/subcategory/?dept=" + categoryName
        
        let modUrl = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        Alamofire.request(.GET, modUrl!)
            .responseJSON {  response in
                switch response.result {
                case .Success(let JSON):
                    self.populateData(JSON as! NSMutableArray)
                    
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    
                }
        }
    }
    
    
    func populateData(jsonData: NSMutableArray){
        
        if(jsonData.count>0){
            
            // let jsonArray = response.result.value as! NSMutableArray
            for item in jsonData{
                
                self.categoryArray.append(item[0] as! String)
                
                
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.categoryTblView.reloadData()
                
                
            };
            
            
        }
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "product_list"){
            let indexPath = self.categoryTblView.indexPathForCell(sender as! CategoryTableViewCell)
            let productLine = self.categoryArray[indexPath!.row]
            
            let dvc = segue.destinationViewController as! ProductListViewController
            
            
            dvc.productLine = productLine
        }
    }

    
    
    


}