import UIKit

@objc public protocol OTPFieldViewDelegate: class {
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool
    func enteredOTP(otp: String)
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool
    func deletedOTP()
}

@objc public enum DisplayType: Int {
    case circular
    case roundedCorner
    case square
    case diamond
    case underlinedBottom
}

/// Different input type for OTP fields.
@objc public enum KeyboardType: Int {
    case numeric
    case alphabet
    case alphaNumeric
}

@objc public class OTPFieldView: UIView {
    /// Different display type for text fields.
    public var displayType: DisplayType = .circular
    public var fieldsCount: Int = 4
    public var otpInputType: KeyboardType = .numeric
    public var fieldFont: UIFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
    public var secureEntry: Bool = false
    public var hideEnteredText: Bool = false
    public var requireCursor: Bool = true
    public var cursorColor: UIColor = .blue
    public var fieldSize: CGFloat = 60
    public var separatorSpace: CGFloat = 16
    public var fieldBorderWidth: CGFloat = 1
    public var shouldAllowIntermediateEditing: Bool = true
    public var defaultBackgroundColor: UIColor = UIColor.clear
    public var filledBackgroundColor: UIColor = UIColor.clear
    public var defaultBorderColor: UIColor = UIColor.gray
    public var filledBorderColor: UIColor = UIColor.clear
    public var errorBorderColor: UIColor?
    public var fieldColor: UIColor = .blue
    public var isValidOtp = true
    public weak var delegate: OTPFieldViewDelegate?
    fileprivate var secureEntryData = [String]()

    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    public func initializeUI() {
        layer.masksToBounds = true
        layoutIfNeeded()
        initializeOTPFields()
        // Forcefully try to make first otp field as first responder
//        (viewWithTag(1) as? OTPTextField)?.becomeFirstResponder()
    }

    fileprivate func initializeOTPFields() {
        secureEntryData.removeAll()
        for index in stride(from: 0, to: fieldsCount, by: 1) {
            let oldOtpField = viewWithTag(index + 1) as? OTPTextField
            oldOtpField?.removeFromSuperview()
            let otpField = getOTPField(forIndex: index)
            addSubview(otpField)
            secureEntryData.append("")
        }
    }

    func getOTPField(forIndex index: Int) -> OTPTextField {
        let hasOddNumberOfFields = (fieldsCount % 2 == 1)
        var fieldFrame = CGRect(x: 0, y: 0, width: fieldSize, height: fieldSize)
        if hasOddNumberOfFields {
            // Calculate from middle each fields x and y values so as to align the entire view in center
            fieldFrame.origin.x = bounds.size.width / 2 - (CGFloat(fieldsCount / 2 - index) *
                (fieldSize + separatorSpace) + fieldSize / 2)
        } else {
            // Calculate from middle each fields x and y values so as to align the entire view in center
            fieldFrame.origin.x = bounds.size.width / 2 -
                (CGFloat(fieldsCount / 2 - index) * fieldSize
                    + CGFloat(fieldsCount / 2 - index - 1) * separatorSpace + separatorSpace / 2)
        }
        fieldFrame.origin.y = (bounds.size.height - fieldSize) / 2
        let otpField = OTPTextField(frame: fieldFrame)
        otpField.delegate = self

        otpField.tag = index + 1
        otpField.font = fieldFont
        otpField.textColor = isValidOtp ? fieldColor : .red

        // Set input type for OTP fields
        switch otpInputType {
        case .numeric:
            otpField.keyboardType = .numberPad
        case .alphabet:
            otpField.keyboardType = .alphabet
        case .alphaNumeric:
            otpField.keyboardType = .namePhonePad
        }
        // Set the border values if needed
        if isValidOtp {
            defaultBorderColor = .blue
        }
        otpField.otpBorderColor = defaultBorderColor
        otpField.otpBorderWidth = fieldBorderWidth
        if requireCursor {
            otpField.tintColor = cursorColor
        } else {
            otpField.tintColor = UIColor.clear
        }
        // Set the default background color when text not set
        otpField.backgroundColor = defaultBackgroundColor
        // Finally create the fields
        otpField.initalizeUI(forFieldType: displayType)
        return otpField
    }

