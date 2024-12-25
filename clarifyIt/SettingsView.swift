//
//  SettingsView.swift
//  clarifyIt
//
//  Created by Ghadah Alhagbani on 18/06/1446 AH.
//

import SwiftUI
import SwiftData
struct SettingsView: View {
    
  //  @Query(sort:\ DataModel.name) var dataModel: [DataModel]
    //bindable
    @Bindable var user: DataModel
    
    @Environment(\.presentationMode) var presentationMode
    
    
//    @State public var selectedLanguage: String = ""
//    @State public var updatedName: String = ""
//    @State public var understandingLevel: String = ""

    
    var body: some View {
        NavigationView {
            VStack {
                
                Form {
                    VStack (alignment: .leading){
                        Spacer()
                        Spacer()
                        
                        
                        HStack(spacing: 40){
                            Text("Name: ")
                                .font(.custom("SF Pro Text", size: 16)).fontWeight(.medium)
                            //MARK: remove double couts
                         //   TextField(dataModel.last!.name , text: $updatedName)
                            TextField("", text: $user.name)
                            
                            
                        }
                        Divider()
                        Spacer()
                        Spacer()
                        
                        
                        Text("Language of Learning")
                            .font(.custom("SF Pro Text", size: 16)).fontWeight(.medium)
                        Spacer()
                        
                        Picker("Landuage of Learning", selection: $user.selectedLanguage) {
                                    
                                    Text("Arabic").tag("Arabic")
                                    Text("English").tag("English")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                        
                        Spacer()
                        Spacer()
                        
                        
                        Text("Level of Understanding Words")
                            .font(.custom("SF Pro Text", size: 16)).fontWeight(.medium)
                        Spacer()
                        Picker("Understanding Level", selection: $user.understandingLevel) {
                            Text("Low").tag("Low")
                            Text("Middle").tag("Middle")
                            Text("High").tag("High")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        
                        Spacer()
                        Spacer()
                    }
                    .scrollContentBackground(.hidden)
                } //VStack close
                
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            // Handle save action here
//                            dataModel.last!.name = updatedName
                            
                            
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.accentColor)
                        .bold()
                    }
                }
                .navigationBarBackButtonHidden(true)
            } //NavigationView Close
            
//            .onAppear {
//                
//                updatedName = dataModel.name
//                selectedLanguage = dataModel.selectedLanguage
//                understandingLevel = dataModel.understandingLevel
//            }
            
        }
    }
}


    
//
//#Preview {
//    SettingsView()
//}
