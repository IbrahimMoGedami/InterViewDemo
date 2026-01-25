//
//  ContentView.swift
//  InterViewDemo
//
//  Created by Ibrahim Mo Gedami on 02/12/2025.
//

import SwiftUI
import Combine

// MARK: - Battle States
enum BattlePhase {
    case countdown
    case alarm
    case victoryLap
}

extension BattlePhase {
    var isCountdown: Bool { self == .countdown }
    var isAlarm: Bool { self == .alarm }
    var isVictoryLap: Bool { self == .victoryLap }
}

// MARK: - ViewModel
@MainActor
final class BattleTimerViewModel: ObservableObject {

    // MARK: - Published
    @Published private(set) var currentPhase: BattlePhase = .countdown
    @Published private(set) var timeRemaining: Int = 15
    @Published private(set) var victoryTime: Int = 20
    @Published private(set) var showAlarm: Bool = false
    @Published private(set) var isVisible: Bool = true
    @Published private(set) var pulseScale: CGFloat = 1.0

    private var task: Task<Void, Never>?

    var timerFontWeight: Font.Weight {
        if currentPhase.isCountdown && timeRemaining <= 10 {
            return .semibold
        }
        return .medium
    }
    
    var timerFontSize: CGFloat {
        if currentPhase.isCountdown && timeRemaining <= 10 {
            return 18
        }
        return 16
    }

    init() {
        start()
    }

    func start() {
        task?.cancel()

        task = Task { [weak self] in
            guard let self else { return }

            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                await tick()
            }
        }
    }

    func stop() {
        task?.cancel()
    }

    private func tick() async {
        switch currentPhase {

        case .countdown:
            guard timeRemaining > 1 else {
                currentPhase = .alarm
                showAlarm = true
                pulseScale = 1.0
                return
            }

            timeRemaining -= 1
            if timeRemaining <= 10 && timeRemaining > 0 {
                pulseScale = pulseScale == 1.0 ? 1.2 : 1.0
            }
            
            if timeRemaining == 10 {
                Task {
                    await HapticToolbox.shared.playVibrate()
                }
            }

        case .alarm:
            if timeRemaining > -3 {
                timeRemaining -= 1
                pulseScale = pulseScale == 1.0 ? 1.2 : 1.0
            } else {
                showAlarm = false
                currentPhase = .victoryLap
                pulseScale = 1.0
                timeRemaining = victoryTime
            }

        case .victoryLap:
            if victoryTime > 0 {
                victoryTime -= 1
            } else {
                isVisible = false
                stop()
            }
        }
    }

    // MARK: - Computed values for View
    var timerText: String {
        currentPhase.displayText(timeRemaining: timeRemaining, victoryTime: victoryTime)
    }

    var timerWidth: CGFloat {
        switch currentPhase {
        case .countdown:
            return timeRemaining <= 10 ? 50 : 70
        case .victoryLap:
            return 145
        case .alarm:
            return 50
        }
    }
    
    var timerColor: Color {
        if currentPhase.isCountdown && timeRemaining <= 10 {
            return .yellow
        }
        return .white
    }
    var space: CGFloat {
        if currentPhase.isCountdown && timeRemaining <= 10 {
            return 8
        }
        return 5
    }
    
    var backgroundColor: Color {
        showAlarm ? .red : Color.black.opacity(0.6)
    }

    deinit {
        task?.cancel()
    }
}

// MARK: - Helper Extension for Text Formatting
private extension BattlePhase {
    func displayText(timeRemaining: Int, victoryTime: Int) -> String {
           switch self {
           case .countdown:
               if timeRemaining <= 10 {
                   return "\(max(timeRemaining, 0))"
               }
               return formatTime(timeRemaining)

           case .victoryLap:
               return "Victory Lap \(formatTime(victoryTime))"

           case .alarm:
               return ""
           }
       }

       private func formatTime(_ seconds: Int) -> String {
           let seconds = max(seconds, 0)
           let minutes = seconds / 60
           let remainder = seconds % 60
           return String(format: "%02d:%02d", minutes, remainder)
       }

}

// MARK: - View
struct TikTokBattleTimerBadge: View {

    @StateObject private var vm = BattleTimerViewModel()

    var body: some View {
        VStack {
            Spacer()
            
            if vm.isVisible {
                HStack(spacing: 0) {
                    content
                }
                .frame(width: vm.timerWidth, height: 24)
                .padding(.horizontal, 11)
                .background(vm.backgroundColor)
                .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
                .transition(.opacity)
            } else {
                Text("Game is over")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(12)
                    .transition(.opacity)
            }

            Spacer()
        }
    }
    
    private var content: some View {
        HStack(spacing: vm.space) {
            icon
            
            Text(vm.timerText)
                .font(.system(size: vm.timerFontSize, weight: vm.timerFontWeight, design: .rounded))
                .foregroundStyle(vm.timerColor)
                .scaleEffect(vm.pulseScale)
        }
    }
    
    private var icon: some View {
        Group {
            if case .countdown = vm.currentPhase {
                Image(systemName: "bolt.fill")
                    .frame(width: 16, height: 16)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.pink, .purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            } else if case .alarm = vm.currentPhase {
                Image(systemName: "alarm.fill")
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white)
                    .scaleEffect(vm.pulseScale)
            }
        }
    }

}

// MARK: - Preview
#Preview {
    TikTokBattleTimerBadge()
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
