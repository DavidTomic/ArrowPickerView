# ArrowPickerView

## Overview

ArrowPickerView provides nice way for selecting dropdown items when filling form.

## Requirements
* iOS10

## Installation with CocoaPods

ArrowPickerView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ArrowPickerView"
```

## Usage

```Swift
import ArrowPickerView

let arrowPickerView = ArrowPickerView(rootView: self.view, delegate: self)
let pickerArray = ["1", "2", "3", "4", "5"]
arrowPickerView.show(pickerArray: pickerArray, inButton: sender)

extension ViewController: ArrowPickerViewDelegate {
  
  func arrowPickerDone(row: Int, button: UIButton) {
  }
  
  func arrowPickerDidSelectRow(row: Int, button: UIButton) {
  }

```

## Example Project

An example project is included with this repo.  To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

David Tomić

## License

ArrowPickerView is available under the MIT license. See the LICENSE file for more info.
