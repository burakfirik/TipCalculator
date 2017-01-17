import Foundation

import UIKit

class Utils {
  static var sharedUtils = Utils()
  
  public var tipPercents:[Double] = [0.18, 0.20, 0.25]
  public let themeColors: [UIColor] = [ UIColor(red: 45 / 255.0, green: 119 / 255.0, blue: 239 / 255.0, alpha: 1), UIColor(red: 128 / 255.0, green: 174 / 255.0, blue: 247/255.0, alpha: 1)]
  
  public let themeNames = ["Dark Blue", "Light Blue"]
  private let limit = 300.0 // 5 min
  private let tipPercentIndexKey = "TipPercentKey"
  private let themeKey = "ThemeKey"
  private let rateKey = "RateKey"
  private let savedBill = "SavedBill"
  
  private var tipPercentIndex: Int = 0
  private var currentPercent: Double = 0.0
  private var currentThemeIndex: Int = 0
  private var currentThemeColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
  private var prevDate: NSDate = NSDate(timeIntervalSince1970: 0)
  private var prevBillAmount: Double = 0
  
  public func setTipPercentIndex(index:Int) {
    let defaults = UserDefaults.standard
    defaults.set(index, forKey: self.tipPercentIndexKey)
  }
  
  public func getTipPercentIndex() -> Int {
    let defaults = UserDefaults.standard
    let index = defaults.integer(forKey: self.tipPercentIndexKey)
    if (index < self.tipPercents.count && index >= 0) {
      return index;
    }
    return 0
  }
  
  public func getCurrentPercent() -> Double {
    return self.tipPercents[self.getTipPercentIndex()]
  }
  
  public func setCurrentThemeIndex(index: Int) {
    let defaults = UserDefaults.standard
    defaults.set(index, forKey:themeKey)
    defaults.synchronize()
  }
  
  public func getCurrentThemeIndex() -> Int{
    let defaults = UserDefaults.standard
    let index = defaults.integer(forKey:themeKey)
    if (index >= 0 && index < themeNames.count) {
      return index
    }
    return 0
  }
  
  public func getThemeColor() -> UIColor {
    return themeColors[getCurrentThemeIndex()]
  }
    
  public func setDate(date: Double) {
    let defaults = UserDefaults.standard
    defaults.set(date, forKey: rateKey)
    defaults.synchronize()
    prevDate = NSDate(timeIntervalSince1970: date)
  }
  
  public func getDate() -> NSDate {
    let defaults = UserDefaults.standard
    let timeSince = defaults.double(forKey: rateKey)
    return NSDate(timeIntervalSince1970: timeSince)
  }
  
  public func setBill(bill : Double) {
    let defaults = UserDefaults.standard
    defaults.set(bill, forKey: savedBill)
    defaults.synchronize()
  }
  
  public func getBill() -> Double {
    let defaults = UserDefaults.standard
    let bill =  defaults.double(forKey: savedBill)
    return bill
  }
  
  init() {
    if (prevDate.timeIntervalSinceNow > limit) {
      prevBillAmount = 0
    }
    prevDate = NSDate()
  }
}
