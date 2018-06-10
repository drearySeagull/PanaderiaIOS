//
//  ConllectionTicketController.swift
//  ProyectoFinal
//
//  Created by Pedro Jesus on 7/3/18.
//  Copyright © 2018 JAM. All rights reserved.
//

import UIKit

class CollectionTicketController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource ,UIGestureRecognizerDelegate{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btFinCompra: UIButton!
    
    @IBAction func btFinCompra(_ sender: Any) {
        //ticketActual
        //Este es el que tienes que mandar a la base de datos
    }
    
    
    var ticketActual:Ticket!
    var nombreProductos = [String]()
    var label : UILabel!
    var myUIStepper : UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ticketActual.arrayProductos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionTicketViewCell
        
         let precio_fin = (Double(self.ticketActual.arrayCantidad[indexPath.item])) * self.ticketActual.arrayProductos[indexPath.row].precio

         cell.imagenProducto.image = self.ticketActual.arrayProductos[indexPath.item].foto
         cell.labelNombre.text = self.ticketActual.arrayProductos[indexPath.item].nombre
         cell.labelCantidad.text = String(self.ticketActual.arrayCantidad[indexPath.item])
         cell.labelPrecioUni.text = String(self.ticketActual.arrayProductos[indexPath.item].precio)
         cell.labelPrecioFin.text = String(precio_fin)
        
        
        cell.layer.borderColor = UIColor.gray.cgColor
        //cell.layer.borderWidth = 0.5
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let logoutAlert = UIAlertController(title: "Introduzca cantidad", message: "\n\n\n\n\n\n\n", preferredStyle: .alert)
        logoutAlert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        logoutAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            //Devuelve la cantidad de un producto
            //print (Int(self.myUIStepper.value))
           self.ticketActual.arrayCantidad[indexPath.item] = Int(self.myUIStepper.value)
             collectionView.reloadData()
        }))
        
        //Label
        label = UILabel(frame:CGRect(x: 0, y: 150, width: 100, height: 100))
        label.text = String(self.ticketActual.arrayCantidad[indexPath.item])
        label.center = CGPoint(x: 180,y: 80)
        
        logoutAlert.view.addSubview(label)
        
        //Stepper
        myUIStepper = UIStepper (frame:CGRect(x: 0, y: 150, width: 0, height: 0))
        // Resume UIStepper value from the beginning
        myUIStepper.wraps = true
        // Position UIStepper in the center of the view
        myUIStepper.center = CGPoint(x: 135,y: 130)
        // If tap and hold the button, UIStepper value will continuously increment
        myUIStepper.autorepeat = true
        // Set UIStepper max value to 10
        myUIStepper.value = Double(self.ticketActual.arrayCantidad[indexPath.item])
        myUIStepper.maximumValue = 20
        myUIStepper.minimumValue = 1
        myUIStepper.stepValue = 1
        myUIStepper.addTarget(self, action: #selector(updateView), for: .valueChanged)
        
        logoutAlert.view.addSubview(myUIStepper)
        //Coger el value del stepper y meterlo en el array
        
        print(Int(myUIStepper.value))
        self.present(logoutAlert, animated: true, completion: nil)
        
    }
    
    //Actualice el counter
    @objc func updateView() {
        label.text = "\(Int(myUIStepper.value))"
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}
