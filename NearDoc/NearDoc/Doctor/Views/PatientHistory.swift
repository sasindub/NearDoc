import SwiftUI
import CoreML
import NaturalLanguage

struct PatientHistoryView: View {
    let patientId: String
    
    @State private var patient: Patient?
    @State private var patientHistory: PatientHistory?
    @State private var isLoading = true
    @State private var errorMessage = ""
    @State private var searchText = ""
    // Summarization states
    @State private var showSummary = false
    @State private var isSummarizing = false
    @State private var summaryText = ""
    
    // CoreML summarization model
    private let summarizationModel: SummarizationModel? = {
        do {
            let config = MLModelConfiguration()
            return try SummarizationModel(configuration: config)
        } catch {
            print("Failed to load summarization model: \(error)")
            return nil
        }
    }()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search prescriptions", text: $searchText)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                
                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    if let patient = patient {
                        patientInfoCard(patient)
                    }
                    medicalConditionsCard()
                    allergiesCard()
                    if let history = patientHistory {
                        pastAppointmentsCard(history.appointments)
                        prescriptionsCard(history.prescriptions)
                    }
                }
                
                // --- Summarization Section START ---
                Button(action: performSummarization) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                        if isSummarizing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .padding(.leading, 4)
                        }
                        Text("Summarize Medical History")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isSummarizing || summarizationModel == nil ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(isSummarizing || summarizationModel == nil)
                .padding(.top, 8)
                
                if showSummary {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "text.justify")
                                .foregroundColor(.blue)
                            Text("Medication Summary")
                                .font(.headline)
                        }
                        Text(summaryText)
                            .font(.body)
                            .padding(.top, 5)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.top, 4)
                }
                // --- Summarization Section END ---
            }
            .padding()
        }
        .navigationTitle("Patient History")
        .onAppear {
            loadPatientData()
        }
        .alert(isPresented: .constant(!errorMessage.isEmpty)) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK")) {
                    errorMessage = ""
                }
            )
        }
    }
    
    // Summarization Logic
    private func performSummarization() {
        guard let history = patientHistory,
              let model = summarizationModel else { return }
        isSummarizing = true
        showSummary = false

        // Combine relevant history text
        let appointmentsText = history.appointments
            .map { "\($0.date.formatted()) – Dr. \($0.doctorName) (\($0.status))" }
            .joined(separator: "\n")
        let prescriptionsText = history.prescriptions
            .map { "\($0.date.formatted()) – Meds: \($0.medications.joined(separator: ", "))" }
            .joined(separator: "\n")
        let fullText = appointmentsText + "\n" + prescriptionsText

        DispatchQueue.global(qos: .userInitiated).async {
            // Extract keywords
            let keywords = extractKeywords(from: fullText)
            // Prepare model input
            let inputText = fullText + "\nKeywords: " + keywords.joined(separator: ", ")
            let modelInput = SummarizationModelInput(text: inputText)

            var resultSummary = ""
            if let output = try? model.prediction(input: modelInput) {
                resultSummary = output.summary
            } else {
                resultSummary = "Unable to generate summary with CoreML model."
            }

            DispatchQueue.main.async {
                summaryText = resultSummary
                isSummarizing = false
                showSummary = true
            }
        }
    }
    
    private func extractKeywords(from text: String) -> [String] {
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = text.lowercased()
        var tokens = [String]()
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let word = text[range]
                .trimmingCharacters(in: .punctuationCharacters)
            tokens.append(String(word))
            return true
        }
        let medicalTerms: Set<String> = ["diabetes", "diabetic", "bronchiolitis", "allergy", "amoxicillin"]
        let found = Set(tokens).intersection(medicalTerms)
        return Array(found)
    }

    // Data Loading
    private func loadPatientData() {
        isLoading = true
        errorMessage = ""

        NetworkManager.shared.fetchData(endpoint: "/patient/\(patientId)") { (result: Result<Patient, Error>) in
            switch result {
            case .success(let patient):
                self.patient = patient
                loadPatientHistory()
            case .failure(let error):
                isLoading = false
                errorMessage = "Failed to load patient: \(error.localizedDescription)"
            }
        }
    }

    private func loadPatientHistory() {
        NetworkManager.shared.fetchData(endpoint: "/patient-history/\(patientId)") { (result: Result<PatientHistory, Error>) in
            isLoading = false
            switch result {
            case .success(let history):
                self.patientHistory = history
            case .failure(let error):
                errorMessage = "Failed to load patient history: \(error.localizedDescription)"
            }
        }
    }

    //  Helper Views (unchanged)
    private func patientInfoCard(_ patient: Patient) -> some View { /* ... */ }
    private func medicalConditionsCard() -> some View { /* ... */ }
    private func medicalConditionItem(name: String, date: String, color: Color) -> some View { /* ... */ }
    private func allergiesCard() -> some View { /* ... */ }
    private func allergyItem(name: String, severity: String, color: Color) -> some View { /* ... */ }
    private func pastAppointmentsCard(_ appointments: [Appointment]) -> some View { /* ... */ }
    private func prescriptionsCard(_ prescriptions: [Prescription]) -> some View { /* ... */ }
}
