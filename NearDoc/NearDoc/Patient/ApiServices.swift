//// APIService.swift
//import Foundation
//import Combine
//
//enum APIError: Error {
//    case invalidURL
//    case invalidResponse
//    case networkError(Error)
//    case decodingError(Error)
//    case serverError(Int)
//    case unknown
//}
//
//class APIService {
//    static let shared = APIService()
//    private init() {}
//    
//    // Base URL for our Flask backend
//    let baseURL = "http://localhost:5000/api"
//    
//    // Reusable method for making GET requests
//    func get<T: Decodable>(endpoint: String) -> AnyPublisher<T, APIError> {
//        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
//            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
//        }
//        
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .mapError { APIError.networkError($0) }
//            .flatMap { data, response -> AnyPublisher<T, APIError> in
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
//                }
//                
//                if (200...299).contains(httpResponse.statusCode) {
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    
//                    return Just(data)
//                        .decode(type: T.self, decoder: decoder)
//                        .mapError { APIError.decodingError($0) }
//                        .eraseToAnyPublisher()
//                } else {
//                    return Fail(error: APIError.serverError(httpResponse.statusCode)).eraseToAnyPublisher()
//                }
//            }
//            .eraseToAnyPublisher()
//    }
//    
//    // Method for making POST requests
//    func post<T: Decodable, E: Encodable>(endpoint: String, body: E) -> AnyPublisher<T, APIError> {
//        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
//            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        do {
//            let encoder = JSONEncoder()
//            encoder.keyEncodingStrategy = .convertToSnakeCase
//            request.httpBody = try encoder.encode(body)
//        } catch {
//            return Fail(error: APIError.decodingError(error)).eraseToAnyPublisher()
//        }
//        
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .mapError { APIError.networkError($0) }
//            .flatMap { data, response -> AnyPublisher<T, APIError> in
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
//                }
//                
//                if (200...299).contains(httpResponse.statusCode) {
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    
//                    return Just(data)
//                        .decode(type: T.self, decoder: decoder)
//                        .mapError { APIError.decodingError($0) }
//                        .eraseToAnyPublisher()
//                } else {
//                    return Fail(error: APIError.serverError(httpResponse.statusCode)).eraseToAnyPublisher()
//                }
//            }
//            .eraseToAnyPublisher()
//    }
//}
//
//// Request and Response models for authentication
//struct LoginRequest: Codable {
//    let email: String
//    let password: String
//}
//
//struct RegisterRequest: Codable {
//    let fullName: String
//    let email: String
//    let phoneNumber: String
//    let address: String
//    let password: String
//    let gender: String?
//    let age: Int?
//}
//
//struct AuthResponse: Codable {
//    let token: String
//    let user: User
//}
//
//// Endpoints
//extension APIService {
//    // Auth endpoints
//    func login(email: String, password: String) -> AnyPublisher<AuthResponse, APIError> {
//        return post(endpoint: "/login", body: LoginRequest(email: email, password: password))
//    }
//    
//    func register(fullName: String, email: String, phoneNumber: String, address: String, password: String, gender: String?, age: Int?) -> AnyPublisher<AuthResponse, APIError> {
//        let request = RegisterRequest(fullName: fullName, email: email, phoneNumber: phoneNumber, address: address, password: password, gender: gender, age: age)
//        return post(endpoint: "/register", body: request)
//    }
//    
//    // Appointments endpoints
//    func getUpcomingAppointments() -> AnyPublisher<[Appointment], APIError> {
//        return get(endpoint: "/appointments/upcoming")
//    }
//    
//    func getAppointmentDetails(id: String) -> AnyPublisher<Appointment, APIError> {
//        return get(endpoint: "/appointments/\(id)")
//    }
//    
//    func getDoctors() -> AnyPublisher<[Doctor], APIError> {
//        return get(endpoint: "/doctors")
//    }
//    
//    func getDoctorAvailability(id: String) -> AnyPublisher<Doctor, APIError> {
//        return get(endpoint: "/doctors/\(id)/availability")
//    }
//    
//    // Notifications endpoint
//    func getNotifications() -> AnyPublisher<[PatientNotification], APIError> {
//        return get(endpoint: "/notifications")
//    }
//    
//    // Medications endpoint
//    func getMedications() -> AnyPublisher<[Medication], APIError> {
//        return get(endpoint: "/medications")
//    }
//}
