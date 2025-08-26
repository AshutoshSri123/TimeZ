import Foundation
import SwiftUI

struct QuestionData {
    let questionNumber: Int
    var timeSpent: Int
    var status: QuestionStatus
    var extensionsUsed: Int
}

class QuestionTimerModel: ObservableObject {
    @Published var currentQuestion: Int = 1
    @Published var totalQuestions: Int = 0
    @Published var timePerQuestion: Int = 0
    @Published var currentTime: Int = 0
    @Published var isRunning: Bool = false
    @Published var questions: [QuestionData] = []
    @Published var showExtensionAlert: Bool = false
    @Published var sessionCompleted: Bool = false
    
    private var timer: Timer?
    private var startTime: Int = 0
    
    func setupSession(questions: Int, timePerQuestion: Int) {
        self.totalQuestions = questions
        self.timePerQuestion = timePerQuestion
        self.currentTime = timePerQuestion
        self.startTime = timePerQuestion
        self.currentQuestion = 1
        
        // Initialize all questions
        self.questions = (1...questions).map { questionNum in
            QuestionData(questionNumber: questionNum, timeSpent: 0, status: .pending, extensionsUsed: 0)
        }
    }
    
    func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.tick()
        }
    }
    
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    private func tick() {
        if currentTime > 0 {
            currentTime -= 1
            
            // Show extension alert at 10 seconds
            if currentTime == 10 && !showExtensionAlert {
                showExtensionAlert = true
                // Auto-dismiss alert after 5 seconds if no response
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    if self.showExtensionAlert {
                        self.showExtensionAlert = false
                    }
                }
            }
        } else {
            // Time's up - mark as timeout and move to next
            timeoutCurrentQuestion()
        }
    }
    
    func addExtension(seconds: Int) {
        currentTime += seconds
        questions[currentQuestion - 1].extensionsUsed += 1
        showExtensionAlert = false
    }
    
    func declineExtension() {
        showExtensionAlert = false
    }
    
    func markQuestionDone() {
        updateCurrentQuestionStatus(.done)
        moveToNextQuestion()
    }
    
    func markQuestionSkipped() {
        updateCurrentQuestionStatus(.skipped)
        moveToNextQuestion()
    }
    
    private func timeoutCurrentQuestion() {
        updateCurrentQuestionStatus(.timeout)
        moveToNextQuestion()
    }
    
    private func updateCurrentQuestionStatus(_ status: QuestionStatus) {
        let timeSpent = startTime - currentTime
        questions[currentQuestion - 1].timeSpent = timeSpent
        questions[currentQuestion - 1].status = status
    }
    
    private func moveToNextQuestion() {
        if currentQuestion < totalQuestions {
            currentQuestion += 1
            currentTime = timePerQuestion
            startTime = timePerQuestion
            showExtensionAlert = false
        } else {
            // Session completed
            stopTimer()
            sessionCompleted = true
        }
    }
    
    func resetSession() {
        stopTimer()
        currentQuestion = 1
        totalQuestions = 0
        timePerQuestion = 0
        currentTime = 0
        questions.removeAll()
        sessionCompleted = false
        showExtensionAlert = false
    }
    
    // Statistics
    func getTotalTimeSpent() -> Int {
        return questions.reduce(0) { $0 + $1.timeSpent }
    }
    
    func getCompletedQuestions() -> Int {
        return questions.filter { $0.status == .done }.count
    }
    
    func getSkippedQuestions() -> Int {
        return questions.filter { $0.status == .skipped }.count
    }
    
    func getTimeoutQuestions() -> Int {
        return questions.filter { $0.status == .timeout }.count
    }
}
