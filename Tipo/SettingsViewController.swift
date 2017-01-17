import Foundation
import UIKit

class SettingsViewController: UIViewController {
  var defaultTipControl = UISegmentedControl()
  var themeControl = UISegmentedControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    defaultTipControl.tintColor =  Utils.sharedUtils.getThemeColor()
    themeControl.tintColor =  Utils.sharedUtils.getThemeColor()
  }
  
  override func loadView() {
    super.loadView()
    self.view.backgroundColor = UIColor.white

    addDefaultTipControl()
    addThemeControl()
  }
  
  func addThemeControl() {
    themeControl = UISegmentedControl(items: ["Dark","Light"])
    themeControl.sizeToFit()
    themeControl.backgroundColor = UIColor.clear
    themeControl.isUserInteractionEnabled = true
    themeControl.tintColor   = Utils.sharedUtils.getThemeColor()
    themeControl.frame = CGRect(x: 50, y: 50, width: 351, height: 20)

    self.view.addSubview(themeControl)
    
    themeControl.addTarget(self, action: #selector(SettingsViewController.themeControlValueChanged), for:.valueChanged)
    addThemeControlConstraint()
    themeControl.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func themeControlValueChanged() {
    let utils = Utils.sharedUtils
    let themeColor = themeControl.selectedSegmentIndex
    utils.setCurrentThemeIndex(index: themeColor)
    themeControl.tintColor =  utils.getThemeColor()
    defaultTipControl.tintColor = utils.getThemeColor()
  }
  
  func addThemeControlConstraint() {
    let leadingConstraint = NSLayoutConstraint(item: themeControl, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: themeControl.superview , attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 10)
    let trailingConstraint = NSLayoutConstraint(item: defaultTipControl.superview!, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: themeControl , attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 10)
    
    let topConstraint = NSLayoutConstraint(item: themeControl, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: defaultTipControl, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 50)
    NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint])
  }
  
  func addDefaultTipControl() {
    defaultTipControl = UISegmentedControl(items: ["18%", "20%", "25%"])
    defaultTipControl.sizeToFit()
    defaultTipControl.backgroundColor = UIColor.clear
    defaultTipControl.isUserInteractionEnabled = true
    defaultTipControl.tintColor   = Utils.sharedUtils.getThemeColor()
    defaultTipControl.frame = CGRect(x: 50, y: 50, width: 351, height: 20)

    self.view.addSubview(defaultTipControl)

    defaultTipControl.addTarget(self, action: #selector(SettingsViewController.tipControlValueChanged), for:.valueChanged)

    addTipControlConstraint()
    
    defaultTipControl.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func tipControlValueChanged() {
    let utils = Utils.sharedUtils
    let tipControlIndex = defaultTipControl.selectedSegmentIndex
    utils.setTipPercentIndex(index: tipControlIndex)
  }
  
  func addTipControlConstraint() {
    let heightConst = self.navigationController!.navigationBar.frame.size.height + 50
    let leadingConstraint = NSLayoutConstraint(item: defaultTipControl, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: defaultTipControl.superview , attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 10)
    let trailingConstraint = NSLayoutConstraint(item: defaultTipControl.superview!, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: defaultTipControl , attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 10)
    
    let topConstraint = NSLayoutConstraint(item: defaultTipControl, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: heightConst)
    
    NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint])
  }
}
