//
//  KUNoticeListViewController.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit
import KuringSDK
import SkeletonView

class KUNoticeListViewController: UIViewController {
    /// 현재 공지 타입. 기본값: `.학사`
    var currentType: NoticeType = .학사 {
        didSet {
            collectionView.reloadData()
            tableView.reloadData()
            if noticeList[currentType] == nil {
                load()
            }
        }
    }
    /// 현재 타입에 해당하는 공지 리스트
    var currentNotices: [Notice] {
        noticeList[currentType] ?? []
    }
    // MARK: State
    /// 각 타입별로 가져온 공지사항을 저장
    var noticeList: [NoticeType: [Notice]] = [:]
    /// 각 타입별로 어느 오프셋부터 공지사항을 가져오면 되는지 기록
    var offsetList: [NoticeType: Int] = [:]
    /// 각 타입별로 불러올 수 있는 공지사항이 더 존재하는지 여부 기록
    var hasNextList: [NoticeType: Bool] = [:]
    
    /// 공지사항 리스트를 가져오는 쿼리
    var query: NoticeListQuery?
    /// 한번 요청 시 가져올 수 있는 공지 사항 개수 최댓값
    let loadLimit = 20
    /// 현재 공지사항 리스트를 가져오는 중인지 여부
    var isLoading = false
    
    @IBOutlet weak var notificationButton: UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.isSkeletonable = true
            tableView.rowHeight = 68
            tableView.estimatedRowHeight = 68
        }
    }
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem?.image = UIImage(named: "appIconLabel")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem?.isEnabled = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isSkeletonable = true
        
        let nibName = UINib(nibName: "KUNoticeListViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: KUNoticeListViewCell.identifier)
        
        refreshControl.addTarget(
            self,
            action: #selector(refresh),
            for: .valueChanged
        )
        tableView.refreshControl = refreshControl
        Kuring.addDelegate(self, forKey: "KUNoticeListViewController")
        
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        updateNotifcationButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNotification" {
            Kuring.hasNewNotification = false
            updateNotifcationButton()
        }
    }
    
    func updateNotifcationButton() {
        let config = UIImage.SymbolConfiguration(
            paletteColors: Kuring.hasNewNotification
            ? [UIColor(named: "ColorSet.pink")!, UIColor(named: "ColorSet.Label.primary")!]
            : [UIColor(named: "ColorSet.Label.primary")!]
        )
        
        notificationButton.image = UIImage(
            systemName: Kuring.hasNewNotification
            ? "bell.badge"
            : "bell"
        )?.withConfiguration(config)
    }
    
    func updateData() {
        if let hasNext = hasNextList[currentType] {
            if hasNext == false {
                // 더이상 불러올 수 있는 공지가 없습니다.
                return
            }
        }
        load()
    }
    
    @objc
    func refresh() {
        isLoading = true
        // 오프셋0부터 데이터 가져오기
        let params = NoticeListQuery.Params(
            type: currentType,
            offset: 0,
            max: UInt(loadLimit)
        )
        query = Kuring.createNoticeListQuery(with: params)
        query?.load { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            self.refreshControl.endRefreshing()
            switch result {
                case .success(let notices):
                    var newNotices: [Notice] = []
                    for notice in notices {
                        if notice.id == self.noticeList[self.currentType]?.first?.id { return }
                        newNotices.append(notice)
                    }
                    // 가져온 데이터 수 기록
                    let count = newNotices.count
                    
                    // 가져온 데이터 수 만큼 오프셋 값 추가
                    let prevOffset = self.offsetList[self.currentType] ?? 0
                    let currentOffset = prevOffset + count
                    self.offsetList.updateValue(currentOffset, forKey: self.currentType)
                    
                    // 가져온 데이터 array 가장 앞에 삽입
                    // Update notices
                    var currentNotices = self.noticeList[self.currentType] ?? []
                    currentNotices.insert(contentsOf: newNotices, at: 0)
                    self.noticeList.updateValue(currentNotices, forKey: self.currentType)
                    
                    // 뷰 업데이트
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func load() {
        if hasNextList[currentType] == false { return }
        isLoading = true
        tableView.showSkeleton()
        let currentOffset = offsetList[currentType] ?? 0
        let params = NoticeListQuery.Params(
            type: currentType,
            offset: UInt(currentOffset),
            max: UInt(loadLimit)
        )
        query = Kuring.createNoticeListQuery(with: params)
        query?.load { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            self.tableView.hideSkeleton()
            switch result {
                case .success(let notices):
                    // Update hasNext
                    let hasNext = notices.count >= self.loadLimit
                    self.hasNextList.updateValue(hasNext, forKey: self.currentType)
                    
                    // Update offset
                    let prevOffset = self.offsetList[self.currentType] ?? 0
                    let currentOffset = prevOffset + notices.count
                    self.offsetList.updateValue(currentOffset, forKey: self.currentType)
                    
                    // Update notices
                    var currentNotices = self.noticeList[self.currentType] ?? []
                    notices.forEach { currentNotices.append($0) }
                    self.noticeList.updateValue(currentNotices, forKey: self.currentType)
                    
                    // 뷰 업데이트
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}

extension KUNoticeListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        NoticeType.allCases.count
    }
    
    // TODO: Leading space for first item at index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: KUNoticeListCollectionViewCell.identifier,
            for: indexPath
        ) as! KUNoticeListCollectionViewCell
        
        let noticeType = NoticeType.allCases[indexPath.row]
        cell.noticeType = noticeType
        cell.configure(selected: noticeType == currentType)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) as? KUNoticeListCollectionViewCell else { return }
        self.currentType = cell.noticeType
    }
}

extension KUNoticeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentNotices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: KUNoticeListViewCell.identifier,
            for: indexPath
        ) as! KUNoticeListViewCell
        
        let notice = currentNotices[indexPath.row]
        cell.notice = notice
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let notice = currentNotices[indexPath.row]
        notice.read()
        let urlString = articleURL(from: notice)
        showNoticeWebViewController(with: urlString)
    }
    
    /// 선택된 `Notice` 값으로 부터 유효한 웹주소 가져오기
    func articleURL(from notice: Notice) -> String {
        if var articleArray = readArticle as? [String] {
            let id = notice.articleID
            if !articleArray.contains(id) {
                articleArray.append(id)
                UserDefaults.standard.set(articleArray, forKey: articleKey)
                readArticle = UserDefaults.standard.array(forKey: articleKey)!
            }
        }
        
        let articleURL = currentType == .도서관
        ? "\(libraryBaseUrl)\(notice.articleID)"
        : "\(originalBaseUrl)?id=\(notice.articleID)"
    
        return articleURL.isEmpty
        ? "https://konkuk.ac.kr"
        : articleURL
    }
    
    /// 스크롤 시 호출되는 메소드
    /// - Note: 스크롤시 하단 끝에 도달하면 그 다음 공지를 가져온다.
    /// - Important: CollectionView 의 scroll도 감지되므로 내부 구현시 유의할 것.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height) {
            self.load()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // TODO: 추후에 공지 보관함 기능 추가
        return nil
    }
}

extension KUNoticeListViewController: KuringDelegate {
    func didReceiveNotification(_ notification: KuringSDK.Notification) {
        updateNotifcationButton()
    }
    
    func didUpdateSubscription(_ subscription: Subscription) {
        
    }
}

extension KUNoticeListViewController: SkeletonTableViewDelegate { }

extension KUNoticeListViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return KUNoticeListViewCell.identifier
    }
}
