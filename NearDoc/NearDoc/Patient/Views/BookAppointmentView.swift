import SwiftUI
import EventKit

struct BookAppointmentView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: String = ""
    @State private var showingConfirmation: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    @State private var accessGranted: Bool = false
    private let eventStore = EKEventStore()
    

    var selectedDoctor: Doctor?
    
    
    let timeSlots = [
        "09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM",
        "11:00 AM", "11:30 AM", "01:00 PM", "01:30 PM",
        "02:00 PM", "02:30 PM", "03:00 PM", "03:30 PM"
    ]
    
    var body: some View {
        VStack {
            // Navigation Bar
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Book Appointment")
                    .font(.headline)
                Spacer()
                NavigationLink(destination: NotificationsView()) {
                    Image(systemName: "bell")
                        .font(.title3)
                        .foregroundColor(.black)
                }
            }
            .padding()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search doctors, specialties", text: $searchText)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Selected doctor card
                    doctorCard
                    
                    // Date selection
                    dateSelectionView
                    
                    // Time selection
                    timeSelectionView
                    
                    // Available Time & Appointment No
                    detailsSummaryView
                    
                    // Appointment Fee
                    appointmentFeeView
                    
                    // Error message
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            
            // Book Now Button
            Button(action: {
                bookAppointment()
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Book Now")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(selectedTime.isEmpty ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(selectedTime.isEmpty || isLoading)
            .padding(.bottom)
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.97).edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
        .onAppear {
            requestCalendarAccess()
        }
        .alert(isPresented: $showingConfirmation) {
            Alert(
                title: Text("Appointment Confirmed"),
                message: Text("Your appointment on \(formatDate(selectedDate)) at \(selectedTime) has been booked and added to your calendar."),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    //EventKit Integration
    private func requestCalendarAccess() {
        eventStore.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                self.accessGranted = granted
            }
        }
    }
    
    private func addEventToCalendar() {
        guard accessGranted else {
            requestCalendarAccess()
            return
        }
        // Combine selectedDate and selectedTime into a single Date
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        guard let timeDate = timeFormatter.date(from: selectedTime) else { return }
        var components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        let hour = Calendar.current.component(.hour, from: timeDate)
        let minute = Calendar.current.component(.minute, from: timeDate)
        components.hour = hour
        components.minute = minute
        guard let startDate = Calendar.current.date(from: components) else { return }
        let endDate = startDate.addingTimeInterval(60 * 30) // 30-minute duration
        
        let event = EKEvent(eventStore: eventStore)
        event.title = "Appointment with \(selectedDoctor?.name ?? "Doctor")"
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(event, span: .thisEvent)
        } catch {
            print("Failed to save event: \(error)")
        }
    }
    
 
    private var doctorCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .foregroundColor(.blue)
                VStack(alignment: .leading, spacing: 5) {
                    Text(selectedDoctor?.name ?? "Dr. John Smith")
                        .font(.headline)
                    Text(selectedDoctor?.specialization ?? "Medicine Center")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(selectedDoctor?.hospital ?? "MedicalOne Center")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                        Text(String(format: "%.1f", selectedDoctor?.rating ?? 4.5))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text("$100-$200")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private var dateSelectionView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Select Date")
                .font(.headline)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(0..<7) { index in
                        let date = Calendar.current.date(byAdding: .day, value: index, to: Date()) ?? Date()
                        Button(action: {
                            selectedDate = date
                        }) {
                            dateCell(for: date)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var timeSelectionView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Select Time")
                .font(.headline)
                .padding(.horizontal)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                ForEach(timeSlots, id: \.self) { time in
                    Button(action: {
                        selectedTime = time
                    }) {
                        Text(time)
                            .font(.subheadline)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(selectedTime == time ? Color.blue : Color.white)
                            .foregroundColor(selectedTime == time ? .white : .black)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: selectedTime == time ? 0 : 1)
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var detailsSummaryView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Available Time & Appointment No")
                .font(.headline)
                .padding(.horizontal)
            VStack(spacing: 15) {
                HStack {
                    Text("Schedule Time")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(selectedTime.isEmpty ? "Select a time" : selectedTime)
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                Divider()
                HStack {
                    Text("Appointment No")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("#\(Int.random(in: 1000...9999))")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
    
    private var appointmentFeeView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Appointment Fee")
                .font(.headline)
                .padding(.horizontal)
            HStack {
                Text("Fee")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text("LKR 1200.00")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
    
    // Helper functions
    private func dateCell(for date: Date) -> some View {
        VStack(spacing: 8) {
            Text(dayOfWeek(for: date))
                .font(.caption)
                .foregroundColor(
                    Calendar.current.isDate(date, inSameDayAs: selectedDate) ?
                    .white : .gray
                )
            Text("\(dayNumber(for: date))")
                .font(.headline)
                .foregroundColor(
                    Calendar.current.isDate(date, inSameDayAs: selectedDate) ?
                    .white : .black
                )
            Text(monthName(for: date))
                .font(.caption)
                .foregroundColor(
                    Calendar.current.isDate(date, inSameDayAs: selectedDate) ?
                    .white : .gray
                )
        }
        .frame(width: 60, height: 90)
        .background(
            Calendar.current.isDate(date, inSameDayAs: selectedDate) ?
            Color.blue : Color.white
        )
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    func dayOfWeek(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    func dayNumber(for date: Date) -> Int {
        return Calendar.current.component(.day, from: date)
    }
    
    func monthName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // Backend integration
    private func bookAppointment() {
        guard !selectedTime.isEmpty else { return }
        
        isLoading = true
        errorMessage = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let bookingRequest = BookingRequest(
            doctorId: selectedDoctor?.id ?? "1",
            patientId: UserDefaults.standard.string(forKey: "userId") ?? "1",
            date: dateFormatter.string(from: selectedDate),
            time: selectedTime
        )
        
        NetworkManager.shared.postData(endpoint: "/book-appointment", body: bookingRequest) { (result: Result<BookingResponse, Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    if response.success {
                        addEventToCalendar()
                        self.showingConfirmation = true
                    } else {
                        self.errorMessage = response.message
                    }
                case .failure(let error):
                    self.errorMessage = "Booking failed: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct BookAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        BookAppointmentView()
    }
}
import SwiftUI
import EventKit

struct BookAppointmentView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: String = ""
    @State private var showingConfirmation: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    @State private var accessGranted: Bool = false
    private let eventStore = EKEventStore()
    
    // Selected doctor (optional - passed from previous view)
    var selectedDoctor: Doctor?
    
    // Time slots for appointment booking
    let timeSlots = [
        "09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM",
        "11:00 AM", "11:30 AM", "01:00 PM", "01:30 PM",
        "02:00 PM", "02:30 PM", "03:00 PM", "03:30 PM"
    ]
    
    var body: some View {
        VStack {
            // Navigation Bar
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Book Appointment")
                    .font(.headline)
                Spacer()
                NavigationLink(destination: NotificationsView()) {
                    Image(systemName: "bell")
                        .font(.title3)
                        .foregroundColor(.black)
                }
            }
            .padding()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search doctors, specialties", text: $searchText)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Selected doctor card
                    doctorCard
                    
                    // Date selection
                    dateSelectionView
                    
                    // Time selection
                    timeSelectionView
                    
                    // Available Time & Appointment No
                    detailsSummaryView
                    
                    // Appointment Fee
                    appointmentFeeView
                    
                    // Error message
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            
            // Book Now Button
            Button(action: {
                bookAppointment()
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Book Now")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(selectedTime.isEmpty ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(selectedTime.isEmpty || isLoading)
            .padding(.bottom)
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.97).edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
        .onAppear {
            requestCalendarAccess()
        }
        .alert(isPresented: $showingConfirmation) {
            Alert(
                title: Text("Appointment Confirmed"),
                message: Text("Your appointment on \(formatDate(selectedDate)) at \(selectedTime) has been booked and added to your calendar."),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    // MARK: - EventKit Integration
    private func requestCalendarAccess() {
        eventStore.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                self.accessGranted = granted
            }
        }
    }
    
    private func addEventToCalendar() {
        guard accessGranted else {
            requestCalendarAccess()
            return
        }
        // Combine selectedDate and selectedTime into a single Date
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        guard let timeDate = timeFormatter.date(from: selectedTime) else { return }
        var components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        let hour = Calendar.current.component(.hour, from: timeDate)
        let minute = Calendar.current.component(.minute, from: timeDate)
        components.hour = hour
        components.minute = minute
        guard let startDate = Calendar.current.date(from: components) else { return }
        let endDate = startDate.addingTimeInterval(60 * 30) // 30-minute duration
        
        let event = EKEvent(eventStore: eventStore)
        event.title = "Appointment with \(selectedDoctor?.name ?? "Doctor")"
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(event, span: .thisEvent)
        } catch {
            print("Failed to save event: \(error)")
        }
    }
    
    // MARK: - Views
    private var doctorCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .foregroundColor(.blue)
                VStack(alignment: .leading, spacing: 5) {
                    Text(selectedDoctor?.name ?? "Dr. John Smith")
                        .font(.headline)
                    Text(selectedDoctor?.specialization ?? "Medicine Center")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(selectedDoctor?.hospital ?? "MedicalOne Center")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                        Text(String(format: "%.1f", selectedDoctor?.rating ?? 4.5))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text("$100-$200")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private var dateSelectionView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Select Date")
                .font(.headline)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(0..<7) { index in
                        let date = Calendar.current.date(byAdding: .day, value: index, to: Date()) ?? Date()
                        Button(action: {
                            selectedDate = date
                        }) {
                            dateCell(for: date)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var timeSelectionView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Select Time")
                .font(.headline)
                .padding(.horizontal)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                ForEach(timeSlots, id: \.self) { time in
                    Button(action: {
                        selectedTime = time
                    }) {
                        Text(time)
                            .font(.subheadline)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(selectedTime == time ? Color.blue : Color.white)
                            .foregroundColor(selectedTime == time ? .white : .black)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: selectedTime == time ? 0 : 1)
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var detailsSummaryView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Available Time & Appointment No")
                .font(.headline)
                .padding(.horizontal)
            VStack(spacing: 15) {
                HStack {
                    Text("Schedule Time")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(selectedTime.isEmpty ? "Select a time" : selectedTime)
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                Divider()
                HStack {
                    Text("Appointment No")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("#\(Int.random(in: 1000...9999))")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
    
    private var appointmentFeeView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Appointment Fee")
                .font(.headline)
                .padding(.horizontal)
            HStack {
                Text("Fee")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text("LKR 1200.00")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
    
    // Helper functions
    private func dateCell(for date: Date) -> some View {
        VStack(spacing: 8) {
            Text(dayOfWeek(for: date))
                .font(.caption)
                .foregroundColor(
                    Calendar.current.isDate(date, inSameDayAs: selectedDate) ?
                    .white : .gray
                )
            Text("\(dayNumber(for: date))")
                .font(.headline)
                .foregroundColor(
                    Calendar.current.isDate(date, inSameDayAs: selectedDate) ?
                    .white : .black
                )
            Text(monthName(for: date))
                .font(.caption)
                .foregroundColor(
                    Calendar.current.isDate(date, inSameDayAs: selectedDate) ?
                    .white : .gray
                )
        }
        .frame(width: 60, height: 90)
        .background(
            Calendar.current.isDate(date, inSameDayAs: selectedDate) ?
            Color.blue : Color.white
        )
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    func dayOfWeek(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    func dayNumber(for date: Date) -> Int {
        return Calendar.current.component(.day, from: date)
    }
    
    func monthName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // Backend integration
    private func bookAppointment() {
        guard !selectedTime.isEmpty else { return }
        
        isLoading = true
        errorMessage = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let bookingRequest = BookingRequest(
            doctorId: selectedDoctor?.id ?? "1",
            patientId: UserDefaults.standard.string(forKey: "userId") ?? "1",
            date: dateFormatter.string(from: selectedDate),
            time: selectedTime
        )
        
        NetworkManager.shared.postData(endpoint: "/book-appointment", body: bookingRequest) { (result: Result<BookingResponse, Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    if response.success {
                        addEventToCalendar()
                        self.showingConfirmation = true
                    } else {
                        self.errorMessage = response.message
                    }
                case .failure(let error):
                    self.errorMessage = "Booking failed: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct BookAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        BookAppointmentView()
    }
}
