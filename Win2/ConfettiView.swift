import SwiftUI

// MARK: - Confetti Particle

struct ConfettiParticle: Identifiable {

    let id = UUID()

    var startX: CGFloat
    var startY: CGFloat

    var x: CGFloat
    var y: CGFloat

    var rotation: Double
    var rotationSpeed: Double

    var scale: CGFloat
    var opacity: Double

    var width: CGFloat
    var height: CGFloat

    var color: Color
}

// MARK: - Falling Confetti Particle

struct FallingConfettiParticle: Identifiable {

    let id = UUID()

    let startX: CGFloat
    let startY: CGFloat

    let endX: CGFloat
    let endY: CGFloat

    let rotation: Double
    let finalRotation: Double

    let width: CGFloat
    let height: CGFloat

    let color: Color

    let delay: Double
    let duration: Double
}

// MARK: - Confetti View

struct ConfettiView: View {

    @State private var particles: [
        ConfettiParticle
    ] = []

    @State private var fallingParticles: [
        FallingConfettiParticle
    ] = []

    @State private var animationID = UUID()

    private let colors: [Color] = [
        .blue,
        .cyan,
        .green,
        .yellow,
        .orange,
        .pink,
        .purple,
        .red
    ]

    var body: some View {

        GeometryReader { geometry in

            ZStack {

                // ==================================================
                // CENTER BURST
                // ==================================================

                ForEach(
                    particles
                ) { particle in

                    RoundedRectangle(
                        cornerRadius: 2
                    )
                    .fill(
                        particle.color
                    )
                    .frame(
                        width:
                            particle.width,
                        height:
                            particle.height
                    )
                    .scaleEffect(
                        particle.scale
                    )
                    .rotationEffect(
                        .degrees(
                            particle.rotation
                        )
                    )
                    .opacity(
                        particle.opacity
                    )
                    .position(
                        x:
                            geometry.size.width / 2,
                        y:
                            geometry.size.height * 0.58
                    )
                    .offset(
                        x:
                            particle.x,
                        y:
                            particle.y
                    )
                }

                // ==================================================
                // FALLING FROM TOP
                // ==================================================

                ForEach(
                    fallingParticles
                ) { particle in

                    FallingConfettiView(
                        particle:
                            particle
                    )
                }

                // ==================================================
                // SPARKLES
                // ==================================================

                ForEach(
                    0..<18,
                    id: \.self
                ) { index in

                    SparkleView(
                        delay:
                            Double(index) * 0.03
                    )
                    .position(
                        x:
                            geometry.size.width * 0.5,
                        y:
                            geometry.size.height * 0.45
                    )
                }
            }

            .id(animationID)

            .onAppear {

                launchConfetti(
                    size:
                        geometry.size
                )

                launchTopConfetti(
                    size:
                        geometry.size
                )
            }
        }

        .ignoresSafeArea()

        .allowsHitTesting(false)
    }

    // MARK: - Launch Confetti

    private func launchConfetti(
        size: CGSize
    ) {

        let particleCount = 90

        var newParticles: [
            ConfettiParticle
        ] = []

        for _ in 0..<particleCount {

            let angle =
                Double.random(
                    in:
                        -Double.pi * 0.95 ...
                        -Double.pi * 0.05
                )

            let velocity =
                CGFloat.random(
                    in:
                        180...420
                )

            let xVelocity =
                cos(angle) * velocity

            let yVelocity =
                sin(angle) * velocity

            let particle =
                ConfettiParticle(

                    startX: 0,

                    startY: 0,

                    x:
                        xVelocity,

                    y:
                        yVelocity,

                    rotation:
                        Double.random(
                            in:
                                0...360
                        ),

                    rotationSpeed:
                        Double.random(
                            in:
                                -720...720
                        ),

                    scale:
                        CGFloat.random(
                            in:
                                0.7...1.2
                        ),

                    opacity: 1,

                    width:
                        CGFloat.random(
                            in:
                                7...12
                        ),

                    height:
                        CGFloat.random(
                            in:
                                14...24
                        ),

                    color:
                        colors.randomElement()
                        ?? .blue
                )

            newParticles.append(
                particle
            )
        }

        particles =
            newParticles

        // ------------------------------------------------
        // First burst
        // ------------------------------------------------

        withAnimation(
            .easeOut(
                duration:
                    0.75
            )
        ) {

            for index
                in particles.indices {

                particles[index].x *=
                    1.15

                particles[index].y *=
                    0.9

                particles[index].rotation +=
                    particles[index]
                    .rotationSpeed * 0.45
            }
        }

        // ------------------------------------------------
        // Gravity / falling
        // ------------------------------------------------

        DispatchQueue.main.asyncAfter(
            deadline:
                .now() + 0.7
        ) {

            withAnimation(
                .easeIn(
                    duration:
                        1.7
                )
            ) {

                for index
                    in particles.indices {

                    let gravity =
                        CGFloat.random(
                            in:
                                260...430
                        )

                    particles[index].y +=
                        gravity

                    particles[index].x +=
                        CGFloat.random(
                            in:
                                -80...80
                        )

                    particles[index].rotation +=
                        particles[index]
                        .rotationSpeed

                    particles[index].opacity =
                        0
                }
            }
        }

        // ------------------------------------------------
        // Second burst
        // ------------------------------------------------

        DispatchQueue.main.asyncAfter(
            deadline:
                .now() + 0.35
        ) {

            launchSideBurst(
                fromLeft:
                    true
            )

            launchSideBurst(
                fromLeft:
                    false
            )
        }
    }

