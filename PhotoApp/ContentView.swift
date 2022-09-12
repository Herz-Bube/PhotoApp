import SwiftUI
import Firebase


class AppViewModel: ObservableObject {
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    @Published var events = [Event]()
    @Published var createEventIsShowing = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email,
                    password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
            
        }
    }
    
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func signOut() {
        try? auth.signOut()
        
        self.signedIn = false
    }
}




struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    @State var showingPopover = false
    @State var eventName = ""
    
    var body: some View {
        NavigationView {
            if viewModel.signedIn {
                
                ZStack {
                    
                    VStack {
                        List(viewModel.events) { event in
                            
                            NavigationLink(event.name, destination: PhotoEventView(event: event))
                        }
                    }
                    //First empty
//                    if !viewModel.events.isEmpty {
//                        List(){
//                            ForEach(viewModel.events) { events in
//                                NavigationLink(destination: PhotoEventView(), isActive: true)
//                                Text(events.name)
//                            }
//                            .onDelete(perform: deleteEvent)
//                        }
//                    }
                    
                    
                    VStack {
                        
                        
                        
                        
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                //Swap to EventCreatorView
                                viewModel.createEventIsShowing = true
                                
                            }, label: {
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .frame(width: 70, height: 70)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                    .foregroundColor(Color.white)
                            })
                            .padding()
                            .shadow(radius: 2)
                          
                        }
                        
                        NavigationLink(destination: EventCreatorView(), isActive: $viewModel.createEventIsShowing) {
                            EmptyView()
                        }
                    }
                }
                
            }
            
            
            
            else {
                SignInView()
            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
    
    func deleteEvent(at offset: IndexSet) {
        viewModel.events.remove(atOffsets: offset)
    }
}


struct SignInView: View {
    
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            VStack {
                TextField("Email Address", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                SecureField("Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    
                    viewModel.signIn(email: email, password: password)
                    
                }, label: {
                    Text("Sign In")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .cornerRadius(8)
                        .background(Color.blue)
                })
                
                NavigationLink("Create Account", destination: SignUpView())
                    .padding()
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Sign In")
    }
}

struct SignUpView: View {
    
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
//            Image("logo")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 150, height: 15)
            VStack {
                TextField("Email Address", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                SecureField("Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    
                    viewModel.signUp(email: email, password: password)
                    
                }, label: {
                    Text("Create Account")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .cornerRadius(8)
                        .background(Color.blue)
                })
            }
            .padding()
        }
        .navigationTitle("Create Account")
    }
}

