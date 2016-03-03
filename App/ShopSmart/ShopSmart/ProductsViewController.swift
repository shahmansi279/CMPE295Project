//
//  ProductsViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 12/22/15.
//  Copyright © 2015 Mansi Modi. All rights reserved.
//

import UIKit
import Alamofire

class ProductsViewController : UITableViewController {

    
    //ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
    
    
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
        
        self.tableView.delegate=self
        self.tableView.dataSource=self
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
    
    //    DeptArray = [" "," "," "]
        
        loadData()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Step5
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeptArray.count
    }
    
    
    //Step6
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let Dept = self.tableView.dequeueReusableCellWithIdentifier("Dept", forIndexPath: indexPath) as UITableViewCell
        
        //Step 8
        
  // this needs to be modified
        // Dept.pdtTitle.text = DeptArray[indexPath.row]
        
        
        return Dept
        
        
    }
    

    
    
    func loadData(){
        
        Alamofire.request(.GET, "http://127.0.0.1:8000/smartretailapp/api/depts/?format=json")
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
                
                self.DeptArray.append(item as! String)
                
                
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.tableView.reloadData()
                
                
            };
            
            
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
