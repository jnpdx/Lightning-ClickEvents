//
//  ContentView.swift
//  ClickEvents
//
//  Created by John Nastos on 10/28/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            ToggleDemo()
                .frame(maxWidth: .infinity)
            Divider()
            EventDemo()
                .frame(maxWidth: .infinity)
        }
        .preferredColorScheme(.dark)
        .frame(width: 800, height: 400)
    }
}

struct ToggleDemo: View {
    @State private var clicked = false
    
    var body: some View {
        VStack {
            Arrow(clicked: clicked)
                .onTapGesture {
                    withAnimation(.linear(duration: 0.5)) {
                        clicked.toggle()
                    }
                }
        }
        .padding()
    }
}

struct ClickEvent: Identifiable, Equatable {
    var id = UUID()
    var timestamp = Date()
}

struct Arrow: View {
    var clicked: Bool
    
    var body: some View {
        Image(systemName: "arrow.right")
            .resizable()
            .frame(width: 150, height: 150)
            .scaleEffect(clicked ? 1.5 : 1.0)
            .foregroundColor(clicked ? .red : .white)
            .shadow(color: clicked ? .purple : .clear, radius: 40)
            .rotationEffect(clicked ? .degrees(360) : .degrees(0))
    }
}

struct EventDemo: View {
    @State private var currentEvent: ClickEvent?
    
    var clicked: Bool {
        currentEvent != nil
    }
    
    var body: some View {
        VStack {
            Arrow(clicked: clicked)
                .onTapGesture {
                    withAnimation(.linear(duration: 0.5)) {
                        let event = ClickEvent()
                        currentEvent = event
                        Task {
                            try? await Task.sleep(nanoseconds: NSEC_PER_SEC)
                            if currentEvent?.id == event.id {
                                withAnimation(.linear(duration: 0.5)) {
                                    currentEvent = nil
                                }
                            }
                        }
                    }
                }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
