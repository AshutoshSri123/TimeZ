import SwiftUI

struct QuestionTimerView: View {
    @ObservedObject var timerModel: QuestionTimerModel
    @State private var showingSummary = false
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.05).ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header with progress
                VStack(spacing: 15) {
                    HStack {
                        Text("Question \(timerModel.currentQuestion)")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text("\(timerModel.currentQuestion)/\(timerModel.totalQuestions)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Progress bar
                    ProgressView(value: Double(timerModel.currentQuestion), total: Double(timerModel.totalQuestions))
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Timer display
                VStack(spacing: 20) {
                    Text(TimerManager.formatTime(timerModel.currentTime))
                        .font(.system(size: 72, weight: .bold, design: .monospaced))
                        .foregroundColor(TimerManager.getTimeColor(for: timerModel.currentTime))
                        .scaleEffect(timerModel.currentTime <= 10 ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.5), value: timerModel.currentTime)
                    
                    // Start/Stop button
                    Button(action: {
                        if timerModel.isRunning {
                            timerModel.stopTimer()
                        } else {
                            timerModel.startTimer()
                        }
                    }) {
                        Image(systemName: timerModel.isRunning ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 20) {
                    Button(action: {
                        timerModel.markQuestionSkipped()
                    }) {
                        Text("Skip")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(15)
                    }
                    
                    Button(action: {
                        timerModel.markQuestionDone()
                    }) {
                        Text("Done")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .alert("Add More Time?", isPresented: $timerModel.showExtensionAlert) {
            Button("30 seconds") {
                timerModel.addExtension(seconds: 30)
            }
            Button("1 minute") {
                timerModel.addExtension(seconds: 60)
            }
            Button("No, continue") {
                timerModel.declineExtension()
            }
        } message: {
            Text("Would you like to add extra time for this question?")
        }
        .fullScreenCover(isPresented: $timerModel.sessionCompleted) {
            SummaryView(timerModel: timerModel)
        }
        .onAppear {
            timerModel.startTimer()
        }
        .onDisappear {
            timerModel.stopTimer()
        }
    }
}

struct QuestionTimerView_Previews: PreviewProvider {
    static var previews: some View {
        let model = QuestionTimerModel()
        model.setupSession(questions: 5, timePerQuestion: 120)
        return QuestionTimerView(timerModel: model)
    }
}
