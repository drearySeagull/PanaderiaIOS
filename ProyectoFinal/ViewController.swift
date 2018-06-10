//
//  ViewController.swift
//  ProyectoFinal
//
//  Created by JAM on 12/2/18.
//  Copyright © 2018 JAM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, OnHttpResponse{
    

    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var pass: UITextField!
    var login: Login?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func compruebaLogin(){
        guard let cliente = ClienteHttp(target: "/auth/getRest.php", authorization : "Bearer " + (login?.token)!, responseObject: self) else {
            return
        }
        cliente.request()
    }
    func reLogin(){
        let userpass64 = login?.inicia()
        
        guard let cliente = ClienteHttp(target: "/auth/getRest.php", authorization : "Basic " + userpass64!, responseObject: self) else {
            return
        }
        cliente.request()
    }
    
    @IBAction func login(_ sender: Any) {
        let userText = user.text!;
        let passText = pass.text!;
        
        login = Login.init(userText, passText, "")
        let userpass64 = login?.inicia()
        print("-->" + userpass64! + "-->")
        
        guard let cliente = ClienteHttp(target: "/auth/login", authorization : "Basic " + userpass64!, responseObject: self) else {
            return
        }
        cliente.request()
    }
   
    func onDataReceived(data: Data) {
        var datos = RestJsonUtil.jsonToDict(data: data)
        if(datos != nil){
            //print(datos)
            if (datos!["token"] as! String != "fallo"){
                let token = datos!["token"] as! String
                if let inicio = datos!["login"] as? BooleanLiteralType{
                    if(inicio == true){
                        login?.setToken(token)
                        //llega
                        performSegue(withIdentifier: "firstSegue", sender: self)
                    }
                    else{
                        self.view.makeToast("Usuario incorrecto")
                    }
                }else if let inicio = datos!["login"] as? BooleanLiteralType{
                    if(inicio == false){
                        self.view.makeToast("Usuario incorrecto")
                    }
                }
            }
            
            if(datos!["productos"] != nil){
                print(datos!["productos"] as Any)
            }
        }else{
            print("datos nulos")
        }
    }
    
    /*
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "Navigation Controller" {
            print("ASDASDASFSDFSDFSDF")
            /*if let controler: CollectionController = segue.destination as? CollectionController{
                print("entra")
                print(login?.token)
                controler.login = login
 
            guard let controler = segue.destination as? CollectionController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
             }*/
            let controler: CollectionController = (segue.destination as? CollectionController)!
            controler.login = login!
        }
    }
 */
    
/*
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "firstSegue" {
            if let productController = segue.destination as? UINavigationController {
                productController.login = self.login
            }
        }
    }
 
 */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController{
            if let viewRecibidor = navVC.viewControllers[0] as? CollectionController{
                viewRecibidor.login = self.login! as Login
            }
        }
    }
    

    func onErrorReceivingData(message: String) {
        print(message)
    }
    
}
