//
//  KUSearchViewController.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit
import KuringSDK

class KUSearchViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldBackgroundView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    // TODO: make non-null or move to kuring main
    var searcher: Searcher?
    
    var currentType: Searcher.SearchType = .notice {
        didSet {
            collectionView.reloadData()
            resetResult()
            search()
        }
    }
    var staffResult: [Staff] = [] {
        didSet { tableView.reloadData() }
    }
    var noticeResult: [Notice] = [] {
        didSet { tableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searcher = Kuring.createSearcher(delegate: self)
        searcher?.connect()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        textFieldBackgroundView.backgroundColor = .clear
        textFieldBackgroundView.layer.cornerRadius = textFieldBackgroundView.frame.height / 2
        textFieldBackgroundView.layer.borderWidth = 1
        textFieldBackgroundView.layer.borderColor = ColorSet.green.cgColor
    }
    
    deinit {
        // 반드시 서쳐 메모리 해지 -> 웹소켓 연결 자동 해지됨
        self.searcher = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
