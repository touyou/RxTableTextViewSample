//
//  ViewController.swift
//  RxTableTextViewSample
//
//  Created by 藤井陽介 on 2018/05/21.
//  Copyright © 2018 touyou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct Item {

    var tag: String?
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {

        didSet {

            tableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "TextCell")
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var textView: UITextView!

    private let disposeBag = DisposeBag()
    var items: Variable<[Item]> = Variable([Item(tag: nil)])

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        items.asObservable().bind(onNext: { [unowned self] items in

            self.textView.text = items.reduce("", { result, item in

                guard let tag = item.tag else {

                    return result
                }

                if result == "" {

                    return tag
                } else {

                    return result + ", " + tag
                }
            })
        }).disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextTableViewCell
        cell.textField.text = self.items.value[indexPath.row].tag
        cell.textField.rx.text.asDriver().drive(onNext: { text in

            self.items.value[indexPath.row].tag = text
        }).disposed(by: disposeBag)
        cell.addButton.rx.tap.subscribe(onNext: {

            self.items.value.append(Item(tag: nil))
            tableView.reloadData()
        }).disposed(by: disposeBag)
        return cell
    }
}

