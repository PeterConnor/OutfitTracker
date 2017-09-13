//
//  GroupViewController.swift
//  OutfitTracker
//
//  Created by Pete Connor on 7/8/17.
//  Copyright © 2017 c0nman. All rights reserved.
//

import UIKit

protocol GroupDelegate {
    func userDidPickGroup(group: String)
}

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var groupList = [String]()
    let exampleGroupList = ["E.g. Family", "E.g. Friends", "E.g. Work"]
    var delegate: GroupDelegate? = nil
    var tap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-BoldItalic", size: 20)!, NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        if let persistedGroupList = UserDefaults.standard.object(forKey: "groupList") {
            groupList = persistedGroupList as! [String]
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if groupList.count < 1 {
            return 3
        } else {
            return groupList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if groupList.count < 1 {
            cell.textLabel?.text = exampleGroupList[indexPath.row]
            cell.textLabel?.textColor = .gray
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-BoldItalic", size: 17.0)
        } else {
            cell.textLabel?.text = groupList[indexPath.row]
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-BoldItalic", size: 17.0)
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if (delegate != nil) {
            if let group = cell?.textLabel?.text {
            delegate!.userDidPickGroup(group: group)
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groupList.remove(at: indexPath.row)
            UserDefaults.standard.set(groupList, forKey: "groupList")
            tableView.reloadData()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.addGestureRecognizer(tap)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.removeGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != nil && textField.text != "" {
            groupList.append(textField.text!)
            UserDefaults.standard.set(groupList, forKey: "groupList")
            
            tableView.reloadData()
        }
        textField.resignFirstResponder()
        textField.text = nil
        return true
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        view.removeGestureRecognizer(tap)
        textField.text = nil
        textField.resignFirstResponder()
    }
    
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
