//
//  BaseViewController.swift
//  tada_clone_coding
//
//  Created by Hyeonsu Jeong on 2023/03/05.
//
import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let backButtonImage = UIImage(named: "backButtonImage")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}






