//
//  RegisterViewController.swift
//  tada_clone_coding
//
//  Created by Hyeonsu Jeong on 2023/02/19.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var phoneTf: UITextField!
    
    @IBOutlet var alienBtn: UIButton!
    @IBOutlet var changedNumberBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    
    let notchBottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.numberOfLines = 0
        titleLabel.text = "안녕하세요! \n휴대폰 번호를 입력해 주세요"
        
        phoneTf.borderStyle = .none
        phoneTf.keyboardType = .numberPad
        
        setKeyboardObserver()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView(_:))))
        
        phoneTf.becomeFirstResponder()
    }
    
    @objc func didTapView(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func didTapTextFieldEraseBtn(_ sender: UIButton) {
        phoneTf.text = ""
    }
    
    @IBAction func didTapNextBtn(_ sender: UIButton) {
        if let phoneNumber = phoneTf.text, validatePhoneNumber(phoneNumber) {
            // 핸드폰 번호가 유효한 경우에만 처리합니다.
            let verificationVC = UIStoryboard(name: "VerificationViewController", bundle: nil).instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
            verificationVC.phoneNumber = phoneTf.text ?? ""
            navigationController?.pushViewController(verificationVC, animated: true)
        } else {
            let popupVC = CustomPopupViewController()
            popupVC.modalPresentationStyle = .overFullScreen
            present(popupVC, animated: false)
        }
        
    }
    
    func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        // "010"으로 시작하고, 총 길이가 11인 경우에만 true를 반환합니다.
        return phoneNumber.hasPrefix("010") && phoneNumber.count == 11
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: NSNotification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: 1) {
                self.alienBtn.frame.origin.y -= keyboardHeight - self.notchBottom
                self.changedNumberBtn.frame.origin.y -= keyboardHeight - self.notchBottom
                self.nextBtn.frame.origin.y -= keyboardHeight - self.notchBottom
            }
        }
    }
    
    @objc func keyboardWillHide(_ sender: NSNotification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: 1) {
                self.alienBtn.frame.origin.y += keyboardHeight - self.notchBottom
                self.changedNumberBtn.frame.origin.y += keyboardHeight - self.notchBottom
                self.nextBtn.frame.origin.y += keyboardHeight - self.notchBottom
            }
        }
    }
    
    
}
