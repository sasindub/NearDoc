import Foundation

// MARK: - Authentication Models
struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let fullName: String
    let email: String
    let phoneNumber: String
    let password: String
    let age: String
    let gender: String
}

struct AuthResponse: Codable {
    let success: Bool
    let token: String
    let message: String
}

// MARK: - Doctor Model
struct Doctor: Identifiable, Codable {
    let id: String
    let name: String
    let specialization: String
    let hospital: String
    let rating: Double
    let availability: String?
    let time: String?
    let isAvailableToday: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name, specialization, hospital, rating, availability, time, isAvailableToday
    }
}

// MARK: - Appointment Model
struct Appointment: Identifiable, Codable {
    let id: String
    let doctorId: String
    let doctorName: String
    let specialization: String
    let hospital: String
    let date: Date
    let time: String
    let status: String
    let fee: Double
    
    enum CodingKeys: String, CodingKey {
        case id, doctorId, doctorName, specialization, hospital, date, time, status, fee
    }
}

// MARK: - Booking Models
struct BookingRequest: Codable {
    let doctorId: String
    let date: String
    let time: String
}

struct BookingResponse: Codable {
    let success: Bool
    let appointmentId: String
    let message: String
}

// MARK: - Notification Model
//struct NotificationItem: Identifiable, Codable {
//    let id: String
//    let title: String
//    let message: String
//    let date: Date
//    var isRead: Bool
//}

// MARK: - Medication Model
struct Medication: Identifiable, Codable {
    let id: String
    let name: String
    let dosage: String
    let schedule: String
    let startDate: Date
    let endDate: Date
}