    fileprivate func isPreviousFieldsEntered(forTextField textField: UITextField) -> Bool {
        var isTextFilled = true
        var nextOTPField: UITextField?
        // If intermediate editing is not allowed, then check for last filled field in forward direction.
        if !shouldAllowIntermediateEditing {
            for index in stride(from: 1, to: fieldsCount + 1, by: 1) {
                let tempNextOTPField = viewWithTag(index) as? UITextField
                if let tempNextOTPFieldText = tempNextOTPField?.text, tempNextOTPFieldText.isEmpty {
                    nextOTPField = tempNextOTPField
                    break
                }
            }
            if let nextOTPField = nextOTPField {
                isTextFilled = (nextOTPField == textField || (textField.tag) == (nextOTPField.tag - 1))
            }
        }
        return isTextFilled
    }

    // Helper function to get the OTP String entered
    fileprivate func calculateEnteredOTPSTring(isDeleted: Bool) {
        if isDeleted {
            _ = delegate?.hasEnteredAllOTP(hasEnteredAll: false)
            // Set the default enteres state for otp entry
            for index in stride(from: 0, to: fieldsCount, by: 1) {
                var otpField = viewWithTag(index + 1) as? OTPTextField
                if otpField == nil {
                    otpField = getOTPField(forIndex: index)
                }
                let fieldBackgroundColor = (otpField?.text ?? "").isEmpty ?
                    defaultBackgroundColor : filledBackgroundColor
                let fieldBorderColor = (otpField?.text ?? "").isEmpty ? defaultBorderColor : filledBorderColor
                if displayType == .diamond || displayType == .underlinedBottom {
//                    otpField?.shapeLayer.fillColor = fieldBackgroundColor.cgColor
//                    otpField?.shapeLayer.strokeColor = fieldBorderColor.cgColor
                } else {
                    otpField?.backgroundColor = fieldBackgroundColor
                    otpField?.layer.borderColor = fieldBorderColor.cgColor
                }
            }
        } else {
            let enteredOTPString = enteredOTP()
            if enteredOTPString.count == fieldsCount {
                delegate?.enteredOTP(otp: enteredOTPString)
                // Check if all OTP fields have been filled or not. Based on that call the 2 delegate methods.
                let isValid = delegate?.hasEnteredAllOTP(hasEnteredAll:
                    (enteredOTPString.count == fieldsCount)) ?? false
                // Set the error state for invalid otp entry
                for index in stride(from: 0, to: fieldsCount, by: 1) {
                    var otpField = viewWithTag(index + 1) as? OTPTextField
                    if otpField == nil {
                        otpField = getOTPField(forIndex: index)
                    }
                    if !isValid {
                        // Set error border color if set, if not, set default border color
                        otpField?.layer.borderColor = (errorBorderColor ?? filledBorderColor).cgColor
                    } else {
                        otpField?.layer.borderColor = filledBorderColor.cgColor
                    }
                }
            }
        }
    }
}

