//
//  Service.swift
//  ShopFloxy
//
//  Created by Dio Rovelino on 25/12/22.
//


import Foundation

struct ProductModel: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: Category
    let image: String
    let rating: Rating

    enum CodingKeys: String, CodingKey {
        case id, title, price
        case description
        case category, image, rating
    }
}

enum Category: String, Codable {
    case electronics = "electronics"
    case jewelery = "jewelery"
    case menSClothing = "men's clothing"
    case womenSClothing = "women's clothing"
}

// MARK: - Rating
struct Rating: Codable {
    let rate: Double
    let count: Int
}


class ApiService {
    func loadProduct(completion: @escaping ([ProductModel]) -> ()) {
        guard let url = URL(string:"https://fakestoreapi.com/products") else {
            print("Endpoint not found")
            return
        }
        URLSession.shared.dataTask(with:url) { (data,_,_) in
            do {
                   let product = try JSONDecoder().decode([ProductModel].self, from: data!)
                   
                   DispatchQueue.main.async {
                    completion(product)
                   }
               } catch {
                   print(error)
               }
        }.resume()
    }
    func loadCategory(completion: @escaping ([String]) -> ()){
        guard let url = URL(string: "https://fakestoreapi.com/products/categories") else {
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {data, response, error in if let data = data {
            if let response = try? JSONDecoder().decode([String].self, from: data) {
                DispatchQueue.main.async {
                    completion(response)
                }
            
                return
            }
        }
        
        }.resume()
    }
 }
