//
//  global.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2021/12/01.
//

import RxCocoa
import RxSwift
import RxCocoa
import KuringSDK

let DeviceWidthRatio = UIScreen.width / 360 /// 스냅킷에서 비율 조정해주기 위함
let DeviceHeightRatio = UIScreen.height / 608 /// 스냅킷에서 비율 조정해주기 위함

var originalBaseUrl = "https://www.konkuk.ac.kr/do/MessageBoard/ArticleRead.do" /// 베이스 URL (재성님 sdk에서 url을 받아올 방법을 모르겠어요
var libraryBaseUrl = "https://library.konkuk.ac.kr/#/bbs/notice/"

var sheetLabel = ["피드백 보내기", "오픈소스", "개인정보 처리방침", "서비스 이용약관"] /// 메뉴 버튼 클릭시 나타나는 옵션들
var sheetImage = ["chat_bubble", "institution", "document", "check_docs"] /// 옵션 리스트에 들어갈 메뉴들

var subscribeKey = "userSubscribe" /// userDefault 키(구독한 카테고리)

var articleKey = "readArticleId" /// userDefault 키(읽은 아티클 아이디)
var readArticle = UserDefaults.standard.array(forKey: articleKey) ?? [String]() /// userDefault 읽은 아티클 id저장

var timeKey = "EntryTime" /// userDefault 키(마지막으로 접속한 시간) 
var userConnectedTime = UserDefaults.standard.string(forKey: timeKey) ?? "20211201" /// userDefault 읽은 시간 값 - default값 00000000

///
// MARK: 그냥 내가 임시로 사용하기 위한 데이터
//var tempData = ["1","2","3"]
var tempData = [Int]()
var longtempData = ["asdasd","grnbgisdnf","agkgjksdfmnsmadtg"]
