import SwiftUI

struct RegisterView: View {
    // State variables
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var age: String = ""
    @State private var gender: String = "Male"
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var isRegistering: Bool = false
    @State private var registrationComplete: Bool = false
    @State private var errorMessage: String = ""
    @State private var address: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    let genders = ["Male", "Female", "Other"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Register")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Name field
                VStack(alignment: .leading) {
                    Text("Full Name")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("Enter your name", text: $fullName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                }
                
                // Address field
                VStack(alignment: .leading) {
                    Text("Address")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("Enter your address", text: $address)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                }
                
                // Phone number field
                VStack(alignment: .leading) {
                    Text("Phone Number")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("+1")
                            .padding(.leading)
                        
                        Divider()
                            .frame(width: 1, height: 25)
                            .background(Color.gray.opacity(0.5))
                        
                        TextField("Enter phone number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                    }
                    .frame(height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
                }
                
                // Email field
                VStack(alignment: .leading) {
                    Text("Email")
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
                
                // Password fields with toggle visibility
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
                
                // Confirm password with visibility toggle
                VStack(alignment: .leading) {
                    Text("Confirm Password")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        if showConfirmPassword {
                            TextField("Confirm password", text: $confirmPassword)
                        } else {
                            SecureField("Confirm password", text: $confirmPassword)
                        }
                        
                        Button(action: {
                            showConfirmPassword.toggle()
                        }) {
                            Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
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
                
                // Age field
                VStack(alignment: .leading) {
                    Text("Age")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("Enter your age", text: $age)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                }
                
                // Gender selection with radio buttons
                VStack(alignment: .leading) {
                    Text("Gender")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        ForEach(genders, id: \.self) { genderOption in
                            Button(action: {
                                gender = genderOption
                            }) {
                                HStack(spacing: 10) {
                                    ZStack {
                                        Circle()
                                            .stroke(Color.gray, lineWidth: 1)
                                            .frame(width: 20, height: 20)
                                        
                                        if gender == genderOption {
                                            Circle()
                                                .fill(Color.blue)
                                                .frame(width: 12, height: 12)
                                        }
                                    }
                                    
                                    Text(genderOption)
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.trailing, 15)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Error message display
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                // Register button
                Button(action: {
                    registerUser()
                }) {
                    if isRegistering {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Register")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .disabled(isRegistering)
                .padding(.top, 10)
                
                // Login link
                HStack {
                    Spacer()
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Login")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.97).edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
        .alert(isPresented: $registrationComplete) {
            Alert(
                title: Text("Registration Successful"),
                message: Text("Your account has been created. You can now login."),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    // Backend integration for registration
    private func registerUser() {
        // Validate inputs
        if fullName.isEmpty || address.isEmpty || phoneNumber.isEmpty || email.isEmpty || password.isEmpty || age.isEmpty {
            errorMessage = "All fields are required"
            return
        }
        
        if password != confirmPassword {
            errorMessage = "Passwords do not match"
            return
        }
        
        guard let ageInt = Int(age) else {
            errorMessage = "Age must be a number"
            return
        }
        
        isRegistering = true
        errorMessage = ""
        
        let registerRequest = RegisterRequest(
            fullName: fullName,
            email: email,
            phoneNumber: phoneNumber,
            password: password,
            age: age,
            gender: gender
        )
        
        NetworkManager.shared.postData(endpoint: "/register", body: registerRequest) { (result: Result<AuthResponse, Error>) in
            self.isRegistering = false
            
            switch result {
            case .success(let response):
                if response.success {
                    self.registrationComplete = true
                } else {
                    self.errorMessage = response.message
                }
            case .failure(let error):
                self.errorMessage = "Registration failed: \(error.localizedDescription)"
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
