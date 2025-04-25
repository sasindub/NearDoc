import SwiftUI

struct SplashScreenView: View {
    @State private var animate = false
    @State private var scaleEffect: CGFloat = 0.8

    var body: some View {
        ZStack {
            // Gradient background for a modern feel
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 24) {
                // Circle glow with animation
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 180, height: 180)
                        .blur(radius: 20)
                        .scaleEffect(animate ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animate)

                    Image(systemName: "cross.case.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .foregroundColor(.white)
                        .scaleEffect(scaleEffect)
                        .shadow(color: .white.opacity(0.6), radius: 10, x: 0, y: 4)
                        .animation(.spring(response: 1.2, dampingFraction: 0.6), value: scaleEffect)
                }

                // App Title with modern typography
                Text("NearDoc")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)

                Text("Find your nearest family doctor")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .onAppear {
            animate = true
            scaleEffect = 1.0
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