extension OTPFieldView: UITextFieldDelegate {

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        let shouldBeginEditing = delegate?
            .shouldBecomeFirstResponderForOTP(otpTextFieldIndex: (textField.tag - 1)) ?? true
        if shouldBeginEditing {
            return isPreviousFieldsEntered(forTextField: textField)
        }
        return shouldBeginEditing
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let count = textField.text?.count {
            _ = delegate?.hasEnteredAllOTP(hasEnteredAll: count == fieldsCount)
        }
        return true
    }

    public func enteredOTP() -> String {
        var enteredOTPString = ""
        for index in stride(from: 0, to: secureEntryData.count, by: 1) where !secureEntryData[index].isEmpty {
             enteredOTPString.append(secureEntryData[index])
        }
        return enteredOTPString
    }

    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {

        if enteredOTP().count == fieldsCount, !string.isEmpty {
            return false
        }

        let characterSet = CharacterSet(charactersIn: string)
        if CharacterSet.decimalDigits.isSuperset(of: characterSet) == false {
            return false
        }

        if string == "" {
            delegate?.deletedOTP()
        }
        let newString = String(string.prefix(1))

        if let text = textField.text {
            delegate?.enteredOTP(otp: text + string)
        }

        let replacedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        // Check since only alphabet keyboard is not available in iOS
        if !replacedText.isEmpty && otpInputType == .alphabet && replacedText.rangeOfCharacter(from: .letters) == nil {
            return false
        }
        if replacedText.count >= 1 {

            // If field has a text already, then replace the text and move to next field if present
            secureEntryData[textField.tag - 1] = string

            if hideEnteredText {
                textField.text = " "
            } else {
                if secureEntry {
                    textField.text = "•"
                } else {
                    textField.text = string
                }
            }
            if displayType == .diamond || displayType == .underlinedBottom {
                var color = UIColor.clear.cgColor
                if !isValidOtp {
                    color = UIColor.red.cgColor
                }
                (textField as? OTPTextField)?.shapeLayer?.fillColor = color
                (textField as? OTPTextField)?.shapeLayer?.strokeColor = color
            } else {
                textField.backgroundColor = filledBackgroundColor
                textField.layer.borderColor = filledBorderColor.cgColor
            }
            let nextOTPField = viewWithTag(textField.tag + 1)
            if let nextOTPField = nextOTPField {
                nextOTPField.becomeFirstResponder()
            } else {
                //textField.resignFirstResponder()
            }
            // Get the entered string
            calculateEnteredOTPSTring(isDeleted: false)
        } else {
            let currentText = textField.text ?? ""
            if textField.tag > 1 && currentText.isEmpty {
                if let prevOTPField = viewWithTag(textField.tag - 1) as? UITextField {
                    deleteText(in: prevOTPField)
                }
            } else {
                deleteText(in: textField)
                if textField.tag > 1 {
                    if let prevOTPField = viewWithTag(textField.tag) as? UITextField {
                        prevOTPField.becomeFirstResponder()
                    }
                }
            }
        }
        return false
    }

    private func deleteText(in textField: UITextField) {
        // If deleting the text, then move to previous text field if present
        secureEntryData[textField.tag - 1] = ""
        textField.text = ""

        if displayType == .diamond || displayType == .underlinedBottom {
            (textField as? OTPTextField)?.shapeLayer?.fillColor = defaultBackgroundColor.cgColor
            (textField as? OTPTextField)?.shapeLayer?.strokeColor = defaultBorderColor.cgColor
        } else {
            textField.backgroundColor = defaultBackgroundColor
            textField.layer.borderColor = defaultBorderColor.cgColor
        }
        textField.becomeFirstResponder()
        // Get the entered string
        calculateEnteredOTPSTring(isDeleted: true)
    }
}

extension OTPFieldView {
    func baseStyle() {
        fieldBorderWidth = 2
        defaultBorderColor = .blue
        filledBorderColor = .blue
        displayType = .underlinedBottom
        fieldSize = 24
        fieldsCount = 6
        separatorSpace = 12
        shouldAllowIntermediateEditing = false
        requireCursor = false
        initializeUI()
    }

    func setUpBirthDateStyle() {

        baseStyle()

        for index in stride(from: 0, to: fieldsCount, by: 1) {
            var otpField = viewWithTag(index + 1) as? OTPTextField
            if otpField == nil {
                otpField = getOTPField(forIndex: index)
            }

            switch index {
            case 0, 1:
                otpField?.attributedPlaceholder = NSAttributedString(string: "Y", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            case 2, 3:
                otpField?.attributedPlaceholder = NSAttributedString(string: "M", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            default:
                otpField?.attributedPlaceholder = NSAttributedString(string: "D", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            }
        }
    }
}

// MARK: - Utils
public extension OTPFieldView {
    func deleteAllInput() {
        for i in 1...(fieldsCount - 1) {
            DispatchQueue.main.async { [weak self] in
                (self?.viewWithTag(i) as? OTPTextField)?.text = ""
            }
        }
        DispatchQueue.main.async { [weak self] in
            _ = (self?.viewWithTag(1) as? OTPTextField)?.becomeFirstResponder()
        }
    }

    func setUpTextAndShapeLayerColor(isValidStatus: Bool, hasUnderline: Bool) {
        isValidOtp = isValidStatus

        let shapeLayerValidStatusColor = hasUnderline ? UIColor.blue.cgColor : UIColor.clear.cgColor

        let textColor: UIColor = isValidStatus ? .blue : .red
        let shapeLayerColor: CGColor = isValidStatus ? shapeLayerValidStatusColor : UIColor.red.cgColor
        defaultBorderColor = textColor

        for i in 1...7 {
            var otpField = viewWithTag(i) as? OTPTextField
            if otpField == nil {
                otpField = getOTPField(forIndex: i - 1)
            }
            otpField?.textColor = textColor
            otpField?.shapeLayer.fillColor = shapeLayerColor
            otpField?.shapeLayer.strokeColor = shapeLayerColor

            if let text = otpField?.text {
                otpField?.text = text
            }
        }
    }
}
