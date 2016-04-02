//
//  ShopListViewController.swift
//  ShopSmart
//
//  Created by Mansi Modi on 12/22/15.
//  Copyright © 2015 Mansi Modi. All rights reserved.
//

import UIKit
import Alamofire


class ShopListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var Menu: UIBarButtonItem! {
    
        
        didSet{
            
            Menu.target = self.revealViewController()
            Menu.action = Selector("revealToggle:")
            
        }
    
    }
    
    @IBOutlet weak var listTableView: UITableView!
    
    var ListArray=[List]()
    
        override func viewDidLoad() {
        super.viewDidLoad()

        //Add the pan gesture to the view.
            
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
            
            self.listTableView.delegate=self
            self.listTableView.dataSource=self
                        
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
           
            let list_id = prefs.valueForKey("list_id") as! Int
            print(list_id)
            
            Alamofire.request(.GET, "http://54.153.9.205:8000/smartretailapp/api/userlistdetail/\(list_id)/?format=json")
                .responseJSON {  response in
                    switch response.result {
                    case .Success(let JSON):
                        print("Success: \(JSON)")
                        self.populateData(JSON as! NSArray)
                        
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                        
                    }
            }

            
            
            
    }
    
    func populateData(jsonData: NSArray){
        
        if(jsonData.count>0){
            
            for item in jsonData{
                
                let dict = item as! NSMutableDictionary
                let listItem = List(data: dict)
                self.ListArray.append(listItem)
                
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.listTableView.reloadData()
                
                
            };
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let List = self.listTableView.dequeueReusableCellWithIdentifier("List", forIndexPath: indexPath) as! ListTableViewCell
        
        List.listLabel.text = ListArray[indexPath.row].productTitle
        let qty:Int = (ListArray[indexPath.row].productQty!) as Int
        List.qtyLabel.text = String(qty)
        
        return List
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    //Handle Delete
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            print("Delete cell")
            let listPrdId = ListArray[indexPath.row].listProductId!
            print(listPrdId)
            self.deleteData(listPrdId)
            ListArray.removeAtIndex(indexPath.row)
            self.listTableView.reloadData()
        }
        
    }
    
    func deleteData(listPrdId: Int){
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let csrftoken = prefs.objectForKey("csrftoken") as! String
        let headers = ["X-CSRFToken" : csrftoken]
        Alamofire.request(.DELETE, "http://54.153.9.205:8000/smartretailapp/api/listprd/\(listPrdId)/", headers: headers)
            .validate()
            .responseJSON {  response in
                switch response.result {
                case .Success:
                    print("Delete Successful")
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    
                }
        }

        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
