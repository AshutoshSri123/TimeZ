import SwiftUI

struct SplashScreenView: View {
    @State private var showTimerSetup = false
    @State private var animateTitle = false
    @State private var animateSubtitle = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // TimeZ Title with animation
                Text("TimeZ")
                    .font(.custom("Helvetica-Bold", size: 64))
                    .foregroundColor(.white)
                    .scaleEffect(animateTitle ? 1.0 : 0.5)
                    .opacity(animateTitle ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 1.0), value: animateTitle)
                
                // Subtitle
                Text("Study Timer for Students")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.9))
                    .opacity(animateSubtitle ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 1.0).delay(0.5), value: animateSubtitle)
                
                Spacer()
                
                // Loading indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                    .opacity(animateSubtitle ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 1.0).delay(1.0), value: animateSubtitle)
                
                Spacer()
            }
        }
        .onAppear {
            animateTitle = true
            animateSubtitle = true
            
            // Auto-transition after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                showTimerSetup = true
            }
        }
        .fullScreenCover(isPresented: $showTimerSetup) {
            TimerSetupView()
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
