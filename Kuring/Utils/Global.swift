//
//  global.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2021/12/01.
//

import UIKit

let DeviceWidthRatio = UIScreen.main.bounds.size.width / 360 /// 스냅킷에서 비율 조정해주기 위함
let DeviceHeightRatio = UIScreen.main.bounds.size.height / 608 /// 스냅킷에서 비율 조정해주기 위함

var originalBaseUrl = "https://www.konkuk.ac.kr/do/MessageBoard/ArticleRead.do" /// 베이스 URL (재성님 sdk에서 url을 받아올 방법을 모르겠어요
var libraryBaseUrl = "https://library.konkuk.ac.kr/#/bbs/notice/"

var articleKey = "readArticleId" /// userDefault 키(읽은 아티클 아이디)
var readArticle = UserDefaults.standard.array(forKey: articleKey) ?? [String]() /// userDefault 읽은 아티클 id저장

var timeKey = "EntryTime" /// userDefault 키(마지막으로 접속한 시간) 
var userConnectedTime = UserDefaults.standard.string(forKey: timeKey) ?? "20211201" /// userDefault 읽은 시간 값 - default값 00000000


