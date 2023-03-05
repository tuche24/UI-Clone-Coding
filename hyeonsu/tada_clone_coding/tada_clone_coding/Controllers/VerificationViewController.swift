//
//  VerificationViewController.swift
//  tada_clone_coding
//
//  Created by Hyeonsu Jeong on 2023/03/05.
//

import UIKit

// 참고 : https://ios-development.tistory.com/282
class VerificationViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var OTFFieldView: OTPFieldView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var phoneNumber = ""
    var secondsLeft = 180
    var countdownTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleLabel()
        OTFFieldView.baseStyle()
        
        // 타이머를 생성하고 시작
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @IBAction func didTapResetBtn(_ sender: UIButton) {
        // 초 카운트를 설정
        secondsLeft = 180
        
        // 타이머를 생성하고 시작
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if secondsLeft > 0 {
            secondsLeft -= 1
            let minutes = secondsLeft / 60
            let seconds = secondsLeft % 60
            timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        } else {
            countdownTimer?.invalidate()
            countdownTimer = nil
        }
    }
    
    fileprivate func setTitleLabel() {
        titleLabel.numberOfLines = 0
        
        // 텍스트를 설정합니다.
        let text = "\(phoneNumber) 로 전송된 인증번호를 입력해주세요"
        
        // 폰트와 폰트 색상을 설정합니다.
        let font = UIFont.systemFont(ofSize: 17.0)
        let textColor = UIColor(hex: "#55A0F3")
        
        // NSAttributedString을 생성합니다.
        let attributedText = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: text.count)
        
        // 정규식을 사용하여 숫자와 하이픈으로 이루어진 부분을 찾습니다.
        let pattern = "[0-9-]+"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: text, options: [], range: range)
        
        // 찾은 부분에 폰트와 폰트 색상을 적용합니다.
        for match in matches {
            attributedText.addAttributes([.font: font, .foregroundColor: textColor], range: match.range)
        }
        
        // UILabel의 attributedText에 적용합니다.
        titleLabel.attributedText = attributedText
    }
}

