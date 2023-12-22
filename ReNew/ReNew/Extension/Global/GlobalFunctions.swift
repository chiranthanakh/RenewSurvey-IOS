//
//  GlobalFunctions.swift
//  RecordingStudio
//
//  Created by mac on 16/01/2020.
//  Copyright © 2019 Differenzsystem Pvt. LTD. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import MobileCoreServices

func executeBackground<T>(_ block: @escaping () -> (T?), notifyMain completion: @escaping ((_: T?) -> ())) {
    DispatchQueue.global(qos: .background).async {
        let result: T? = block()
        DispatchQueue.main.async {
            completion(result)
        }
    }
}

func delay(seconds: Double, execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: execute)
}

public func getStoryboard(storyboardName: String) -> UIStoryboard {
    return UIStoryboard(name: storyboardName, bundle: nil)
}

public func loadVC(strStoryboardId: String, strVCId: String) -> UIViewController {
    
    let vc = getStoryboard(storyboardName: strStoryboardId).instantiateViewController(withIdentifier: strVCId)
    return vc
}

func concat(_ strings: [String?], separator: String = " ") -> String? {
    let filtered = strings.compactMap({ $0 })
    guard !filtered.isEmpty else { return nil }
    return filtered.joined(separator: separator)
}

func isEmptyString(_ string: String?) -> Bool {
    guard let string = string else { return true }
    return string.isEmpty
}

func saveValueInNSUserDefaults(_ value:AnyObject?, forKey key:String) {
    UserDefaults.standard.set(value, forKey: key)
    
    UserDefaults.standard.synchronize()
}

func getValueFromNSUserDefaults(key:String) -> Any? {
    let val =  UserDefaults.standard.value(forKey: key)
    return val
}

func convertVideoToLowQuailty(withInputURL inputURL: URL?, outputURL: URL?, handler: @escaping (AVAssetExportSession?) -> Void) {
    if let outputURL = outputURL {
        try? FileManager.default.removeItem(at: outputURL)
    }
    var asset: AVURLAsset? = nil
    if let inputURL = inputURL {
        asset = AVURLAsset(url: inputURL, options: nil)
    }
    var exportSession: AVAssetExportSession? = nil
    if let asset = asset {
        exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
    }
    exportSession?.outputURL = outputURL
    exportSession?.outputFileType = .mov
    exportSession?.exportAsynchronously(completionHandler: {
        handler(exportSession)
    })    
}

func getImageHightWithScale(height:CGFloat,width:CGFloat) -> CGFloat {
    if height > 450 {
        return 430
    }
    else {
        return height
    }
}
func format(with mask: String, phone: String) -> String {
    let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    var result = ""
    var index = numbers.startIndex // numbers iterator

    // iterate over the mask characters until the iterator of numbers ends
    for ch in mask where index < numbers.endIndex {
        if ch == "X" {
            // mask requires a number in this place, so take the next one
            result.append(numbers[index])

            // move numbers iterator to the next index
            index = numbers.index(after: index)

        } else {
            result.append(ch) // just append a mask character
        }
    }
    return result
}

// MARK:-
@IBDesignable
extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    @IBInspectable
    /// Should the corner be as circle
    public var circleCorner: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
        }
        set {
            cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = circleCorner ? min(bounds.size.height, bounds.size.width) / 2 : newValue
            //abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    @IBInspectable
    /// Border color of view; also inspectable from Storyboard.
    public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable
    /// Border width of view; also inspectable from Storyboard.
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    /// Shadow color of view; also inspectable from Storyboard.
    public var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    /// Shadow offset of view; also inspectable from Storyboard.
    public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    /// Shadow opacity of view; also inspectable from Storyboard.
    public var shadowOpacity: Double {
        get {
            return Double(layer.shadowOpacity)
        }
        set {
            layer.shadowOpacity = Float(newValue)
        }
    }
    
    @IBInspectable
    /// Shadow radius of view; also inspectable from Storyboard.
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    /// Shadow path of view; also inspectable from Storyboard.
    public var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set {
            layer.shadowPath = newValue
        }
    }
    
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowShouldRasterize: Bool {
        get {
            return layer.shouldRasterize
        }
        set {
            layer.shouldRasterize = newValue
        }
    }
    
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowRasterizationScale: CGFloat {
        get {
            return layer.rasterizationScale
        }
        set {
            layer.rasterizationScale = newValue
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    // Drop Shadow to UIView
    func dropShadow(shadowWidth: Int, shadowHeight: Int, color: UIColor = UIColor.black, opacity: Float = 0.5, shadowRadius: CGFloat = 5) {
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
        self.layer.shadowRadius = shadowRadius
    }
    
}

// MARK: - UserDefaults's Extension

extension UserDefaults {
    class var isUserLogin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKey.kIsLoggedIn)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kIsLoggedIn)
        }
    }
    
    class var fcmToken: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKey.kFcmToken) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kFcmToken)
        }
    }
    
    class var kLastAsyncDate: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKey.kFcmToken) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kFcmToken)
        }
    }
}

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element {
        return reduce(.zero, +)
    }
}

