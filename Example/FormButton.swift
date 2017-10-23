//
//  FormButton.swift
//  ArrowPickerView
//
//  Created by David Tomic on 23/10/2017.
//  Copyright © 2017 Autozubak. All rights reserved.
//

import UIKit

class FormButton: UIButton {
  
  @IBInspectable var formType: String?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    self.layer.borderColor = UIColor(red: 206/255.0, green: 206/255.0, blue: 206/255.0, alpha: 1.0).cgColor
    self.layer.borderWidth = 1
    self.layer.cornerRadius = 4
  }
  
}
