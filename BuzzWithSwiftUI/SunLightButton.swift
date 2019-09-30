//
//  SunLightButton.swift
//  BuzzWithSwiftUI
//
//  Created by James Hillhouse IV on 9/29/19.
//  Copyright © 2019 PortableFrontier. All rights reserved.
//

import SwiftUI

struct SunLightButton: View {
        @Binding var sunlightSwitch: Int

        var body: some View {
            Button(action: {
                self.sunlightSwitch += 1

                if self.sunlightSwitch == 4 {
                    self.sunlightSwitch = 0
                }
                print("Setting sunlightSwitch: \(self.sunlightSwitch)")
                }) {
                    Image(systemName: "sun.max.fill")
                        .imageScale(.large)
                        .accessibility(label: Text("Sunlight"))
                        .padding()
                }

        }
    }

/*
struct SunLightButton_Previews: PreviewProvider {
    static var previews: some View {
        SunLightButton()
    }
}
 */
