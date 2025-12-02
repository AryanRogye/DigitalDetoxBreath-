//
//  BreathingSessionView.swift
//  DigitalDetoxBreath Watch App
//
//  Created by Aryan Rogye on 11/28/25.
//

import SwiftUI

struct BreathingSessionView: View {
    enum Phase {
        case inhale, hold, exhale
    }
    
    @State private var phase: Phase = .inhale
    @State private var scale: CGFloat = 0.8
    @State private var label: String = "Inhale"
    
    // 4–4–4 pattern (seconds)
    private let inhaleDuration: Double = 4
    private let holdDuration: Double = 4
    private let exhaleDuration: Double = 4
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 8) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 110, height: 110)
                    .scaleEffect(scale)
                    .animation(.easeInOut(duration: currentDuration), value: scale)
                
                Text(label)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.red.opacity(0.7))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            startBreathingLoop()
        }
    }
    
    private var currentDuration: Double {
        switch phase {
        case .inhale: return inhaleDuration
        case .hold:   return holdDuration
        case .exhale: return exhaleDuration
        }
    }
    
    private func startBreathingLoop() {
        // kick off first phase
        advancePhase()
    }
    
    private func advancePhase() {
        switch phase {
        case .inhale:
            // animate to “big”
            label = "Inhale"
            Constants.haptic(.directionUp)
            scale = 1.2
            
            DispatchQueue.main.asyncAfter(deadline: .now() + inhaleDuration) {
                phase = .hold
                advancePhase()
            }
            
        case .hold:
            label = "Hold"
            Constants.haptic(.notification)
            // tiny pulse
            scale = 1.25
            
            DispatchQueue.main.asyncAfter(deadline: .now() + holdDuration) {
                phase = .exhale
                advancePhase()
            }
            
        case .exhale:
            label = "Exhale"
            Constants.haptic(.directionDown)
            // animate to “small”
            scale = 0.85
            
            DispatchQueue.main.asyncAfter(deadline: .now() + exhaleDuration) {
                phase = .inhale
                advancePhase()   // loop back
            }
        }
    }
}
