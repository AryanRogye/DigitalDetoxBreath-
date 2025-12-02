//
//  InfoView.swift
//  DigitalDetoxBreath
//
//  Created by Aryan Rogye on 12/1/25.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Digital Detox")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                
                Text("Inspired by *Digital Minimalism* by Cal Newport.")
                
                Text("You can’t always step away from your phone,")
                Text("but you can use your devices intentionally:")
                
                Text("• Pause\n• Breathe\n• Reset before you scroll")
            }
            .font(.system(size: 12, weight: .regular, design: .rounded))
            .multilineTextAlignment(.leading)
            .foregroundStyle(.red.opacity(0.7))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}
