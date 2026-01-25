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

final class BattleTimerViewModel: ObservableObject {

    @Published private(set) var currentPhase: BattlePhase = .countdown
    @Published private(set) var timeRemaining: Int = 15
    @Published private(set) var victoryTime: Int = 20
    @Published private(set) var isVisible: Bool = true

    private var cancellable: AnyCancellable?

    init() {
        start()
    }

    func start() {
        cancellable?.cancel()

        cancellable = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task { await self?.tick() }
            }
    }

    func stop() {
        cancellable?.cancel()
    }

    private func tick() async {
        switch currentPhase {

        case .countdown:
            guard timeRemaining > 1 else {
                currentPhase = .alarm
                return
            }
            timeRemaining -= 1

            if timeRemaining == 10 {
                await HapticToolbox.shared.playVibrate()
            }

        case .alarm:
            if timeRemaining > -3 {
                timeRemaining -= 1
            } else {
                currentPhase = .victoryLap
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

    deinit {
        stop()
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
                timerView
                    .transition(.opacity)
            } else {
                Text("Battle is over")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.red)
                    .cornerRadius(12, corners: .allCorners)
                    .transition(.opacity)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }

    private var timerView: some View {
        HStack(spacing: spacing) {
            icon

            Text(timerText)
                .font(.system(size: fontSize, weight: fontWeight, design: .rounded))
                .foregroundStyle(timerColor)
                .scaleEffect(pulseScale)
        }
        .frame(width: width, height: 24)
        .padding(.horizontal, 11)
        .background(backgroundColor)
        .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
    }

    // MARK: Derived values
    private var pulseScale: CGFloat {
        if vm.currentPhase == .countdown && vm.timeRemaining <= 10 {
            return vm.timeRemaining % 2 == 0 ? 1.0 : 1.2
        }
        if vm.currentPhase == .alarm {
            return vm.timeRemaining % 2 == 0 ? 1.0 : 1.2
        }
        return 1.0
    }

    private var timerText: String {
        vm.currentPhase.displayText(timeRemaining: vm.timeRemaining, victoryTime: vm.victoryTime)
    }

    private var width: CGFloat {
        switch vm.currentPhase {
        case .countdown: return vm.timeRemaining <= 10 ? 50 : 70
        case .victoryLap: return 145
        case .alarm: return 50
        }
    }

    private var spacing: CGFloat {
        (vm.currentPhase == .countdown && vm.timeRemaining <= 10) ? 8 : 5
    }

    private var timerColor: Color {
        (vm.currentPhase == .countdown && vm.timeRemaining <= 10) ? .yellow : .white
    }

    private var backgroundColor: Color {
        vm.currentPhase == .alarm ? .red : Color.black.opacity(0.6)
    }

    private var fontSize: CGFloat {
        (vm.currentPhase == .countdown && vm.timeRemaining <= 10) ? 18 : 16
    }

    private var fontWeight: Font.Weight {
        (vm.currentPhase == .countdown && vm.timeRemaining <= 10) ? .semibold : .medium
    }

    private var icon: some View {
        Group {
            if vm.currentPhase == .countdown {
                Image(systemName: "bolt.fill")
                    .frame(width: 16, height: 16)
                    .foregroundStyle(
                        LinearGradient(colors: [.pink, .purple, .blue],
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )
            } else if vm.currentPhase == .alarm {
                Image(systemName: "alarm.fill")
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white)
                    .scaleEffect(pulseScale)
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
