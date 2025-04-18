import SwiftUI

struct DoctorEarningsView: View {
    let doctorId: String
    
    @State private var earnings: DoctorEarnings?
    @State private var selectedPeriod = 0  // 0: Last 30 Days, 1: Last 6 Months, 2: Last Year
    @State private var isLoading = true
    @State private var errorMessage = ""
    
    private let periods = ["Last 30 Days", "Last 6 Months", "Last Year"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Period selector
            HStack {
                ForEach(0..<periods.count, id: \.self) { index in
                    Button(action: {
                        selectedPeriod = index
                    }) {
                        Text(periods[index])
                            .font(.subheadline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(selectedPeriod == index ? Color.blue : Color.clear)
                            .foregroundColor(selectedPeriod == index ? .white : .gray)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(Color.white)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Earnings summary card
                    earningsSummaryCard()
                    
                    // Recent earnings
                    recentEarningsCard()
                }
                .padding()
            }
        }
        .navigationTitle("Earnings")
        .onAppear {
            loadEarnings()
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
    
    // Earnings summary card
    private func earningsSummaryCard() -> some View {
        VStack(spacing: 20) {
            if isLoading {
                ProgressView()
                    .padding()
            } else if let earnings = earnings {
                // Total earnings
                Text("LKR \(String(format: "%.2f", earnings.total))")
                    .font(.system(size: 36, weight: .bold))
                
                Divider()
                
                // Today's earnings
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Today's Earnings")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("LKR \(String(format: "%.2f", earnings.today))")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up")
                        .foregroundColor(.green)
                        .padding(8)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                }
            } else {
                Text("No earnings data available")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    // Recent earnings card
    private func recentEarningsCard() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Earnings")
                .font(.headline)
            
            if isLoading {
                ProgressView()
                    .padding()
            } else if let earnings = earnings, !earnings.recent.isEmpty {
                ForEach(0..<earnings.recent.count, id: \.self) { index in
                    let earning = earnings.recent[index]
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(earning.patientName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text("\(formattedDate(earning.date)) • \(earning.time)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text("LKR \(String(format: "%.2f", earning.amount))")
                            .font(.headline)
                    }
                    .padding(.vertical, 8)
                    
                    if index < earnings.recent.count - 1 {
                        Divider()
                    }
                }
            } else {
                Text("No recent earnings")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    // Helper to format date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // Load earnings from backend
    private func loadEarnings() {
        isLoading = true
        errorMessage = ""
        
        NetworkManager.shared.fetchData(endpoint: "/doctor-earnings/\(doctorId)") { (result: Result<DoctorEarnings, Error>) in
            self.isLoading = false
            
            switch result {
            case .success(let earnings):
                self.earnings = earnings
            case .failure(let error):
                self.errorMessage = "Failed to load earnings: \(error.localizedDescription)"
            }
        }
    }
}

struct DoctorEarningsView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorEarningsView(doctorId: "4")
    }
}
