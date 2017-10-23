//
//  ViewController.swift
//  ArrowPickerView
//
//  Created by David Tomic on 20/10/2017.
//  Copyright © 2017 Autozubak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var arrowPickerView: ArrowPickerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    arrowPickerView = ArrowPickerView(rootView: self.view, delegate: self)
    arrowPickerView.apperance.placeHolder = "--"
  }
  
  
  @IBAction func selectValue(_ sender: FormButton) {
    let pickerArray = getPickerArray(button: sender)
    arrowPickerView.show(pickerArray: pickerArray, inButton: sender)
  }
  
  private func getPickerArray(button: FormButton) -> [String] {
    if button.formType == "type" {
      return ["Type1", "Type2", "Type3", "Type4", "Type5"]
    } else if button.formType == "yearFrom" || button.formType == "yearTo" {
      return ["2013", "2014", "2015", "2016", "2017"]
    }
    return [""]
  }

}

extension ViewController: ArrowPickerViewDelegate {
  
  func arrowPickerDone(row: Int, button: UIButton) {
    let b = button as! FormButton
    print("arrowPickerDone row: \(row), button: \(String(describing: b.formType))")
  }
  
  func arrowPickerDidSelectRow(row: Int, button: UIButton) {
    let formButton = button as! FormButton
    if formButton.formType == "yearFrom" || formButton.formType == "yearTo" {
      let value = getPickerArray(button: formButton)[row]
      formButton.setTitle(value, for: .normal)
    }
  }
}

