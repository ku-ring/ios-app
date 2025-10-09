//
//  CommentTextField.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/1/25.
//

import SwiftUI
import ColorSet
import Networks

/// 댓글을 작성하는 텍스트필드 영역 뷰
/// ```swift
///  CommentTextField(text: $text, calculatedHeight: $textViewHeight)
/// ```
///  - Parameters:
///    - text: 바인딩할 텍스트필드 입력값
///    - calculatedHeight: 텍스트필드 높이값, 사용처에서 frame(height: $calculatedHeight)와 같이 선언
struct CommentTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var isReply: Bool
    @Binding var calculatedHeight: CGFloat
    
    // 최대 줄 수
    let maxLines: Int = 5
    let verticalPadding: CGFloat = 11.0

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15, weight: .medium)
        textView.delegate = context.coordinator
        textView.isScrollEnabled = true
        textView.layer.cornerRadius = 20
        textView.layer.borderWidth = 1
        textView.backgroundColor = UIColor(Color.Kuring.bg)
        textView.layer.borderColor = UIColor(Color.Kuring.gray200).cgColor
        textView.text = "댓글 추가..."
        textView.textColor = UIColor(Color.Kuring.caption2)
        textView.sizeToFit()
        
        let attributes: [NSAttributedString.Key: Any] = [.font: textView.font as Any]
        let size = ("환" as NSString).size(withAttributes: attributes)
        
        textView.textContainerInset = .init(top: verticalPadding, left: 20, bottom: verticalPadding, right: 20)
        
        Task { @MainActor in
            context.coordinator.lineHeight = size.height
        }
        
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        Task { @MainActor in
            var newPlaceholder = isReply ? "대댓글 추가..." : "댓글 추가..."
            if uiView.textColor == UIColor(Color.Kuring.caption2) {
                if uiView.text != newPlaceholder {
                    uiView.text = newPlaceholder
                }
            }
            
            let fittingSize = uiView.sizeThatFits(CGSize(width: uiView.frame.width, height: CGFloat.infinity))
            
            let totalVerticalPadding = self.verticalPadding * 2
            let maxHeight = context.coordinator.lineHeight * CGFloat(self.maxLines) + totalVerticalPadding
            
            if !(fittingSize.height >= maxHeight) {
                self.calculatedHeight = fittingSize.height
            } 
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CommentTextField
        var lineHeight: CGFloat = 0.0

        init(_ parent: CommentTextField) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
            self.recalculateHeight(for: textView)
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor(Color.Kuring.caption2) {
                textView.text = nil
                textView.textColor = UIColor(Color.Kuring.body)
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.isReply ? "대댓글 추가..." : "댓글 추가..."
                textView.textColor = UIColor(Color.Kuring.caption2)
            }
        }
        
        func recalculateHeight(for textView: UITextView) {
            guard self.lineHeight > 0 else { return }
            
            Task { @MainActor in
                let fittingSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.infinity))
                
                let totalVerticalPadding = self.parent.verticalPadding * 2
                let maxHeight = self.lineHeight * CGFloat(self.parent.maxLines) + totalVerticalPadding
                
                // 5줄이 넘어가면 더이상 높이를 늘리지 않음
                if !(fittingSize.height >= maxHeight) {
                    self.parent.calculatedHeight = fittingSize.height
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var text: String = ""
    @Previewable @State var isReply: Bool = false
    @Previewable @State var textViewHeight: CGFloat = 40
    
    CommentTextField(text: $text, isReply: $isReply, calculatedHeight: $textViewHeight)
        .frame(height: textViewHeight)
}
