//
//  TodoTableViewCell.swift
//  ToDoApp
//
//  Created by Fumiya Mizuguchi on 2014/08/15.
//  Copyright (c) 2014年 Fumiya Mizuguchi. All rights reserved.
//

import UIKit

@objc protocol TodoTableViewCellDelegate {
  optional func updateTodo(index: Int)
  optional func destroyTodo(index: Int)
}

class TodoTableViewCell: UITableViewCell {
  
  weak var delegate: TodoTableViewCellDelegate?
  var haveButtonsDisplayed = false
  
  required init(coder: NSCoder) {
    fatalError("NSCoding not surpported")
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .None
    
    self.createView()
    
    let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: "showDeleteButton")
    swipeRecognizer.direction = .Left
    self.contentView.addGestureRecognizer(swipeRecognizer)
    
    self.contentView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: "hideDeleteButton"))
  }
  
  func showDeleteButton() {
    if !haveButtonsDisplayed {
      UIView.animateWithDuration(0.1, animations: {
        let size = self.contentView.frame.size
        let origin = self.contentView.frame.origin
        
        self.contentView.frame = CGRect(x: origin.x - 100, y: origin.y, width: size.width, height: size.height)
        
        }) { completed in self.haveButtonsDisplayed = true }
    }
  }
  
  func hideDeleteButton() {
    if haveButtonsDisplayed {
      UIView.animateWithDuration(0.1, animations: {
        let size = self.contentView.frame.size
        let origin = self.contentView.frame.origin
        
        self.contentView.frame = CGRect(x: origin.x + 100, y: origin.y, width: size.width, height: size.height)
      }) { completed in self.haveButtonsDisplayed = false}
    }
  }
  
  func createView() {
    let origin = self.frame.origin
    let size   = self.frame.size
    
    self.contentView.backgroundColor = UIColor.whiteColor()
    
    let updateButton = UIButton.buttonWithType(.System) as UIButton
    updateButton.frame = CGRect(x: size.width - 100, y: origin.y, width: 50, height: size.height)
    updateButton.backgroundColor = UIColor.lightGrayColor()
    updateButton.setTitle("Edit", forState: .Normal)
    updateButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    updateButton.addTarget(self, action: "updateTodo", forControlEvents: .TouchUpInside)
    
    let destroyButton = UIButton.buttonWithType(.System) as UIButton
    destroyButton.frame = CGRect(x: size.width - 50, y: origin.y, width: 50, height: size.height)
    destroyButton.backgroundColor = UIColor.redColor()
    destroyButton.setTitle("Delete", forState: .Normal)
    destroyButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    destroyButton.addTarget(self, action: "destroyTodo", forControlEvents: .TouchUpInside)
    
    self.backgroundView = UIView(frame: self.bounds)
    self.backgroundView.addSubview(updateButton)
    self.backgroundView.addSubview(destroyButton)
  }
  
  func updateTodo() {
    delegate?.updateTodo?(self.tag)
  }
  
  func destroyTodo() {
    delegate?.destroyTodo?(self.tag)
  }
}