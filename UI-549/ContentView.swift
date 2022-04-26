//
//  ContentView.swift
//  UI-549
//
//  Created by nyannyan0328 on 2022/04/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @StateObject var model : ImageFethcer = .init()
    var body: some View {
        NavigationView{
            
            Group{
                
                if let images = model.fetchImages{
                    
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        ComptionLayoutView(items:images,id:\.self) { item in
                            
                            VStack{
                                
                                GeometryReader{proxy in
                                    
                                    let size = proxy.size
                                    
                                    WebImage(url: URL(string:item.download_url))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: size.width, height: size.height)
                                        .cornerRadius(10)
                                        .onAppear {
                                            
                                            if images.last?.id == item.id{
                                                
                                                model.startPagination = true
                                            }
                                        }
                                }
                                
                                Text(item.author)
                                    .font(.callout.weight(.bold))
                                    .foregroundColor(.gray)
                                
                                Divider()
                            }
                            
                          
                        }
                        .padding()
                        .padding(.bottom,10)
                        
                        if model.startPagination && !model.endPagination{
                            
                            ProgressView()
                                .offset(y: -15)
                                .onAppear {
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        
                                        
                                        model.updateImages()
                                        
                                    }
                                }
                            
                        }
                        
                        
                    }
                    .navigationTitle("Commpotion Layout")
                    
                }
                else{
                    
                    ProgressView()
                }
                
                
            }
        }
        .alert("URL Failed", isPresented: $model.showAlert) {
            
            
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
