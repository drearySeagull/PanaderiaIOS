//
//  Ticket.swift
//  ProyectoFinal
//
//  Created by Pedro Jesus on 4/3/18.
//  Copyright © 2018 JAM. All rights reserved.
//

import Foundation
import UIKit

class Ticket{
    var arrayProductos: [Productos]
    var arrayCantidad: [Int]
    var fecha: String
    var idLogin: String
    
    init(arrayProductos:[Productos] , arrayCantidad:[Int], fecha: String, idLogin: String) {
        self.arrayProductos = arrayProductos
        self.arrayCantidad = arrayCantidad
        self.fecha = fecha
        self.idLogin = idLogin
    }
    
    init() {
        self.arrayProductos = [Productos]()
        self.arrayCantidad = [Int]()
        self.fecha = "nil"
        self.idLogin = "nil"
    }
    
    
}