extension Double {
    
    func convertDoubletoString(digits : Int) -> String {
        let num = self
        return String(format: "%.\(digits)f", num)
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        /*print("\(self * divisor)")
        print("\(self * divisor.rounded())")
        print("\(self * divisor.rounded() / divisor)")*/
        return (self * divisor).rounded() / divisor
    }
    
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
    
    func convertToInt() -> Int {
        return Int(self)
    }
}

extension UIScrollView {
   func scrollToBottom(animated: Bool) {
     if self.contentSize.height < self.bounds.size.height { return }
     let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
     self.setContentOffset(bottomOffset, animated: animated)
  }
}

extension String {
    
    func decodingEmoji() -> String {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII) ?? self
    }
    
    func encodindEmoji() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    func isValidString() -> Bool {
        return self.removeSpaceAndNewLine().isEmpty
    }
    
    func removeSpaceAndNewLine() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
   /* func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }*/
    /**
     This method is used to  get the width of string.
     - Parameter font : UIFont of the string.
     - Returns: CGFloat - width of the string
     */
    func textWidth(font: UIFont?) -> CGFloat {
        let attributes = font != nil ? [NSAttributedString.Key.font: font] : [:]
        return self.size(withAttributes: attributes as [NSAttributedString.Key : Any]).width
    }
    
    var doubleValue: Double {
        return Double(self) ?? 0
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    public var trimWhiteSpace: String {
        get {
            return self.trimmingCharacters(in: .whitespaces)
        }
    }
    
    /**
     This method is used to set attributed placeholder of textfiled.
     - Parameters:
     - range: Range of string
     - string: String that needs to replace in range
     */
    func replacingCharacters(in range: NSRange, with string: String) -> String {
        let newRange = self.index(self.startIndex, offsetBy: range.lowerBound)..<self.index(self.startIndex, offsetBy: range.upperBound)
        return self.replacingCharacters(in: newRange, with: string)
    }
    
    func getDateFromString(format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func getCurrentTimeZoneDateFromString(format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .current//NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func getUTCToLocalDateFromString(format: String,conevertString : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let utcdate = dateFormatter.date(from: self) ?? Date()
        dateFormatter.timeZone = .current//TimeZone(identifier: TimeZone.current.abbreviation() ?? "GMT")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = conevertString
        print(dateFormatter.string(from: utcdate))
        
        return dateFormatter.string(from: utcdate)
    }
    
    func getUTCToLocalDatePastYearFromString(format: String,conevertString : String,convertyearstr : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let utcdate = dateFormatter.date(from: self) ?? Date()
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.abbreviation() ?? "GMT")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = conevertString
        print(dateFormatter.string(from: utcdate))
        
        var strconvertdate = dateFormatter.string(from: utcdate)
        
        let cyear : Int = Date().getCurrentYear()
        let serveryear = utcdate.getCurrentYear()
        
        if cyear == serveryear {
            dateFormatter.dateFormat = convertyearstr
            strconvertdate = dateFormatter.string(from: utcdate)
        }
        
        return strconvertdate
    }
    
   
    func getStringToDateToStringToDate(firstformat: String,secondformat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = firstformat
        let fdate = dateFormatter.date(from: self) ?? Date()
        let strfdate = fdate.getFormattedString(format: secondformat)
        dateFormatter.dateFormat = secondformat
        return dateFormatter.date(from: strfdate) ?? Date()
    }
    
    func getFormmattedDateFromString(format: String) -> String {
        let date = self.getDateFromString(format: format)
        return date.getFormattedString(format: format)
    }

    func getTimeStampToDate(dateFormate: String) -> String {
        let date = Date(timeIntervalSince1970: Double(self) ?? 0.0)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = dateFormate //Specify your format that you want
        return dateFormatter.string(from: date)
    }
    /**
     This method is used to generate base64 string.
     */
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    
    func convertBase64ToImage() -> UIImage? {
        if let dataDecoded = Data(base64Encoded: self, options: .ignoreUnknownCharacters), let decodedimage = UIImage(data: dataDecoded) {
            return decodedimage
        }
        return nil
    }
    /**
     This method is used to validate email field.
     - Returns: Return boolen value to indicate email is valid or not
     */
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{1,}(\\.[A-Za-z]{1,}){0,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidAlphNumericString() -> Bool {
        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 ")
        return self.rangeOfCharacter(from: set.inverted) == nil
    }
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    
    func getUTCToLocalDateFromStringMainTarget(format: String,conevertString : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "IST") as TimeZone?
        
        let utcdate = dateFormatter.date(from: self) ?? Date()
        dateFormatter.timeZone = .current//TimeZone(identifier: TimeZone.current.abbreviation() ?? "GMT")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = conevertString
        print(dateFormatter.string(from: utcdate))
        
        return dateFormatter.string(from: utcdate)
    }
    
    func toJsonArray() -> [[String:Any]] {
        let data = self.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [[String:Any]]
            {
               print(jsonArray) // use the json here
                return jsonArray
            } else {
                print("bad json")
                return [[String:Any]]()
            }
        } catch let error as NSError {
            print(error)
            return [[String:Any]]()
        }
    }
    
    func toJson() -> [String:Any] {
        let data = self.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
            {
               print(jsonArray) // use the json here
                return jsonArray
            } else {
                print("bad json")
                return [String:Any]()
            }
        } catch let error as NSError {
            print(error)
            return [String:Any]()
        }
    }

    func toFragmentsAllowedJson() -> [[String:Any]] {
        let data = self.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .fragmentsAllowed) as? [[String:Any]]
            {
//               print(jsonArray) // use the json here
                return jsonArray
            } else {
                print("bad json")
                return [[String:Any]]()
            }
        } catch let error as NSError {
            print(error)
            return [[String:Any]]()
        }
    }
    
    func toFragmentsAllowedSingleJson() -> [String:Any] {
        let data = self.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .fragmentsAllowed) as? [String:Any]
            {
                //               print(jsonArray) // use the json here
                return jsonArray
            } else {
                print("bad json")
                return [String:Any]()
            }
        } catch let error as NSError {
            print(error)
            return [String:Any]()
        }
    }
    
    func makeCall() {
        if let url = URL(string: "tel://\(self)") {
            UIApplication.shared.open(url)
        }
    }
    
    func openWhatsApp() {
        if let url = URL(string: "https://api.whatsapp.com/send?phone=\(self)") {
            UIApplication.shared.open(url)
        }
    }
    
    func openMessageApp() {
        if let url = URL(string: "sms://\(self)") {
            UIApplication.shared.open(url)
        }
    }
    
    func openEmailApp() {
        if let url = URL(string: "mailto:\(self)") {
            UIApplication.shared.open(url)
        }
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
    func isDate12HourPast() -> Bool {
        
        let dt = self.getDateFromString(format: "yyyy-MM-dd HH:mm:ss")
            
        // before it's 2 now it's 14
        return Date().localDate() > dt.advanced(by: Double(14) * 60.0 * 60.0)
    }
    
    func base64ToImage() -> UIImage? {
        if let dataDecoded : Data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: dataDecoded)
        }
        return nil
    }
}


