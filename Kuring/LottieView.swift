//
//  LottieView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/06.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    //makeCoordinator를 구현하여 제약사항을 구현합니다.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    //json파일명을 받을 프로퍼티
    var filename: String
    
    //lottie View
    var animationView = AnimationView()
    
    
    class Coordinator: NSObject {
        var parent: LottieView
        
        init(_ animationView: LottieView) {
            //frame을 LottieView로 할당합니다.
            self.parent = animationView
            super.init()
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        
        //lottie 구현뷰
        animationView.animation = Animation.named(filename)
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        //애니메이션이 계속 반복되게합니다.
        animationView.loopMode = .loop
        animationView.play()
        return view
    }
    
    //updateView가 구현되어있지않습니다.
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        
    }
}
