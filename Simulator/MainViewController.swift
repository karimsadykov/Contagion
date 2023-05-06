//
//  ViewController.swift
//  Simulator
//
//  Created by Карим Садыков on 04.05.2023.
//

import UIKit

class MainViewController: UIViewController {

    private let groupCountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .bezel
        return textField
    }()
    
    private let infectCountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .bezel
        return textField
    }()
    
    private let periodCountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .bezel
        return textField
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .green
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(groupCountTextField)
        view.addSubview(infectCountTextField)
        view.addSubview(periodCountTextField)
        view.addSubview(startButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        groupCountTextField.frame = CGRect(x: 100, y: 150, width: 200, height: 50)
        infectCountTextField.frame = CGRect(x: 100, y: 250, width: 200, height: 50)
        periodCountTextField.frame = CGRect(x: 100, y: 350, width: 200, height: 50)
        startButton.frame = CGRect(x: 100, y: 500, width: 200, height: 50)
    }

    

}

