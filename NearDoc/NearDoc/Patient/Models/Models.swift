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
    let userType: String?  
    let userId: String?
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
    let email: String?
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, specialization, hospital, rating, availability, time, isAvailableToday, email, profileImage
    }
}

// MARK: - Patient Model
struct Patient: Identifiable, Codable {
    let id: String
    let name: String
    let age: Int
    let gender: String
    let email: String
    let phone: String
    let address: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, age, gender, email, phone, address, profileImage
    }
}

// MARK: - Appointment Model
struct Appointment: Identifiable, Codable {
    let id: String
    let doctorId: String
    let doctorName: String
    let patientId: String
    let patientName: String
    let specialization: String
    let hospital: String
    let date: Date
    let time: String
    let status: String
    let fee: Double
    
    enum CodingKeys: String, CodingKey {
        case id, doctorId, doctorName, patientId, patientName, specialization, hospital, date, time, status, fee
    }
}

// MARK: - Booking Models
struct BookingRequest: Codable {
    let doctorId: String
    let patientId: String?
    let date: String
    let time: String
}

struct BookingResponse: Codable {
    let success: Bool
    let appointmentId: String
    let message: String
}

// MARK: - Update Appointment Status
struct UpdateAppointmentRequest: Codable {
    let appointmentId: String
    let status: String
}

// MARK: - Notification Model
struct NotificationItem: Identifiable, Codable {
    let id: String
    let title: String
    let message: String
    let date: Date
    var isRead: Bool
    let forDoctor: Bool?
}

// MARK: - Medication Model
struct Medication: Identifiable, Codable {
    let id: String
    let name: String
    let dosage: String
    let schedule: String
    let startDate: Date
    let endDate: Date
}

// MARK: - Prescription Models
struct PrescriptionMedication: Codable {
    let name: String
    let dosage: String
    let instructions: String
}

struct Prescription: Identifiable, Codable {
    let id: String
    let doctorId: String
    let doctorName: String
    let patientId: String
    let patientName: String
    let date: Date
    let medications: [PrescriptionMedication]
    let notes: String
}

struct AddPrescriptionRequest: Codable {
    let doctorId: String
    let patientId: String
    let date: String
    let medications: [PrescriptionMedication]
    let notes: String
}

// MARK: - Availability Models
struct TimeSlot: Codable {
    var available: Bool
    var startTime: String
    var endTime: String
}

struct DoctorAvailability: Codable {
    var morning: TimeSlot
    var evening: TimeSlot
    var maxAppointments: Int
}

struct UpdateAvailabilityRequest: Codable {
    let doctorId: String
    let morning: TimeSlot?
    let evening: TimeSlot?
    let maxAppointments: Int?
}

// MARK: - Earnings Models
struct EarningDetail: Codable {
    let patientName: String
    let date: Date
    let time: String
    let amount: Double
}

struct DoctorEarnings: Codable {
    let today: Double
    let total: Double
    let recent: [EarningDetail]
}

// MARK: - Patient History
struct PatientHistory: Codable {
    let appointments: [Appointment]
    let prescriptions: [Prescription]
}