extension UIButton {
    /**
     This method is used to show shadow.
     - Parameters:
     - color: Color of shadow
     - opacity: Opacity of shadow
     - offset: Shadow offset
     - radius: Shadow radius
     */
    func addButtonShadow(with color: UIColor = .gray, opacity: Float = 1.0, offset: CGSize = CGSize(width: 0, height: 1), radius : CGFloat = 1.0) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
}


extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
            
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
            
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}

extension UITextField {
    
    /**
     This method is used to show shadow.
     - Parameters:
     - color: Color of shadow
     - opacity: Opacity of shadow
     - offset: Shadow offset
     - radius: Shadow radius
     */
    func addTextFiledShadow(with color: UIColor = .gray, opacity: Float = 1.0, offset: CGSize = CGSize(width: 0, height: 1), radius : CGFloat = 1.0) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
}
extension Array where Element: Equatable {
    func removingDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

//extension Array {
    
//}

//MARK: - Dictionary
extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: []) else {
            return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
}

extension Int {

    func formatUsingAbbrevation () -> String {
        let numFormatter = NumberFormatter()

        typealias Abbrevation = (threshold:Double, divisor:Double, suffix:String)
        let abbreviations:[Abbrevation] = [(0, 1, ""),
                                           (100, 1000.0, "K"),
                                           (100_000.0, 1_000_000.0, "M"),
                                           (100_000_000.0, 1_000_000_000.0, "B")]
                                           // you can add more !
        let startValue = Double (abs(self))
        let abbreviation:Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()

        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1

        //return numFormatter.stringFromNumber(NSNumber (double:value))!
        return numFormatter.string(from: NSNumber(value: value)) ?? "0"
    }

}


