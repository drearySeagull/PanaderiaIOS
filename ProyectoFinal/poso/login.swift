//
//  login.swift
//  ProyectoFinal
//
//  Created by Dam on 20/2/18.
//  Copyright © 2018 JAM. All rights reserved.
//

import UIKit


class Login {
    
    var usr : String
    var pass : String
    var token : String
    
    init(_ usr: String,_ pass: String, _ token : String) {
        self.usr = usr
        self.pass = pass
        self.token = token
    }
    
    func setToken( _ token : String){
        self.token = token
    }
    func inicia() -> String? {
        
        let base64 = toBase64(cadena: self.usr + ":" + self.pass)
        return base64
    }
    
    func toBase64(cadena: String) -> String? {
        guard let data = cadena.data(using: .utf8) else {
            return nil
        }
        return data.base64EncodedString()
    }
    
    
}
