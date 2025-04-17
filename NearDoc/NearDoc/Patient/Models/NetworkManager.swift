import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "http://localhost:5000/api" // Change to your server IP if needed
    private var authToken: String?
    
    private init() {
        // Load saved token if exists
        self.authToken = UserDefaults.standard.string(forKey: "userToken")
    }
    
    func setAuthToken(_ token: String) {
        self.authToken = token
        UserDefaults.standard.set(token, forKey: "userToken")
    }
    
    // Generic function to fetch data
    func fetchData<T: Decodable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        if let token = authToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                // Set up date decoding strategy
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.calendar = Calendar(identifier: .iso8601)
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let decodedData = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // For POST requests
    func postData<T: Decodable, E: Encodable>(endpoint: String, body: E, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let encoder = JSONEncoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            
            request.httpBody = try encoder.encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    enum NetworkError: Error, LocalizedError {
        case invalidURL
        case noData
        case decodingError
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .noData:
                return "No data received"
            case .decodingError:
                return "Failed to decode data"
            }
        }
    }
}
