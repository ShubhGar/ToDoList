//
//  ViewController.swift
//  ToDoList
//
//  Created by shubham Garg on 29/07/20.
//  Copyright © 2020 shubham Garg. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var tasks:[ToDoTask] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        self.loadTasksFromCoreData()
    }

    @IBAction func addTaskBtnAxn(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add To Do Task", message: nil, preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "To Do"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields?[0] // Force unwrapping because we know it exists.
            
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            let managedObjectCotext = appdelegate?.persistentContainer.viewContext
            let task = NSEntityDescription.insertNewObject(forEntityName: "ToDoTask", into:  managedObjectCotext!) as? ToDoTask
            task?.taskName = textField?.text
            task?.taskTime = Date().description
            try? managedObjectCotext?.save()
            self.loadTasksFromCoreData()
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func loadTasksFromCoreData(){
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectCotext = appdelegate?.persistentContainer.viewContext
        let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoTask")
        fReq.returnsObjectsAsFaults = false
        let result : [ToDoTask] =  (try? managedObjectCotext?.fetch(fReq) as? [ToDoTask]) ?? []
        self.tasks = result
        self.tableView.reloadData()
    }
    
    func deleteFromCoreData(time: String){
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectCotext = appdelegate?.persistentContainer.viewContext
        let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoTask")
        fReq.predicate = NSPredicate(format: "taskTime==%@", time)
        if let result = try? managedObjectCotext?.fetch(fReq) {
            
            for object in result {
                managedObjectCotext?.delete(object as! NSManagedObject)
            }
            self.loadTasksFromCoreData()
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ToDoTableViewCell.self), for: indexPath) as! ToDoTableViewCell
        let task = tasks[indexPath.row]
        cell.taskNameLbl.text = task.taskName
        cell.taskTimeLbl.text = task.taskTime
        return cell
    }
    
    // this method handles row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

           if editingStyle == .delete {
            let task = tasks[indexPath.row]
            self.deleteFromCoreData(time: task.taskTime ?? "")
           }
       }
    
    
}
