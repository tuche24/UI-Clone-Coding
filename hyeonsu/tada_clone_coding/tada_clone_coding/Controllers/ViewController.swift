//
//  ViewController.swift
//  tada_clone_coding
//
//  Created by Hyeonsu Jeong on 2023/02/19.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainContentLabel: UILabel!
    @IBOutlet weak var backgroundView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        backgroundView.image = UIImage(named: "backgroundImage")
        
        mainContentLabel.numberOfLines = 0
        mainContentLabel.text = "승차거부 없는 바로세차\n서비스 만족도 4.95점\n서비스 만족도 90%"
    }

    @IBAction func nextPage(_ sender: UIButton) {
        if let registVC = UIStoryboard(name: "RegisterViewController", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            navigationController?.pushViewController(registVC, animated: true)
        }
    }
    
    
    
}

