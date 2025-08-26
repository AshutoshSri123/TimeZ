import SwiftUI

struct SummaryView: View {
    @ObservedObject var timerModel: QuestionTimerModel
    @State private var showingSetup = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        Text("Session Complete!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Here's your performance summary")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Statistics cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        StatCard(title: "Completed", value: "\(timerModel.getCompletedQuestions())", color: .green)
                        StatCard(title: "Skipped", value: "\(timerModel.getSkippedQuestions())", color: .orange)
                        StatCard(title: "Timeout", value: "\(timerModel.getTimeoutQuestions())", color: .red)
                        StatCard(title: "Total Time", value: TimerManager.formatTime(timerModel.getTotalTimeSpent()), color: .blue)
                    }
                    .padding(.horizontal)
                    
                    // Detailed question table
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Question Details")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            // Table header
                            HStack {
                                Text("Q#")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .frame(width: 30)
                                
                                Text("Time")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .frame(width: 60)
                                
                                Text("Status")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("Ext.")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .frame(width: 30)
                            }
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.2))
                            
                            // Table rows
                            ForEach(timerModel.questions.indices, id: \.self) { index in
                                let question = timerModel.questions[index]
                                HStack {
                                    Text("\(question.questionNumber)")
                                        .font(.caption)
                                        .frame(width: 30)
                                    
                                    Text(TimerManager.formatTime(question.timeSpent))
                                        .font(.caption)
                                        .frame(width: 60)
                                    
                                    HStack {
                                        Circle()
                                            .fill(statusColor(question.status))
                                            .frame(width: 8, height: 8)
                                        
                                        Text(question.status.rawValue)
                                            .font(.caption)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("\(question.extensionsUsed)")
                                        .font(.caption)
                                        .frame(width: 30)
                                }
                                .padding(.vertical, 6)
                                .background(index % 2 == 0 ? Color.clear : Color.gray.opacity(0.05))
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                    
                    // Action buttons
                    VStack(spacing: 15) {
                        Button(action: {
                            timerModel.resetSession()
                            showingSetup = true
                        }) {
                            Text("Start New Session")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(15)
                        }
                        
                        ShareLink(
                            item: generateShareText(),
                            subject: Text("TimeZ Session Results")
                        ) {
                            Text("Share Results")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(15)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
        }
        .fullScreenCover(isPresented: $showingSetup) {
            TimerSetupView()
        }
    }
    
    private func statusColor(_ status: QuestionStatus) -> Color {
        switch status {
        case .done:
            return .green
        case .skipped:
            return .orange
        case .timeout:
            return .red
        case .pending:
            return .gray
        }
    }
    
    private func generateShareText() -> String {
        let completed = timerModel.getCompletedQuestions()
        let skipped = timerModel.getSkippedQuestions()
        let timeout = timerModel.getTimeoutQuestions()
        let totalTime = TimerManager.formatTime(timerModel.getTotalTimeSpent())
        
        return """
        TimeZ Session Results 📊
        
        Total Questions: \(timerModel.totalQuestions)
        ✅ Completed: \(completed)
        ⏭️ Skipped: \(skipped)
        ⏰ Timeout: \(timeout)
        ⏱️ Total Time: \(totalTime)
        
        Generated by TimeZ - Study Timer App
        """
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 1)
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let model = QuestionTimerModel()
        model.setupSession(questions: 5, timePerQuestion: 120)
        // Add some sample data
        model.questions = [
            QuestionData(questionNumber: 1, timeSpent: 90, status: .done, extensionsUsed: 0),
            QuestionData(questionNumber: 2, timeSpent: 150, status: .done, extensionsUsed: 1),
            QuestionData(questionNumber: 3, timeSpent: 60, status: .skipped, extensionsUsed: 0),
            QuestionData(questionNumber: 4, timeSpent: 120, status: .timeout, extensionsUsed: 0),
            QuestionData(questionNumber: 5, timeSpent: 80, status: .done, extensionsUsed: 0)
        ]
        return SummaryView(timerModel: model)
    }
}