    // MARK: - Top Falling Confetti

    private func launchTopConfetti(
        size: CGSize
    ) {

        var newParticles: [
            FallingConfettiParticle
        ] = []

        let particleCount = 60

        for _ in 0..<particleCount {

            let startX =
                CGFloat.random(
                    in:
                        0...size.width
                )

            let horizontalMovement =
                CGFloat.random(
                    in:
                        -180...180
                )

            let endX =
                min(
                    max(
                        startX +
                            horizontalMovement,
                        -50
                    ),
                    size.width + 50
                )

            let startY =
                CGFloat.random(
                    in:
                        -120...(-20)
                )

            let endY =
                size.height +
                CGFloat.random(
                    in:
                        50...180
                )

            let particle =
                FallingConfettiParticle(

                    startX:
                        startX,

                    startY:
                        startY,

                    endX:
                        endX,

                    endY:
                        endY,

                    rotation:
                        Double.random(
                            in:
                                -180...180
                        ),

                    finalRotation:
                        Double.random(
                            in:
                                -1080...1080
                        ),

                    width:
                        CGFloat.random(
                            in:
                                6...11
                        ),

                    height:
                        CGFloat.random(
                            in:
                                14...24
                        ),

                    color:
                        colors.randomElement()
                        ?? .blue,

                    delay:
                        Double.random(
                            in:
                                0...1.2
                        ),

                    duration:
                        Double.random(
                            in:
                                2.4...3.8
                        )
                )

            newParticles.append(
                particle
            )
        }

        fallingParticles =
            newParticles
    }

    // MARK: - Side Burst

    private func launchSideBurst(
        fromLeft: Bool
    ) {

        var sideParticles: [
            ConfettiParticle
        ] = []

        for _ in 0..<25 {

            let direction: CGFloat =
                fromLeft
                ? 1
                : -1

            sideParticles.append(
                ConfettiParticle(

                    startX: 0,

                    startY: 0,

                    x:
                        direction *
                        CGFloat.random(
                            in:
                                100...350
                        ),

                    y:
                        CGFloat.random(
                            in:
                                -250...100
                        ),

                    rotation:
                        Double.random(
                            in:
                                0...360
                        ),

                    rotationSpeed:
                        Double.random(
                            in:
                                -900...900
                        ),

                    scale:
                        CGFloat.random(
                            in:
                                0.6...1.1
                        ),

                    opacity: 1,

                    width:
                        CGFloat.random(
                            in:
                                6...11
                        ),

                    height:
                        CGFloat.random(
                            in:
                                12...22
                        ),

                    color:
                        colors.randomElement()
                        ?? .yellow
                )
            )
        }

        particles.append(
            contentsOf:
                sideParticles
        )

        let startIndex =
            particles.count -
            sideParticles.count

        withAnimation(
            .easeOut(
                duration:
                    1.8
            )
        ) {

            for index
                in startIndex..<particles.count {

                particles[index].y +=
                    CGFloat.random(
                        in:
                            300...500
                    )

                particles[index].rotation +=
                    particles[index]
                    .rotationSpeed

                particles[index].opacity =
                    0
            }
        }
    }
}

// MARK: - Falling Confetti View

struct FallingConfettiView: View {

    let particle:
        FallingConfettiParticle

    @State private var isFalling =
        false

    var body: some View {

        RoundedRectangle(
            cornerRadius: 2
        )
        .fill(
            particle.color
        )
        .frame(
            width:
                particle.width,

            height:
                particle.height
        )
        .rotationEffect(
            .degrees(
                isFalling
                ? particle.finalRotation
                : particle.rotation
            )
        )
        .position(
            x:
                isFalling
                ? particle.endX
                : particle.startX,

            y:
                isFalling
                ? particle.endY
                : particle.startY
        )
        .opacity(
            isFalling
            ? 0
            : 1
        )
        .onAppear {

            DispatchQueue.main.asyncAfter(
                deadline:
                    .now()
                    + particle.delay
            ) {

                withAnimation(
                    .easeIn(
                        duration:
                            particle.duration
                    )
                ) {

                    isFalling =
                        true
                }
            }
        }
    }
}

// MARK: - Sparkle

struct SparkleView: View {

    @State private var visible =
        false

    let delay: Double

    var body: some View {

        Image(
            systemName:
                "sparkle"
        )
        .font(
            .system(
                size:
                    16,
                weight:
                    .bold
            )
        )
        .foregroundStyle(
            .yellow
        )
        .scaleEffect(
            visible
            ? 1
            : 0.1
        )
        .opacity(
            visible
            ? 0
            : 1
        )
        .animation(
            .easeOut(
                duration:
                    0.9
            )
            .delay(
                delay
            ),
            value:
                visible
        )
        .onAppear {

            visible = true
        }
    }
}

// MARK: - Preview

#Preview {

    ZStack {

        Color.white
            .ignoresSafeArea()

        ConfettiView()
    }
}
