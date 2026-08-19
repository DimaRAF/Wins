import SwiftUI

// MARK: - Particle Model

struct ConfettiParticle: Identifiable {
    let id = UUID()

    var xOffset: CGFloat = 0
    var yOffset: CGFloat = 0
    var scale: CGFloat = 0.2
    var opacity: Double = 1.0
    var color: Color
}

// MARK: - Confetti View

struct ConfettiView: View {

    @State private var particles: [ConfettiParticle] = []

    private let colors: [Color] = [
        .red,
        .yellow,
        .blue,
        .green,
        .orange,
        .purple,
        .pink
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(
                            width: 12,
                            height: 12
                        )
                        .scaleEffect(
                            particle.scale
                        )
                        .opacity(
                            particle.opacity
                        )
                        .position(
                            x: geometry.size.width / 2,
                            y: geometry.size.height / 2
                        )
                        .offset(
                            x: particle.xOffset,
                            y: particle.yOffset
                        )
                }
            }
            .onAppear {
                launchFireworks()
            }
        }
        .allowsHitTesting(false)
    }

    // MARK: - Launch

    private func launchFireworks() {

        let particleCount = 60

        var newParticles: [ConfettiParticle] = []

        for _ in 0..<particleCount {

            let randomColor =
                colors.randomElement() ?? .yellow

            newParticles.append(
                ConfettiParticle(
                    color: randomColor
                )
            )
        }

        particles = newParticles

        withAnimation(
            .easeOut(duration: 1.2)
        ) {
            for i in particles.indices {

                // Move upward
                particles[i].yOffset =
                    CGFloat.random(
                        in: -350 ... -150
                    )

                // Spread left and right
                particles[i].xOffset =
                    CGFloat.random(
                        in: -120 ... 120
                    )

                particles[i].scale =
                    CGFloat.random(
                        in: 0.8 ... 1.5
                    )

                particles[i].opacity = 0
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ConfettiView()
}
