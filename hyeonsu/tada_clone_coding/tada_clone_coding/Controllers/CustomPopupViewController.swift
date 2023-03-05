import UIKit

class CustomPopupViewController: UIViewController {
    
    var titleLabel: UILabel!
    var okButton: UIButton!
    var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#999999")
        // 팝업 뷰 설정
        popupView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        popupView.backgroundColor = .white
        
        // 제목 레이블 설정
        titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: 300, height: 30))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.text = "유효한 휴대폰 번호를 입력하세요."
        
        // 확인 버튼 설정
        okButton = UIButton(frame: CGRect(x: 0, y: 60, width: 300, height: 40))
        okButton.setTitle("확인", for: .normal)
        okButton.setTitleColor(UIColor(hex: "#7DB8F3"), for: .normal)
        okButton.backgroundColor = UIColor(hex: "#F5F6F7")
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        
        // 뷰에 위젯 추가
        popupView.addSubview(titleLabel)
        popupView.addSubview(okButton)
        view.addSubview(popupView)
        
        // 팝업 뷰 위치 설정
        popupView.center = view.center
    }
    
    @objc func okButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
