import UIKit

class TipViewController: UIViewController {
  let SCREEN_SIZE = UIScreen.main.bounds

  var tipControl = UISegmentedControl()
  var billField = UITextField()

  var tipLabel = UILabel()
  var totalLabel = UILabel()
  var plusLabel = UILabel()
  var equalLabel = UILabel()

  var resultView = UIView(frame: CGRect(x: 0, y: 160, width: 370, height: 160))
  var tipView = UIView()
  var topBillFieldConsraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white

    addNavigationBarButton()
    addResultView()
    addBillField()
    addTipControl()
    addTipView()

    let utils = Utils.sharedUtils

    let tipPercent = utils.getTipPercentIndex()
    tipControl.selectedSegmentIndex = tipPercent

    self.resultView.alpha = 0

    tipLabel.numberOfLines = 1
    tipLabel.adjustsFontSizeToFitWidth = true

    totalLabel.numberOfLines = 1
    totalLabel.adjustsFontSizeToFitWidth = true

    let locale = Locale.current
    let currencySymbol = locale.currencySymbol

    billField.placeholder = currencySymbol!

    let savedAmount = utils.getBill()

    if savedAmount > 0 {
      if floor(savedAmount) == savedAmount {
        billField.text = "\(Int(floor(savedAmount)))"
      } else {
        billField.text = "\(savedAmount)"
      }
    }
    billField.becomeFirstResponder()
  }
  
  public func addTipView() {
    tipView.addSubview(totalLabel)
    tipView.addSubview(tipLabel)
    tipView.addSubview(plusLabel)
    tipView.addSubview(equalLabel)
    resultView.addSubview(tipView)
    
    plusLabel.text = "+"
    equalLabel.text = "="
    equalLabel.font = UIFont (name:"HelveticaNeue-Bold", size: 35.0)
    totalLabel.font = UIFont (name:"HelveticaNeue-Bold", size: 35.0)

    totalLabel.textColor = UIColor.white
    equalLabel.textColor = UIColor.white
    plusLabel.textColor = UIColor.white
    tipLabel.textColor = UIColor.white
    
    totalLabel.textAlignment = NSTextAlignment.right
    tipLabel.textAlignment = NSTextAlignment.right
   
    tipView.backgroundColor = Utils.sharedUtils.getThemeColor()
    addTipViewConstraint()
    addTipLabelConstraint()
    resultView.addSubview(tipView)
    
    totalLabel.translatesAutoresizingMaskIntoConstraints = false
    tipLabel.translatesAutoresizingMaskIntoConstraints = false
    plusLabel.translatesAutoresizingMaskIntoConstraints = false
    equalLabel.translatesAutoresizingMaskIntoConstraints = false
    tipView.translatesAutoresizingMaskIntoConstraints = false
   
    tipControl.addTarget(self, action: #selector(TipViewController.calculateTip), for: UIControlEvents.valueChanged)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tipControl.selectedSegmentIndex = Utils.sharedUtils.getTipPercentIndex()
    self.tipControl.tintColor = Utils.sharedUtils.getThemeColor()
    tipView.backgroundColor = Utils.sharedUtils.getThemeColor()
    calculateTip()
  }

  public func addTipLabelConstraint() {
    let plustLabelTopConstraint = NSLayoutConstraint(item: plusLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: plusLabel.superview, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 15)
    let plusLabelLeadingConstraint = NSLayoutConstraint(item: plusLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: plusLabel.superview, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 35)
    let tipLabelLeadingConstraint = NSLayoutConstraint(item: tipLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: tipLabel.superview, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 70)
    let tipLabelTrailingConstraint = NSLayoutConstraint(item: tipLabel.superview!, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: tipLabel, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 10)
    let tipLabelCenterYConstraint = NSLayoutConstraint(item: tipLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: plusLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
    let totalLabelLeadingConstraint = NSLayoutConstraint(item: totalLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: tipLabel, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
    let totalLabelTrailingConstraint = NSLayoutConstraint(item: totalLabel.superview!, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem:totalLabel , attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 10)
    let totalLabelCenterYConstraint = NSLayoutConstraint(item: totalLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: equalLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
    let eqLabelTopConstraint = NSLayoutConstraint(item: equalLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: plusLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 15)
    let eqLabelCenterConstraint = NSLayoutConstraint(item: equalLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: plusLabel, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
    NSLayoutConstraint.activate([plustLabelTopConstraint,plusLabelLeadingConstraint,tipLabelLeadingConstraint,tipLabelTrailingConstraint, tipLabelCenterYConstraint,totalLabelLeadingConstraint,totalLabelTrailingConstraint,totalLabelCenterYConstraint,eqLabelTopConstraint,eqLabelCenterConstraint])
  }
  
  public func addTipViewConstraint() {
    let leadingTipViewConstraint = NSLayoutConstraint(item: tipView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: tipControl.superview, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
    let trailingTipViewConstraint = NSLayoutConstraint(item: tipView.superview!, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: tipView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
    let bottomTipViewConstraint = NSLayoutConstraint(item: tipView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: tipView.superview, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
    let topTipViewConstraint = NSLayoutConstraint(item: tipView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: tipControl, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant:7)
    NSLayoutConstraint.activate([leadingTipViewConstraint, trailingTipViewConstraint, bottomTipViewConstraint, topTipViewConstraint])
    tipView.translatesAutoresizingMaskIntoConstraints = false
  }

  
  public func addTipControl() {
    tipControl = UISegmentedControl(items: ["18%", "20%", "25%"])
    tipControl.sizeToFit()
    tipControl.backgroundColor = UIColor.clear
    tipControl.isUserInteractionEnabled = true
    tipControl.tintColor   = Utils.sharedUtils.getThemeColor()
    tipControl.frame = CGRect(x: 12, y: 8, width: 351, height: 20)

    resultView.addSubview(tipControl)

    addTipControlConstraint()

    tipControl.translatesAutoresizingMaskIntoConstraints = false
  }
  
  public func addTipControlConstraint() {
    let leadingTipControlConstraint = NSLayoutConstraint(item: tipControl, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: tipControl.superview, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 10)
    _ = NSLayoutConstraint(item: tipControl.superview!, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: tipControl, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 10)
    let topTipControlConstraint = NSLayoutConstraint(item: tipControl, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: tipControl.superview, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 7)
    let widthTipControlConstraint = NSLayoutConstraint(item: tipControl, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.width, multiplier: 0, constant: SCREEN_SIZE.size.width - 20)
    NSLayoutConstraint.activate([leadingTipControlConstraint, topTipControlConstraint, topTipControlConstraint, widthTipControlConstraint])
    
  }
  
  public func addResultView() {
    self.view.addSubview(resultView)

    resultView.backgroundColor = UIColor.clear

    addConstraintResultView()

    resultView.translatesAutoresizingMaskIntoConstraints = false
  }
  public func addBillField() {
    self.view.addSubview(billField)

    billField.textAlignment = NSTextAlignment.right
    billField.backgroundColor = UIColor.clear
    billField.font =  UIFont (name:"HelveticaNeue", size: 50.0)
    billField.keyboardType = UIKeyboardType.decimalPad
    billField.addTarget(self, action: #selector(TipViewController.calculateTip), for: UIControlEvents.editingChanged)
    billField.addTarget(self, action: #selector(TipViewController.calculateTip), for: UIControlEvents.editingDidEnd)

    addConstraintsBillField()

    billField.translatesAutoresizingMaskIntoConstraints = false
  }
 
  public func addConstraintsBillField() {
    let leadingBillFieldConsraint = NSLayoutConstraint(item: billField, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 8)
    let trailingBillFieldConsraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: billField, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 8)
    topBillFieldConsraint = NSLayoutConstraint(item: billField, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: topLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 200)
    let heightBillFieldConsraint = NSLayoutConstraint(item: billField, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.height, multiplier: 0, constant: 60)
    NSLayoutConstraint.activate([leadingBillFieldConsraint, trailingBillFieldConsraint, topBillFieldConsraint, heightBillFieldConsraint])
  }
  
  public func addConstraintResultView() {
    let leadingResultViewConsraint = NSLayoutConstraint(item: resultView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
    let trailingResultViewConsraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: resultView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
    let topResultViewConsraint = NSLayoutConstraint(item: resultView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: topLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 161)
    let heightResultViewConstraint = NSLayoutConstraint(item: resultView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 161)
    NSLayoutConstraint.activate([leadingResultViewConsraint, trailingResultViewConsraint, topResultViewConsraint, heightResultViewConstraint])
  }
  
  
  func calculateTip() {
    let selectedIndex = self.tipControl.selectedSegmentIndex

    Utils.sharedUtils.setTipPercentIndex(index: selectedIndex)

    
    let bill = Double(billField.text!) ?? 0

    Utils.sharedUtils.setBill(bill: bill)

    let tip = bill * Utils.sharedUtils.getCurrentPercent()
    let total = bill + tip
    let formatter = NumberFormatter()

    formatter.numberStyle = .currency

    tipLabel.text = formatter.string(from: NSNumber(value: tip))
    totalLabel.text = formatter.string(from: NSNumber(value: total))
    
    if !billField.text!.isEmpty {
      UIView.animate(withDuration: 0.4, animations: {
        self.resultView.alpha = 1
      })
      topBillFieldConsraint.constant = 40
      UIView.animate(withDuration: 0.2, animations: {
        self.view.layoutIfNeeded()
      })
    }
    else {
      UIView.animate(withDuration: 0.4, animations: {
        self.resultView.alpha = 0
      })
      topBillFieldConsraint.constant = 200
      UIView.animate(withDuration: 0.2, animations: {
        self.view.layoutIfNeeded()
      })
    }
    self.view.setNeedsLayout()
  }

  public func addNavigationBarButton() {
    let sharedUtils = Utils.sharedUtils
    self.navigationController?.navigationBar.backgroundColor = sharedUtils.themeColors[0]
    navigationItem.title = "Tip Calculator"
    let rightButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(TipViewController.settingsButtonClicked))
    self.navigationItem.rightBarButtonItem = rightButton
  }
 
  func settingsButtonClicked() {
    let settingViewController = SettingsViewController()
    navigationController?.pushViewController(settingViewController, animated: true)
  }
}

