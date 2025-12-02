//
//  ContentView.swift
//  DigitalDetoxBreath Watch App
//
//  Created by Aryan Rogye on 11/28/25.
//

import SwiftUI

enum Constants {
    static func haptic(_ type: WKHapticType = .start) {
        WKInterfaceDevice.current().play(type)
    }}

struct ContentView: View {
    
    @State private var startedBreathing = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                if startedBreathing {
                    BreathingSessionView()
                } else {
                    start
                        .contentShape(Rectangle())
                        .onTapGesture {
                            Constants.haptic()
                            startedBreathing = true
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if startedBreathing {
                        Button(action: {
                            Constants.haptic()
                            startedBreathing = false
                        }) {
                            Image(systemName: "arrow.left")
                        }
                    }
                }
            }
            .animation(.easeInOut(duration: 0.5), value: startedBreathing)
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
