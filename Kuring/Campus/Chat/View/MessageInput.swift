//
//  MessageInput.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/15.
//

import SwiftUI
import KuringCommons

struct MessageInput: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    
    @State private var isEditing: Bool = false
    var placeholder: String = "메세지를 입력하세요..."
    
    func makeUIView(context: UIViewRepresentableContext<MessageInput>) -> UITextView {
        let view = UITextView()
        view.backgroundColor = .clear
        view.font = UIFont.preferredFont(forTextStyle: .subheadline)
        view.text = placeholder
        view.textColor = ColorSet.Label.tertiary
        view.delegate = context.coordinator
        self.height = view.contentSize.height
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MessageInput>) {
        if text.isEmpty {
            uiView.text = self.isEditing ? "" : placeholder
            uiView.textColor = self.isEditing ? ColorSet.Label.primary : ColorSet.Label.tertiary
        } else {
            uiView.text = "\(text) "
            uiView.textColor = ColorSet.Label.primary
        }
        
        DispatchQueue.main.async {
            self.height = uiView.contentSize.height
            uiView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        MessageInput.Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MessageInput
        
        init(parent: MessageInput) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
                textView.text = self.parent.text
                self.parent.isEditing = true
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.isEditing = false
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            if textView.text.count > 300 {
                let start = textView.text.index(textView.text.startIndex, offsetBy: 0)
                let end = textView.text.index(textView.text.startIndex, offsetBy: 300)
                textView.text = String(textView.text[start..<end])
            }
            
            DispatchQueue.main.async {
                self.parent.height = textView.contentSize.height
                self.parent.text = textView.text
            }
        }
    }
}
