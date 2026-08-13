import SwiftUI

struct SplashView: View {
    @AppStorage("onboardingStep") private var onboardingStep: Int = 0 
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(spacing: 12) {
                ZStack {
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                }
                
                Text("Stride")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.1, green: 0.12, blue: 0.15))
            }
            .padding(.top, 16)
            .padding(.horizontal, 28)
            
            Spacer()
            
            ZStack {
                ConcentricArcsView()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 320)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("A New Goal Starts Here")
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .foregroundColor(Color(red: 0.08, green: 0.1, blue: 0.13))
                    .lineSpacing(2)
                
                Text("Build consistency toward your goals,\none day at a time.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(red: 0.5, green: 0.53, blue: 0.58))
                    .lineSpacing(4)
            }
            .padding(.horizontal, 28)
            
            Spacer()
                .frame(height: 40)
            
            Button(action: {
                withAnimation {
                    onboardingStep = 1
                                }
            }) {
                Text("Get Started")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.22, green: 0.58, blue: 0.80),
                                Color(red: 0.43, green: 0.72, blue: 0.86)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(color: Color(red: 0.22, green: 0.58, blue: 0.80).opacity(0.35), radius: 15, x: 0, y: 8)
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 20)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.99).ignoresSafeArea())
    }
}

struct ConcentricArcsView: View {
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2 + 10)
            
            context.fill(
                Path(ellipseIn: CGRect(x: center.x - 18, y: center.y - 18, width: 36, height: 36)),
                with: .color(Color(red: 0.22, green: 0.58, blue: 0.80).opacity(0.12))
            )
            context.fill(
                Path(ellipseIn: CGRect(x: center.x - 7, y: center.y - 7, width: 14, height: 14)),
                with: .color(Color(red: 0.22, green: 0.58, blue: 0.80))
            )
            
            let blueColor = Color(red: 0.35, green: 0.62, blue: 0.82).opacity(0.4)
            let redColor = Color(red: 0.93, green: 0.62, blue: 0.62).opacity(0.4)
            
            let radii: [(CGFloat, Color, Double, Double)] = [
                (35, redColor, 180, 360),
                (55, blueColor, 150, 340),
                (75, redColor, 120, 310),
                (95, blueColor, 100, 280),
                (115, blueColor, 80, 260),
                (135, redColor, 70, 240),
                (155, blueColor, 60, 220)
            ]
            
            for arc in radii {
                var path = Path()
                path.addArc(
                    center: center,
                    radius: arc.0,
                    startAngle: .degrees(arc.2),
                    endAngle: .degrees(arc.3),
                    clockwise: false
                )
                
                context.stroke(
                    path,
                    with: .color(arc.1),
                    style: StrokeStyle(lineWidth: 1.5, lineCap: .round)
                )
            }
            
            // Floating Orbit Dots
            let dots: [(CGFloat, Double, Color)] = [
                (55, 210, blueColor),
                (75, 300, redColor),
                (95, 140, blueColor),
                (135, 330, redColor)
            ]
            
            for dot in dots {
                let rad = dot.1 * .pi / 180
                let x = center.x + dot.0 * cos(rad)
                let y = center.y + dot.0 * sin(rad)
                context.fill(
                    Path(ellipseIn: CGRect(x: x - 3, y: y - 3, width: 6, height: 6)),
                    with: .color(dot.2)
                )
            }
        }
    }
}

#Preview {
    SplashView()
}
