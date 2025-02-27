//
//  OffsetPageTabView.swift
//  Caffeine
//
//  Created by 김상진 on 2023/05/19.
//

import SwiftUI

struct OffsetPageTabView<Content: View>: UIViewRepresentable {
    
    var content: Content
    @Binding var offset: CGFloat
    
    init(offset: Binding<CGFloat>, @ViewBuilder content: @escaping ()->Content) {
        self.content = content()
        self._offset = offset
    }
    
    func makeCoordinator() -> Coordinator {
        return OffsetPageTabView.Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        
        // SwiftUI 뷰를 받아서 UIKit의 ScrollView에 넣어주는 것이다.
        let hostview = UIHostingController(rootView: content)
        hostview.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            hostview.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostview.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostview.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostview.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            hostview.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ]
        
        scrollView.addSubview(hostview.view)
        scrollView.addConstraints(constraints)
        
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.delegate = context.coordinator
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        let currentOffet = uiView.contentOffset.x
        
        if currentOffet != offset {
            uiView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: OffsetPageTabView
        
        init(parent: OffsetPageTabView) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x
            
            parent.offset = offset
        }
    }
}

//struct OffsetPageTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        OffsetPageTabView()
//    }
//}
