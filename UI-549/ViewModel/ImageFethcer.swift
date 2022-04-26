//
//  ImageFethcer.swift
//  UI-549
//
//  Created by nyannyan0328 on 2022/04/25.
//

import SwiftUI

class ImageFethcer: ObservableObject {
    @Published var fetchImages : [ImageModel]?
    @Published var currentPage : Int = 0
    
    @Published var startPagination : Bool = false
    @Published var endPagination : Bool = false
    
    
    @Published var showAlert : Bool = false
    
    init() {
        
        updateImages()
    }
    
    func updateImages(){
        
        currentPage += 1
        Task{
            
            do{
                
                
                try await fetchImages()
                
            }
            catch{
                
                DispatchQueue.main.async {
                    
                    self.showAlert.toggle()
                }
               
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    
    func fetchImages()async throws{
        
        guard let url = URL(string: "https://psum.photos/v2/list?Page=\(currentPage)&limit=30") else{
            
            throw ImageError.failed
            
            
        }
        
        let responce = try await URLSession.shared.data(from: url)
        
        let images = try JSONDecoder().decode([ImageModel].self, from: responce.0).compactMap { item -> ImageModel? in
            
            
            let imageID = item.id
            let sizedURL = "https://picsum.photos/id/\(imageID)/1000/1000"
            let author = item.author
            
            return .init(id: imageID, download_url: sizedURL,author: author)
            
        }
        
        await MainActor.run(body: {
            if fetchImages == nil{fetchImages = []}
            fetchImages?.append(contentsOf: images)
            endPagination = (fetchImages?.count ?? 0) > 100
            startPagination = false
        })
    }
}