@objc class ClosureSleeve: NSObject {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    /*func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }*/
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
            @objc class ClosureSleeve: NSObject {
                let closure:()->()
                init(_ closure: @escaping()->()) { self.closure = closure }
                @objc func invoke() { closure() }
            }
            let sleeve = ClosureSleeve(closure)
            addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
            objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
}
func getColorFromAsset(name:String) -> UIColor {
    return UIColor(named: name) ?? UIColor.black
}
func getCountryPhonceCode (_ country : String) -> String
{
    let countryDictionary  = ["AF":"93",
                              "AL":"355",
                              "DZ":"213",
                              "AS":"1",
                              "AD":"376",
                              "AO":"244",
                              "AI":"1",
                              "AG":"1",
                              "AR":"54",
                              "AM":"374",
                              "AW":"297",
                              "AU":"61",
                              "AT":"43",
                              "AZ":"994",
                              "BS":"1",
                              "BH":"973",
                              "BD":"880",
                              "BB":"1",
                              "BY":"375",
                              "BE":"32",
                              "BZ":"501",
                              "BJ":"229",
                              "BM":"1",
                              "BT":"975",
                              "BA":"387",
                              "BW":"267",
                              "BR":"55",
                              "IO":"246",
                              "BG":"359",
                              "BF":"226",
                              "BI":"257",
                              "KH":"855",
                              "CM":"237",
                              "CA":"1",
                              "CV":"238",
                              "KY":"345",
                              "CF":"236",
                              "TD":"235",
                              "CL":"56",
                              "CN":"86",
                              "CX":"61",
                              "CO":"57",
                              "KM":"269",
                              "CG":"242",
                              "CK":"682",
                              "CR":"506",
                              "HR":"385",
                              "CU":"53",
                              "CY":"537",
                              "CZ":"420",
                              "DK":"45",
                              "DJ":"253",
                              "DM":"1",
                              "DO":"1",
                              "EC":"593",
                              "EG":"20",
                              "SV":"503",
                              "GQ":"240",
                              "ER":"291",
                              "EE":"372",
                              "ET":"251",
                              "FO":"298",
                              "FJ":"679",
                              "FI":"358",
                              "FR":"33",
                              "GF":"594",
                              "PF":"689",
                              "GA":"241",
                              "GM":"220",
                              "GE":"995",
                              "DE":"49",
                              "GH":"233",
                              "GI":"350",
                              "GR":"30",
                              "GL":"299",
                              "GD":"1",
                              "GP":"590",
                              "GU":"1",
                              "GT":"502",
                              "GN":"224",
                              "GW":"245",
                              "GY":"595",
                              "HT":"509",
                              "HN":"504",
                              "HU":"36",
                              "IS":"354",
                              "IN":"91",
                              "ID":"62",
                              "IQ":"964",
                              "IE":"353",
                              "IL":"972",
                              "IT":"39",
                              "JM":"1",
                              "JP":"81",
                              "JO":"962",
                              "KZ":"77",
                              "KE":"254",
                              "KI":"686",
                              "KW":"965",
                              "KG":"996",
                              "LV":"371",
                              "LB":"961",
                              "LS":"266",
                              "LR":"231",
                              "LI":"423",
                              "LT":"370",
                              "LU":"352",
                              "MG":"261",
                              "MW":"265",
                              "MY":"60",
                              "MV":"960",
                              "ML":"223",
                              "MT":"356",
                              "MH":"692",
                              "MQ":"596",
                              "MR":"222",
                              "MU":"230",
                              "YT":"262",
                              "MX":"52",
                              "MC":"377",
                              "MN":"976",
                              "ME":"382",
                              "MS":"1",
                              "MA":"212",
                              "MM":"95",
                              "NA":"264",
                              "NR":"674",
                              "NP":"977",
                              "NL":"31",
                              "AN":"599",
                              "NC":"687",
                              "NZ":"64",
                              "NI":"505",
                              "NE":"227",
                              "NG":"234",
                              "NU":"683",
                              "NF":"672",
                              "MP":"1",
                              "NO":"47",
                              "OM":"968",
                              "PK":"92",
                              "PW":"680",
                              "PA":"507",
                              "PG":"675",
                              "PY":"595",
                              "PE":"51",
                              "PH":"63",
                              "PL":"48",
                              "PT":"351",
                              "PR":"1",
                              "QA":"974",
                              "RO":"40",
                              "RW":"250",
                              "WS":"685",
                              "SM":"378",
                              "SA":"966",
                              "SN":"221",
                              "RS":"381",
                              "SC":"248",
                              "SL":"232",
                              "SG":"65",
                              "SK":"421",
                              "SI":"386",
                              "SB":"677",
                              "ZA":"27",
                              "GS":"500",
                              "ES":"34",
                              "LK":"94",
                              "SD":"249",
                              "SR":"597",
                              "SZ":"268",
                              "SE":"46",
                              "CH":"41",
                              "TJ":"992",
                              "TH":"66",
                              "TG":"228",
                              "TK":"690",
                              "TO":"676",
                              "TT":"1",
                              "TN":"216",
                              "TR":"90",
                              "TM":"993",
                              "TC":"1",
                              "TV":"688",
                              "UG":"256",
                              "UA":"380",
                              "AE":"971",
                              "GB":"44",
                              "US":"1",
                              "UY":"598",
                              "UZ":"998",
                              "VU":"678",
                              "WF":"681",
                              "YE":"967",
                              "ZM":"260",
                              "ZW":"263",
                              "BO":"591",
                              "BN":"673",
                              "CC":"61",
                              "CD":"243",
                              "CI":"225",
                              "FK":"500",
                              "GG":"44",
                              "VA":"379",
                              "HK":"852",
                              "IR":"98",
                              "IM":"44",
                              "JE":"44",
                              "KP":"850",
                              "KR":"82",
                              "LA":"856",
                              "LY":"218",
                              "MO":"853",
                              "MK":"389",
                              "FM":"691",
                              "MD":"373",
                              "MZ":"258",
                              "PS":"970",
                              "PN":"872",
                              "RE":"262",
                              "RU":"7",
                              "BL":"590",
                              "SH":"290",
                              "KN":"1",
                              "LC":"1",
                              "MF":"590",
                              "PM":"508",
                              "VC":"1",
                              "ST":"239",
                              "SO":"252",
                              "SJ":"47",
                              "SY":"963",
                              "TW":"886",
                              "TZ":"255",
                              "TL":"670",
                              "VE":"58",
                              "VN":"84",
                              "VG":"284",
                              "VI":"340"]
    let cname = country.uppercased()
    if countryDictionary[cname] != nil
    {
        return countryDictionary[cname]!
    }
    else
    {
        return cname
    }

}
extension AVURLAsset {
    var fileSize: Float? {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)
        let size : Float = Float(Int((resourceValues?.fileSize ?? resourceValues?.totalFileSize) ?? 0)/1024/1204)
        return size
    }
}
func changeDateFormate(inputFormate: String, resultFormate: String, date: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = inputFormate
    let showDate = inputFormatter.date(from: date)
    inputFormatter.dateFormat = resultFormate
    let resultString = inputFormatter.string(from: showDate!)
    print(resultString)
    return resultString
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
func openMapView(lat: String, long: String) {
    if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
        if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(long)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    } else {
        let path = "http://maps.apple.com/?q=\(lat),\(long)"
        if let url = URL(string: path) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Could not construct url. Handle error.
        }
    }
}

func updateMainThreadUI(closure: @escaping () -> Void) {
    DispatchQueue.main.async {
        closure()
    }
}
