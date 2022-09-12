

import Foundation
import SwiftUI
import PhotosPicker
import PhotosUI

struct EventCreatorView: View {
    
    @State var eventName = ""
    @State var isPickerShowing = false
    @State var pickerResultArray: [UIImage] = []
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Go on create an epic event!")
                .font(.headline)
                .padding()
            
            
            
            Text("Enter Name of Event:")
            TextField("Event Name", text: $eventName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
            
            Button(action: {
                isPickerShowing = true
            }, label: {
                Text("Add pictures")
                    .foregroundColor(Color.white)
                    .frame(width: 200, height: 50)
                    .cornerRadius(8)
                    .background(Color.blue)
            })
            .padding()
            
            Button(action: {
                viewModel.events.append(Event(name: eventName, imageArray: pickerResultArray))
                viewModel.createEventIsShowing = false
            }, label: {
                Text("Create Event")
                    .foregroundColor(Color.white)
                    .frame(width: 200, height: 50)
                    .cornerRadius(8)
                    .background(Color.green)
            })
            .padding()
            
        }
        .sheet(isPresented: $isPickerShowing) {
            // Present the photo picker view modally
            PhotoPicker(pickerResult: $pickerResultArray,
                        isPresented: $isPickerShowing)
        }
    }
}

struct Event: Identifiable, Hashable {
    let name: String
    let id = UUID()
    let imageArray: [UIImage?]
}

struct EventCreater_Previews: PreviewProvider {
    static var previews: some View {
        EventCreatorView()
    }
}


