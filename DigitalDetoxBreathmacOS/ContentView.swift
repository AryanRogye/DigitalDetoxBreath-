//
//  ContentView.swift
//  DigitalDetoxBreath Watch App
//
//  Created by Aryan Rogye on 11/28/25.
//

import SwiftUI

enum HapticType {
    case light
    case medium
    case heavy
    case success
    case warning
    case error
    case selection
}

enum Screen {
    case start
    case breathing
    case info
}

enum Constants {
    static func haptic(_ type: HapticType = .medium) {
#if os(watchOS)
        WKInterfaceDevice.current().play(.start)
#elseif os(iOS)
        switch type {
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        }
#elseif os(macOS)
        let manager = NSHapticFeedbackManager.defaultPerformer
        
        switch type {
        case .light, .selection:
            manager.perform(.alignment, performanceTime: .default)
            
        case .medium:
            manager.perform(.alignment, performanceTime: .now)
            
        case .heavy:
            manager.perform(.levelChange, performanceTime: .default)
            
        case .success:
            manager.perform(.levelChange, performanceTime: .now)
            
        case .warning, .error:
            manager.perform(.levelChange, performanceTime: .now)
        }
#else
        /// Nothing
#endif
    }
}

struct ContentView: View {
    
    @State private var screen: Screen = .start

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                switch screen {
                case .start:
                    start
                        .onTapGesture {
                            Constants.haptic()
                            screen = .breathing
                        }
                    
                case .breathing:
                    BreathingSessionView()
                    
                case .info:
                    InfoView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    switch screen {
                    case .start:
                        Button {
                            Constants.haptic()
                            screen = .info
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        
                    case .breathing, .info:
                        Button {
                            Constants.haptic()
                            screen = .start
                        } label: {
                            Image(systemName: "arrow.left")
                        }
                        
                    }
                }
            }
            .animation(.easeInOut(duration: 0.5), value: screen)
        }
    }
    
    private var breathing: some View {
        Text("Are You Ready?")
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .foregroundStyle(.red.opacity(0.3))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var start: some View {
        Text("Tap To Start")
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .foregroundStyle(.red.opacity(0.3))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct BackgroundView: View {
    @State private var glowOpacity: CGFloat = 0
    @State private var glowScale: CGFloat = 0.8
    @State private var particlesActive = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base background with black gradient
                Color.black
                    .overlay(
                        LinearGradient(
                            colors: [
                                Color.black,
                                Color.black.opacity(0.8),
                                Color.black.opacity(0.6)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .ignoresSafeArea()
                
                // Animated glow effect
                Circle()
                    .fill(Color.red)
                    .frame(width: min(geometry.size.width, geometry.size.height) * 0.4)
                    .blur(radius: 35)
                    .opacity(glowOpacity)
                    .scaleEffect(glowScale)
                    .position(
                        x: geometry.size.width * 0.5,
                        y: geometry.size.height * 0.45
                    )
                    .overlay {
                        Circle()
                            .fill(.clear)
                            .overlay {
                                Circle()
                                    .fill(.red)
                                    .opacity(0.4)
                                    .blur(radius: 50)
                            }
                    }
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Glow animation
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            
            glowOpacity = 0.5
            glowScale = 1.2
        }
        
        // Start particles
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            particlesActive = true
        }
    }
}


#Preview {
    ContentView()
}
