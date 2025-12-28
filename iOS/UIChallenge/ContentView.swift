import SwiftUI

struct ContentView: View {
    var body: some View {
        ProfileSetupView()
    }
}

// MARK: - Profile Setup View
struct ProfileSetupView: View {

    // MARK: - State
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var isVerified: Bool = false
    @State private var showDetails: Bool = false

    // MARK: - Focus State
    @FocusState private var focusedField: Field?

    enum Field {
        case name
        case age
    }

    // MARK: - Computed Properties
    var greetingText: String {
        name.isEmpty ? "Welcome!!" : "Welcome, \(name)"
    }

    var ageValue: Int? {
        Int(age)
    }

    var completionProgress: Double {
        var progress = 0.0
        if !name.isEmpty { progress += 0.33 }
        if !age.isEmpty { progress += 0.33 }
        if isVerified { progress += 0.34 }
        return progress
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: - Header
                    VStack(spacing: 8) {
                        Text(greetingText)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.label))
                            .animation(.easeInOut, value: greetingText)

                        Text("Complete your profile to continue")
                            .font(.subheadline)
                            .foregroundColor(Color(.secondaryLabel))
                    }

                    // MARK: - Progress
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Profile Completion")
                            .font(.caption)
                            .foregroundColor(Color(.secondaryLabel))

                        ProgressView(value: completionProgress)
                            .tint(.blue)
                            .animation(.easeInOut, value: completionProgress)
                    }

                    // MARK: - Avatar
                    ZStack {
                        Circle()
                            .fill(Color(.secondarySystemBackground))
                            .frame(width: 120, height: 120)

                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color(.secondaryLabel))
                    }

                    // MARK: - Input Fields
                    VStack(spacing: 16) {

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Name")
                                .font(.headline)

                            TextField("Enter your name", text: $name)
                                .submitLabel(.next)
                                .focused($focusedField, equals: .name)
                                .onSubmit {
                                    focusedField = .age
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Age")
                                .font(.headline)

                            TextField("Enter your age", text: $age)
                                .keyboardType(.numberPad)
                                .submitLabel(.done)
                                .focused($focusedField, equals: .age)
                                .onSubmit {
                                    focusedField = nil
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                        }
                    }

                    // MARK: - Verification Card
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Verification Status")
                                .font(.headline)

                            Text(isVerified ? "Verified user" : "Not verified")
                                .font(.subheadline)
                                .foregroundColor(isVerified ? .green : .red)
                                .animation(.easeInOut, value: isVerified)
                        }

                        Spacer()

                        Button {
                            triggerHaptic(.light)
                            withAnimation(.spring()) {
                                isVerified.toggle()
                            }
                        } label: {
                            Text(isVerified ? "Revoke" : "Verify")
                                .fontWeight(.semibold)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(14)

                    Spacer(minLength: 20)

                    // MARK: - Continue Button
                    Button {
                        triggerHaptic(.medium)
                        withAnimation(.easeInOut) {
                            showDetails = true
                        }
                    } label: {
                        Text("Continue")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    .disabled(completionProgress < 0.66)
                    .opacity(completionProgress < 0.66 ? 0.6 : 1)

                    NavigationLink(
                        destination: ProfileDetailsView(name: name, age: ageValue),
                        isActive: $showDetails
                    ) {
                        EmptyView()
                    }
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .navigationTitle("Profile Setup")

            // MARK: - Keyboard Toolbar
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }

            // MARK: - Dismiss Keyboard on Tap
            .onTapGesture {
                focusedField = nil
            }
        }
    }

    // MARK: - Haptic Feedback
    private func triggerHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}

// MARK: - Profile Details View
struct ProfileDetailsView: View {

    let name: String
    let age: Int?

    var body: some View {
        VStack(spacing: 20) {
            Text("Profile Details")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Name: \(name.isEmpty ? "N/A" : name)")
                .font(.title3)

            if let age {
                Text("Age: \(age)")
                    .font(.title3)
            } else {
                Text("Age not provided")
                    .foregroundColor(Color(.secondaryLabel))
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .navigationTitle("Details")
    }
}

#Preview {
    ContentView()
}

