# ArrowPickerView

## Overview

ArrowPickerView provides nice way for selecting dropdown items when filling form.

![](image.png?raw=true "ArrowPickerView screenshot")

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
arrowPickerView.apperance.color = UIColor.green

let pickerArray = ["1", "2", "3", "4", "5"]
arrowPickerView.show(pickerArray: pickerArray, inButton: sender)

extension ViewController: ArrowPickerViewDelegate {
  
  func arrowPickerDone(row: Int, button: UIButton) {
  }
  
  func arrowPickerDidSelectRow(row: Int, button: UIButton) {
  }
}
```

## Customization
```Swift
    var width: Int 
    var height: Int 
    var topBarHeight: Int 
    var arrowWidth: Int 
    var arrowHeight: Int 
    var color: UIColor 
    var coverViewColor: UIColor 
    var doneButtonText: String 
    var labelAttributedParameters: [NSAttributedStringKey: Any] 
    var placeHolder: String? 
    var isNavigationControllerVisible: Bool 
    var spaceBetweenSelectedButtonAndSuperViewTop: Int
    var spaceBetweenPickerAndSelectedButton: Int
```
## Scroll Tip

When using this widget inside scrollView, please make sure you select View for your top constraint, see the below:

![](scroll_image.png?raw=true "ArrowPickerView screenshot")

## Example Project

An example project is included with this repo.  To run the example project, clone the repo and run.

## Author

David Tomić

## License

ArrowPickerView is available under the MIT license. See the LICENSE file for more info.
