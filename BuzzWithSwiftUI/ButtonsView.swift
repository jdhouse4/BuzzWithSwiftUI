//
//  ButtonsView.swift
//  BuzzWithSwiftUI
//
//  Created by James Hillhouse IV on 9/18/19.
//  Copyright © 2019 PortableFrontier. All rights reserved.
//

import SwiftUI



struct ButtonsView:UIViewRepresentable
{
    var tappedCallback: ((CGPoint) -> Void)



    func makeUIView(context: Context) -> UIView {
        let v = UIView(frame: .zero)
        let gesture = UITapGestureRecognizer(target: context.coordinator,
                                             action: #selector(Coordinator.tapped))
        v.addGestureRecognizer(gesture)
        return v
    }

    

    func updateUIView(_ uiView: UIView,
                      context: Context) {
    }

    func makeCoordinator() -> ButtonsView.Coordinator {
        return Coordinator(tappedCallback:self.tappedCallback)
    }



    class Coordinator: NSObject {
        var tappedCallback: ((CGPoint) -> Void)


        init(tappedCallback: @escaping ((CGPoint) -> Void)) {
            self.tappedCallback = tappedCallback
        }


        @objc func tapped(gesture:UITapGestureRecognizer) {
            let point = gesture.location(in: gesture.view)
            self.tappedCallback(point)
        }
    }


}
