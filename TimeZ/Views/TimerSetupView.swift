import SwiftUI

struct TimerSetupView: View {
    @StateObject private var timerModel = QuestionTimerModel()
    @State private var selectedMinutes: Int = 2
    @State private var selectedSeconds: Int = 0
    @State private var numberOfQuestions: Int = 10
    @State private var showQuestionTimer = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color.gray.opacity(0.1).ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 10) {
                        Text("Setup Your Session")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Configure your study timer")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Time per question section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Time per Question")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 20) {
                            // Minutes picker
                            VStack {
                                Text("Minutes")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Picker("Minutes", selection: $selectedMinutes) {
                                    ForEach(0...10, id: \.self) { minute in
                                        Text("\(minute)").tag(minute)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 80, height: 120)
                            }
                            
                            // Seconds picker
                            VStack {
                                Text("Seconds")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Picker("Seconds", selection: $selectedSeconds) {
                                    ForEach(Array(stride(from: 0, through: 59, by: 5)), id: \.self) { second in
                                        Text("\(second)").tag(second)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 80, height: 120)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                    
                    // Number of questions section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Number of Questions")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            Button(action: {
                                if numberOfQuestions > 1 {
                                    numberOfQuestions -= 1
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                            
                            Spacer()
                            
                            Text("\(numberOfQuestions)")
                                .font(.title)
                                .fontWeight(.semibold)
                                .frame(minWidth: 50)
                            
                            Spacer()
                            
                            Button(action: {
                                if numberOfQuestions < 100 {
                                    numberOfQuestions += 1
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                    
                    // Preview section
                    VStack(spacing: 10) {
                        Text("Session Preview")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("\(numberOfQuestions) questions • \(TimerManager.formatTime(selectedMinutes * 60 + selectedSeconds)) each")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Total Time: \(TimerManager.formatTime((selectedMinutes * 60 + selectedSeconds) * numberOfQuestions))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    // Start button
                    Button(action: {
                        let totalSeconds = selectedMinutes * 60 + selectedSeconds
                        timerModel.setupSession(questions: numberOfQuestions, timePerQuestion: totalSeconds)
                        showQuestionTimer = true
                    }) {
                        Text("Start Session")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15)
                    }
                    .disabled(selectedMinutes == 0 && selectedSeconds == 0)
                }
                .padding(.horizontal, 20)
            }
        }
        .fullScreenCover(isPresented: $showQuestionTimer) {
            QuestionTimerView(timerModel: timerModel)
        }
    }
}

struct TimerSetupView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSetupView()
    }
}
