//
//  Productos.swift
//  ProyectoFinal
//
//  Created by Dam on 26/2/18.
//  Copyright © 2018 JAM. All rights reserved.

//https://www.hackingwithswift.com/example-code/media/how-to-save-a-uiimage-to-a-file-using-uiimagepngrepresentation

import Foundation
import UIKit

class Productos{
    var nombre: String
    var foto: UIImage?
    var precio: Double
    var id: Int
    
    init(nombre: String, foto: UIImage, precio: Double, id: Int){
        self.nombre = nombre
        self.foto = foto
        self.precio = precio
        self.id = id
    }
    init?(nombre: String, precio: Double, id: Int){
        self.nombre = nombre
        self.precio = precio
        self.id = id
    }
        
    func downloadImage(){
        let urlImage = "https://proyecto-ios-markin.c9users.io/img/\(id).jpg"
        guard let url = URL(string: urlImage) else{print("error en \(id)");return}
        let group = DispatchGroup()
        group.enter()
        let thread = DispatchQueue(label: "imageDownload", qos: .default, attributes: .concurrent)
        thread.async{
            guard let data = try? Data(contentsOf: url),
                let img = UIImage(data: data) else{
                    group.leave();
                    return
            }
            self.foto = img
            group.leave()
        }
        group.wait()
    }
}





