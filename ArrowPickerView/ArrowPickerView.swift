//
//  ArrowPickerView.swift
//  Neostar
//
//  Created by David Tomic on 22/08/2017.
//  Copyright © 2017 Autozubak. All rights reserved.
//

import UIKit

protocol ArrowPickerViewDelegate: class {
  func arrowPickerDone(selectedRow: Int, inButton: UIButton)
  func arrowPickerDidSelectRow(selectedRow: Int, inButton: UIButton)
}

class ArrowPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
  
  // MARK: Variables
  weak var delegate: ArrowPickerViewDelegate?
  var apperance: ArrowPickerViewApparance!
  private let superView: UIView
  private let picker = UIPickerView()
  private let coverView = UIView()
  private var pickerArray: [String] = []
  private var selectedField: UIButton!
  private let arrowViewTag = 100
  
  // MARK: Init
  init(presentIn superView: UIView) {
    self.superView = superView
    super.init(frame: .zero)
    self.apperance = ArrowPickerViewApparance(pickerWidth: 250,
                                              pickerHeight: 250,
                                              topBarHeight: 40,
                                              arrowWidth: 15,
                                              arrowHeight: 10,
                                              color: superView.tintColor,
                                              coverViewColor: UIColor.white,
                                              doneButtonText: "Done",
                                              labelAttributedParameters: getDefaultAttributedParameters(),
                                              placeHolder: nil,
                                              isNavigationControllerVisible: true,
                                              spaceBetweenSelectedButtonAndSuperViewTop: 35,
                                              spaceBetweenPickerAndSelectedButton: 5)
    self.apperance.arrowPickerView = self
    setupView()
    NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: .UIDeviceOrientationDidChange, object: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func orientationChanged() {
    setupView()
  }
  
  private func getDefaultAttributedParameters() -> [NSAttributedStringKey: Any] {
    var attributedParameters = [NSAttributedStringKey: Any]()
    
    let style = NSMutableParagraphStyle()
    style.alignment = NSTextAlignment.center
    let font = UIFont.systemFont(ofSize: 15)
    attributedParameters[NSAttributedStringKey.paragraphStyle] = style
    attributedParameters[NSAttributedStringKey.font] = font
    
    return attributedParameters
  }
  
  // MARK: Setup
  func setupView() {
    for subView in self.subviews {
      subView.removeFromSuperview()
    }
    
    self.frame = CGRect(x: Int(superViewWidth/2 - CGFloat(apperance.width/2)), y: Int(pickerStartPosition), width: apperance.width, height: apperance.height)
    self.addSubview(createArrowView())
    
    let mainViewUnderArrow = createMainViewUnderArrow()
    self.addSubview(mainViewUnderArrow)
    
    let topBarView = createTopBarView()
    mainViewUnderArrow.addSubview(topBarView)
    
    let pickerDoneButton = createDoneButton()
    topBarView.addSubview(pickerDoneButton)
    
    picker.frame = CGRect(x: 0, y: apperance.topBarHeight, width: apperance.width, height: apperance.height - apperance.topBarHeight)
    picker.delegate = self
    picker.dataSource = self
    mainViewUnderArrow.addSubview(picker)
    
    coverView.alpha = 0
    coverView.backgroundColor = apperance.coverViewColor
    if coverView.superview == nil {
      superView.addSubview(coverView)
      superView.addSubview(self)
    }
  }
  
  private var pickerStartPosition: CGFloat {
    return superView.bounds.height
  }
  
  private var superViewWidth: CGFloat {
    return superView.bounds.width
  }
  
  private var superViewHeight: CGFloat {
    return superView.bounds.height
  }
  
  private func createArrowView() -> UIView {
    let topArrow = TopArrowView(frame: CGRect(x: apperance.width/2 - apperance.arrowWidth/2, y: 0, width: apperance.arrowWidth, height: apperance.arrowHeight))
    topArrow.tag = arrowViewTag
    topArrow.color = apperance.color
    topArrow.backgroundColor = UIColor.clear
    return topArrow
  }
  
  private func updatePositions(selectButtonPosition: CGPoint, selectButtonWidth: CGFloat) {
    //update picker position
    var pickerFrame = self.frame
    pickerFrame.origin.x = selectButtonPosition.x + (selectButtonWidth/2) - (self.frame.width/2)
    if pickerFrame.origin.x < 20 {
      pickerFrame.origin.x = 20
    } else if pickerFrame.maxX > superView.bounds.width {
      pickerFrame.origin.x = superView.bounds.width - self.frame.width - 20
    }
    self.frame = pickerFrame
    
    // update arrow position
    let arrow = self.viewWithTag(arrowViewTag)!
    var arrowFrame = arrow.frame
    arrowFrame.origin.x = selectButtonPosition.x + (selectButtonWidth/2) - (self.frame.origin.x + arrow.frame.width/2)
    arrow.frame = arrowFrame
  }
  
  private func createMainViewUnderArrow() -> UIView {
    let mainViewUnderArrow = UIView(frame: CGRect(x: 0, y: apperance.arrowHeight, width: apperance.width, height: apperance.height - apperance.arrowHeight))
    mainViewUnderArrow.backgroundColor = UIColor.white
    mainViewUnderArrow.layer.cornerRadius = 10
    mainViewUnderArrow.clipsToBounds = true
    mainViewUnderArrow.layer.borderColor = apperance.color.cgColor
    mainViewUnderArrow.layer.borderWidth = 0.5
    return mainViewUnderArrow
  }
  
  private func createTopBarView() -> UIView {
    let topBarView = UIView(frame: CGRect(x: 0, y: 0, width: apperance.width, height: apperance.topBarHeight))
    topBarView.backgroundColor = apperance.color
    return topBarView
  }
  
  private func createDoneButton() -> UIButton {
    let pickerDoneButton = UIButton(frame: .zero)
    pickerDoneButton.addTarget(self, action: #selector(pickerDone), for: .touchUpInside)
    pickerDoneButton.setTitle(apperance.doneButtonText, for: .normal)
    pickerDoneButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    pickerDoneButton.sizeToFit()
    let yPosition = (CGFloat(apperance.topBarHeight) - pickerDoneButton.frame.height)/2
    let frame = CGRect(x: 10, y: yPosition, width: pickerDoneButton.frame.width, height: pickerDoneButton.frame.height)
    pickerDoneButton.frame = frame
    return pickerDoneButton
  }
  
  
  // MARK: Show picker
  func show(pickerArray: [String], inButton selectedField: UIButton) {
    self.selectedField = selectedField
    self.pickerArray = pickerArray
    if let placeHolder = apperance.placeHolder {
      self.pickerArray.insert(placeHolder, at: 0)
    }
    
    picker.reloadAllComponents()
    setPickerPosition(currentValue: selectedField.currentTitle)
    
    let statusBarOffset: CGFloat = 20
    let navBarOffset: CGFloat = apperance.isNavigationControllerVisible ? 44 : 0
    
    let initialOffset = statusBarOffset + navBarOffset + CGFloat(apperance.spaceBetweenSelectedButtonAndSuperViewTop)
    let selectedFieldOffset = selectedField.superview!.convert(selectedField.frame.origin, to: superView)
    updatePositions(selectButtonPosition: selectedFieldOffset, selectButtonWidth: selectedField.frame.width)
    
    superView.bounds.origin = CGPoint(x: 0, y: (selectedFieldOffset.y - initialOffset))
    
    var frame = self.frame
    frame.origin.y = selectedFieldOffset.y + selectedField.frame.height + CGFloat(apperance.spaceBetweenPickerAndSelectedButton)
    setWhiteCoverViewFrame(frame: frame)
    
    UIView.animate(withDuration: 0.4, animations: {
      self.frame = frame
    }) { (finished) in
      UIView.animate(withDuration: 0.2, animations: {
        self.coverView.alpha = 1
      })
    }
  }
  
  private func setWhiteCoverViewFrame(frame: CGRect) {
    var whiteCoverViewFrame = superView.frame
    whiteCoverViewFrame.origin.y = frame.minY
    coverView.frame = whiteCoverViewFrame
  }
  
  private func setPickerPosition(currentValue: String?) {
    let index = pickerArray.index(of: currentValue ?? "")
    if index != nil {
      picker.selectRow(index!, inComponent: 0, animated: false)
    } else {
      picker.selectRow(0, inComponent: 0, animated: false)
    }
  }
  
  
  
  // MARK: Hide picker
  @objc func pickerDone() {
    hide()
    if pickerArray.count > 0 {
      let row = picker.selectedRow(inComponent: 0)
      selectedField?.setTitle(pickerArray[row], for: .normal)
      delegate?.arrowPickerDone(selectedRow: row, inButton: selectedField)
    }
  }
  
  private func hide() {
    self.coverView.alpha = 0
    superView.bounds.origin = CGPoint(x: 0, y: 0)
    
    var pickerFrame = self.frame
    pickerFrame.origin.y = pickerStartPosition
    
    UIView.animate(withDuration: 0.4, animations: {
      self.frame = pickerFrame
    }) { (finished) in
    }
  }
  

  // MARK: UIPicker delegate
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerArray.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerArray[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    delegate?.arrowPickerDidSelectRow(selectedRow: row, inButton: selectedField)
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

    var label: UILabel
    if let view = view as? UILabel {
      label = view
    }else {
      label = UILabel()
    }

    let attributedText = NSMutableAttributedString(string: pickerArray[row], attributes: apperance.labelAttributedParameters)
    label.attributedText = attributedText
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5

    return label
  }
  
  
  // MARK: ArrowPickerViewApparance
  class ArrowPickerViewApparance {
    var width: Int { didSet { arrowPickerView.setupView() } }
    var topBarHeight: Int { didSet { arrowPickerView.setupView() } }
    var arrowWidth: Int { didSet { arrowPickerView.setupView() } }
    var arrowHeight: Int { didSet { arrowPickerView.setupView() } }
    var height: Int { didSet { arrowPickerView.setupView() } }
    var color: UIColor { didSet { arrowPickerView.setupView() } }
    var coverViewColor: UIColor { didSet { arrowPickerView.setupView() } }
    var doneButtonText: String { didSet { arrowPickerView.setupView() } }
    var labelAttributedParameters: [NSAttributedStringKey: Any] { didSet { arrowPickerView.setupView() } }
    var placeHolder: String? { didSet { arrowPickerView.setupView() } }
    var isNavigationControllerVisible: Bool { didSet { arrowPickerView.setupView() } }
    var spaceBetweenSelectedButtonAndSuperViewTop: Int { didSet { arrowPickerView.setupView() } }
    var spaceBetweenPickerAndSelectedButton: Int { didSet { arrowPickerView.setupView() } }
    
    weak var arrowPickerView: ArrowPickerView!
    
    init(pickerWidth: Int, pickerHeight:Int, topBarHeight: Int, arrowWidth: Int, arrowHeight: Int, color: UIColor, coverViewColor:UIColor, doneButtonText: String, labelAttributedParameters: [NSAttributedStringKey: Any], placeHolder: String?,  isNavigationControllerVisible: Bool, spaceBetweenSelectedButtonAndSuperViewTop: Int, spaceBetweenPickerAndSelectedButton: Int) {
      self.width = pickerWidth
      self.topBarHeight = topBarHeight
      self.arrowWidth = arrowWidth
      self.arrowHeight = arrowHeight
      self.height = pickerHeight + topBarHeight + arrowHeight
      self.color = color
      self.coverViewColor = coverViewColor
      self.doneButtonText = doneButtonText
      self.labelAttributedParameters = labelAttributedParameters
      self.placeHolder = placeHolder
      self.isNavigationControllerVisible = isNavigationControllerVisible
      self.spaceBetweenSelectedButtonAndSuperViewTop = spaceBetweenSelectedButtonAndSuperViewTop
      self.spaceBetweenPickerAndSelectedButton = spaceBetweenPickerAndSelectedButton
    }
  }
  
  // MARK: TopArrowView
  class TopArrowView: UIView {
    var color:UIColor = UIColor.white
    
    override func draw(_ rect: CGRect) {
      let width = bounds.size.width
      let height = bounds.size.height
      
      color.set()
      
      let path = UIBezierPath()
      path.lineJoinStyle = .round
      path.lineCapStyle = .round
      path.move(to: CGPoint(x: 0, y: height))
      path.addLine(to: CGPoint(x: width/2, y: 0))
      path.addLine(to: CGPoint(x: width, y: height))
      path.addLine(to: CGPoint(x: 0, y: height))
      path.fill()
    }
  }
}
