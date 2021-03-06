//
//  ProductsViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 12/22/15.
//  Copyright © 2015 Mansi Modi. All rights reserved.
//

import UIKit
import Alamofire

class ProductsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var depttableView: UITableView!
   
    
    
    
    var DeptArray=[String]()
    

    
    @IBOutlet var Menu: UIBarButtonItem!{
    
        
        didSet{
            
            Menu.target = self.revealViewController()
            Menu.action = Selector("revealToggle:")
    
            
        }
    
    
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Add the pan gesture to the view.
        
        self.depttableView.delegate=self
        self.depttableView.dataSource=self
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        
          
        self.depttableView.backgroundColor = UIColor(patternImage: UIImage(named: "whitebg.jpeg")!)

        
        loadData()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Step5
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeptArray.count
    }
    
    
    //Step6
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let Dept = self.depttableView.dequeueReusableCellWithIdentifier("Dept", forIndexPath: indexPath) as! TableViewCell
        
        //Step 8
        
        Dept.backgroundColor = UIColor(patternImage: UIImage(named: "whitebg.jpeg")!)
        
  // this needs to be modified
         Dept.myLabel.text = DeptArray[indexPath.row]
        
       
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = UIColor.backgroundColorDark()
        Dept.selectedBackgroundView = myCustomSelectionColorView
        Dept.myLabel.highlightedTextColor = UIColor.whiteColor()
        
        return Dept
        
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        self.depttableView.deselectRowAtIndexPath(indexPath, animated: true)    }

    
    
    func loadData(){
        
        Alamofire.request(.GET, "\(Constant.baseURL)/smartretailapp/api/depts/?format=json")
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
                
                self.DeptArray.append(item[0] as! String)
                
                
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.depttableView.reloadData()
                
                
            };
            
            
        }
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        
        var numOfSection: NSInteger = 0
        
        if DeptArray.count > 0 {
            
            self.depttableView.backgroundView = nil
            numOfSection = 1
            
            
        } else {
            
            var noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.depttableView.bounds.size.width, self.depttableView.bounds.size.height))
            noDataLabel.text = "No Data to Display"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.Center
            self.depttableView.backgroundView = noDataLabel
            
        }
        return numOfSection
        
 
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "category_detail"){
            let indexPath = self.depttableView.indexPathForCell(sender as! TableViewCell)
            let category = self.DeptArray[indexPath!.row]
            
            let dvc = segue.destinationViewController as! CategoryViewController
            
            
            dvc.categoryName = category
        }
    }
    
    
      /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
