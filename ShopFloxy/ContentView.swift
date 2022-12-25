//
//  ContentView.swift
//  ShopFloxy
//
//  Created by Dio Rovelino on 25/12/22.
//

import SwiftUI
import Kingfisher


struct ContentView: View {
    var body: some View {
            TabView{
                ScrollView{
                    VStack {
                        HeaderView()
                        CategoryView().padding(.top, 30)
                        Text("Products").fontWeight(Font.Weight.bold).font(.system(size:28)).padding(.top,50)
                        ContentShop().padding(.top, 10)
                        Spacer()
                    }.padding()
                }.tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                Text("Feed Screen").tabItem {
                    Image(systemName: "books.vertical")
                    Text("Feed")
                }
                
                Text("Wishlist Screen").tabItem {
                    Image(systemName: "suit.heart")
                    Text("Wishlist")
                }
                
                Text("Profile Screen").tabItem {
                    Image(systemName: "person")
                    Text("Person")
                }
                
            }
    }
   
}

struct HeaderView: View {
    var body: some View {
        VStack {
            HStack{
                    Text("TOKOPAKEDI").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                Image("bell").resizable().frame(width: 20,height: 20)
                KFImage(URL(string: "https://randomuser.me/api/portraits/women/50.jpg")).resizable().frame(width:40,height:40).clipShape(Circle())
            }
        }
    }
}

struct CategoryView: View {
    @State var results = [String]()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators:false) {
            HStack{
                ForEach(results, id:\.self) {
                    item in Button(action: {
                        print(item)
                    }) {
                        Text(item.firstCapitalized).padding()
                    }.background(Color.blue).foregroundColor(.white).cornerRadius(5)
                }
            }.onAppear {
                ApiService().loadCategory{ (category) in self.results = category}

            }
        }
    }
    
}

struct ContentShop: View {
    @State var resultContent = [ProductModel]()
    var body: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()),GridItem(.flexible())],
            spacing: 16) {
            ForEach(resultContent, id:\.id) { item in
                VStack {
                    KFImage(URL(string: item.image)).resizable().frame(height:200)
                    Text(item.title).frame(maxWidth: 150)
                        .lineLimit(nil)
                        .fixedSize()
                    Text("$\(item.price.removeZerosFromEnd())").foregroundColor(.gray).frame(maxWidth: 150,alignment:Alignment.trailing)
                }
               
            }
        }.onAppear {
            ApiService().loadProduct{ (resultContent) in self.resultContent = resultContent}
        }
    
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
