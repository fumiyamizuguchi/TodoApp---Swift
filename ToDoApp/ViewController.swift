//
//  ViewController.swift
//  ToDoApp
//
//  Created by Fumiya Mizuguchi on 2014/07/29.
//  Copyright (c) 2014年 Fumiya Mizuguchi. All rights reserved.
//

import UIKit

enum TodoAlertViewType {
  case Create, Update(Int), Destroy(Int)
}

class ViewController: UIViewController {
  
  var todo = TodoDataManager.sharedInstance
  
  var alert: UIAlertController?
  var alertType: TodoAlertViewType?
  
  var tableView: UITableView?
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let header = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 64))
    header.image = UIImage(named: "header")
    header.userInteractionEnabled = true
    
    let title = UILabel(frame: CGRect(x: 10, y: 20, width: 310, height: 44))
    title.text = "Todo List"
    header.addSubview(title)
    
    let button = UIButton.buttonWithType(.System) as UIButton
    button.frame = CGRect(x: 320 - 50, y: 20, width: 50, height: 44)
    button.setTitle("Add", forState: .Normal)
    button.addTarget(self, action: "showCreateView", forControlEvents: .TouchUpInside)
    header.addSubview(button)
    
    
    let screenWidth = UIScreen.mainScreen().bounds.size.height
    self.tableView = UITableView(frame: CGRect(x: 0, y: 60, width: 320, height: screenWidth - 60))
    self.tableView!.dataSource = self
    
    self.view.addSubview(self.tableView!)
    self.view.addSubview(header)
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func showCreateView() {
    
    self.alertType = TodoAlertViewType.Create
    
    self.alert = UIAlertController(title: "Add an item...", message: nil, preferredStyle: .Alert)
    
    self.alert!.addTextFieldWithConfigurationHandler({ textField in
      textField.delegate = self
      textField.returnKeyType = .Done
    })
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    let createAction  = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alert?.addAction(createAction)
    alert?.addAction(cancelAction)
    
    self.presentViewController(alert, animated: true, completion: nil)
  }
}

extension ViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
    return self.todo.size
  }
  
  func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    
    let cell = TodoTableViewCell(style: .Default, reuseIdentifier: nil)
    cell.delegate = self
    
    cell.textLabel.text = self.todo[indexPath.row].title
    cell.tag = indexPath.row
    
    return cell
  }
}

extension ViewController: UITextFieldDelegate {
  
  func textFieldShouldEndEditing(textField: UITextField!) -> Bool {
    
    if let type = self.alertType {
      switch type {
      case .Create:
        let todo = TODO(title: textField.text)
        if self.todo.create(todo) {
          textField.text = nil
          self.tableView!.reloadData()
        }
      case let .Update(index):
        let todo = TODO(title: textField.text)
        if self.todo.update(todo, at: index) {
          textField.text = nil
          self.tableView!.reloadData()
        }
      case let .Destroy(index):
        break
      }
    }
    
    self.alert!.dismissViewControllerAnimated(false, completion: nil)
    return true
  }
}

extension ViewController: TodoTableViewCellDelegate {
  func updateTodo(index: Int) {
    self.alertType = TodoAlertViewType.Update(index)
    
    self.alert = UIAlertController(title: "Edit", message: nil, preferredStyle: .Alert)
    self.alert!.addTextFieldWithConfigurationHandler({ textField in
      textField.text = self.todo[index].title
      textField.delegate = self
      textField.returnKeyType = .Done
    })
    
    self.presentViewController(self.alert, animated: true, completion: nil)
  }
    
  func destroyTodo(index: Int) {
    self.alertType = TodoAlertViewType.Destroy(index)
    
    self.alert = UIAlertController(title: "Destroy", message: nil, preferredStyle: .Alert)
    self.alert!.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { action in
      self.todo.destroy(index)
      self.tableView!.reloadData()
    }))
    self.alert!.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    self.presentViewController(self.alert, animated: true, completion: nil)
  }
}
