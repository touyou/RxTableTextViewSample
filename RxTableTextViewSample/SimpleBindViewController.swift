//
//  SimpleBindViewController.swift
//  RxTableTextViewSample
//
//  Created by 藤井陽介 on 2018/05/28.
//  Copyright © 2018 touyou. All rights reserved.
//

import UIKit
import RxSwift

class SimpleBindViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.rx.text.bind(to: label.rx.text).disposed(by: disposeBag)
    }
}
