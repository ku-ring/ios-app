//
//  CategorySelectView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/02/24.
//

import SwiftUI
import KuringSDK

struct CategorySelectView: UIViewControllerRepresentable {
    @Binding var selectedCategories: [NoticeType]
    
    func makeUIViewController(context: Context) -> CategorySelectViewController {
        let viewController = CategorySelectViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: CategorySelectViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, AlarmTagViewControllerDelegate {
        var parent: CategorySelectView
        
        init(_ categorySelctor: CategorySelectView) {
            parent = categorySelctor
        }
        
        func didSelectCategory(_ selectedCategories: [NoticeType]) {
            parent.selectedCategories = selectedCategories
        }
    }
    
}

struct CategorySelectView_Previews: PreviewProvider {
    static var previews: some View {
        CategorySelectView(selectedCategories: .constant([]))
            .edgesIgnoringSafeArea(.all)
    }
}
