import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var rememberMe: Bool = false
    @State private var isLoggingIn: Bool = false
    @State private var errorMessage: String = ""
    @State private var showingRegister = false
    
    var body: some View {
        NavigationView {
            VStack {
                // App logo/icon
                Image(systemName: "lock.shield.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                    .padding(.top, 50)
                
                Text("Welcome Back!")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                VStack(spacing: 20) {
                    // Email/username field
                    VStack(alignment: .leading) {
                        Text("Email/Username")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        TextField("Enter your email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal)
                    }
                    
                    // Password field with visibility toggle
                    VStack(alignment: .leading) {
                        Text("Password")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        HStack {
                            if showPassword {
                                TextField("Enter password", text: $password)
                            } else {
                                SecureField("Enter password", text: $password)
                            }
                            
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }
                    
                    // Remember me and forgot password
                    HStack {
                        Button(action: {
                            rememberMe.toggle()
                        }) {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.gray, lineWidth: 1)
                                        .frame(width: 20, height: 20)
                                    
                                    if rememberMe {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.blue)
                                            .frame(width: 20, height: 20)
                                        
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12))
                                            .foregroundColor(.white)
                                    }
                                }
                                
                                Text("Remember Me")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Forgot password functionality
                        }) {
                            Text("Forgot Password?")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Error message display
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    
                    // Login button
                    Button(action: {
                        login()
                    }) {
                        if isLoggingIn {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Login")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .disabled(isLoggingIn)
                    
                    // Register link
                    HStack {
                        Spacer()
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            showingRegister = true
                        }) {
                            Text("Register")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                }
                .padding(.top, 30)
                
                Spacer()
            }
            .padding()
            .background(Color(red: 0.97, green: 0.97, blue: 0.97).edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
            .sheet(isPresented: $showingRegister) {
                RegisterView()
            }
        }
    }
    
    // Login function that connects to backend
    private func login() {
        // Validate inputs
        if email.isEmpty || password.isEmpty {
            errorMessage = "Email and password are required"
            return
        }
        
        isLoggingIn = true
        errorMessage = ""
        
        let loginRequest = LoginRequest(email: email, password: password)
        
        NetworkManager.shared.postData(endpoint: "/login", body: loginRequest) { (result: Result<AuthResponse, Error>) in
            self.isLoggingIn = false
            
            switch result {
            case .success(let response):
                if response.success {
                    // Store the token
                    NetworkManager.shared.setAuthToken(response.token)
                    
                    // Set login state
                    self.isLoggedIn = true
                } else {
                    self.errorMessage = response.message
                }
            case .failure(let error):
                self.errorMessage = "Login failed: \(error.localizedDescription)"
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false))
    }
}
