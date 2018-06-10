//
//  CollectionControler.swift
//  ProyectoFinal
//
//  Created by Dam on 2/3/18.
//  Copyright © 2018 JAM. All rights reserved.
//

import UIKit

class CollectionController: UIViewController, OnHttpResponse, UICollectionViewDelegate, UICollectionViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, UIWebViewDelegate{
    

    
    var product = [Productos]()
    
    func onDataReceived(data: Data) {
        //print("Llegar llega")
        var datos = RestJsonUtil.jsonToDict(data: data)
        if(datos != nil){
            //print(datos)
            if (datos!["productos"] != nil){
                print(datos!["product"] as Any)
                let productos: String = datos!["productos"] as! String
                //print("-------------------------------------------------")
                //print(productos)
                var todosProductos: [String] = productos.components(separatedBy: "otro,")
                print("---->" + todosProductos[0] + "<----")
                for producto in todosProductos{
                    var cadaProducto: [String] = producto.components(separatedBy: "-")
                    //print(cadaProducto[2])
                    product.append(Productos(nombre: cadaProducto[2], precio: Double(cadaProducto[3])!, id: Int(cadaProducto[0])!)!)//aqui llega
                    //k va tio no sale nada no se k pasa, voy
                }
                for productos in product{
                    print(productos.nombre)
                    productos.downloadImage()
                    print("--------")
                    print(productos.foto as Any)
                    print("-------------------")
                }
                
                collection.reloadData()
            }else{
                print("No hay productos")
            }
        }
        else{
            print("es nulo")
        }
    }
    //{} []
    func onErrorReceivingData(message: String) {
        print("fallo Datos 1get")
    }
    
    var login: Login? = nil
    var precioFin: Double = 0.0
    var nombre: String = ""
    var precio:Double = 0.0
    var arrayProductos: [Productos] = []
    var nombreProductos = [String]()
    var arrayCantidad: [Int] = []
    var arrayCuentaFin: [Double] = []
    var ticketActual:Ticket = Ticket()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        primerGet()
        // Do any additional setup after loading the view, typically from a nib.
        //Collectionview
        collection.delegate = self
        collection.dataSource = self
        
        //SearchBar
        
        
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Buscar Productos"
        definesPresentationContext = true
    

        

			
        
        let layout = self.collection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collection.frame.size.width - 20)/2,height: (self.collection.frame.size.height/3) )
        
    }
    

    
    
    func primerGet(){
        print("Primer Get")
        //llega
        guard let cliente = ClienteHttp(target: "/auth/productos", authorization : "Bearer " + (login?.token)!, responseObject: self) else {
            return
        }
        cliente.request()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        var searchActive : Bool = false
        let searchController = UISearchController(searchResultsController: nil)
        var label : UILabel!
        var myUIStepper : UIStepper!
    
    
    @IBOutlet weak var labelFinTicket: UIButton!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var labelDinero: UILabel!
    
        /*var product: [Productos] = [
            Productos(nombre: "Whoper",foto: UIImage(named: "whoper")!,precio: 5.50, id: 1),
            Productos(nombre: "Baconator",foto: UIImage(named: "baconator")!,precio: 6.50, id: 2),
            Productos(nombre: "Quarter Pounder",foto: UIImage(named: "quarterPounder")!,precio: 5.0, id: 3),
            Productos(nombre: "Hamburguer",foto: UIImage(named: "hamburguer")!,precio: 1.0, id: 4),
            Productos(nombre: "CheeseBurguer",foto: UIImage(named: "cheeseburguer")!,precio: 7.0, id: 5),
            Productos(nombre: "Big Mac",foto: UIImage(named: "bigmac")!,precio: 8.0, id: 6)
        ]*/
        var filteredProduct = [Productos]()
        
        //MARK: Search Bar
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchActive = false
            //collectionView.reloadData()
            self.searchController.dismiss(animated: true, completion: nil)
        }
        
        func searchBarIsEmpty() -> Bool {
            // Returns true if the text is empty or nil
            return searchController.searchBar.text?.isEmpty ?? true
        }
        
        func filterContentForSearchText(_ searchText: String, scope: String = "All") {
            filteredProduct = product.filter({( product : Productos) -> Bool in
                return product.nombre.lowercased().contains(searchText.lowercased())
            })
            
            collection.reloadData()
        }
        
        func updateSearchResults(for searchController: UISearchController) {
            filterContentForSearchText(searchController.searchBar.text!)
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchActive = true
            collection.reloadData()
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchActive = false
            collection.reloadData()
        }
        
        func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
            if !searchActive {
                searchActive = true
                collection.reloadData()
            }
            
            searchController.searchBar.resignFirstResponder()
        }
        
        //Resultado de busqueda
        func isFiltering() -> Bool {
            return searchController.isActive && !searchBarIsEmpty()
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            if isFiltering() {
                return filteredProduct.count
            }
            return product.count
        }
    
    
    @IBAction func pressLAbelFinTicket(_ sender: UIButton) {
        //let ticket: Ticket
        
        //Date
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        print(myStringafd)
        
        
        
        print("--------")

        print("--------")
        
        print("IDLogin : " + (self.login?.usr)!)
        print("--------")
        print("Cant    Producto                       PrecioUnitario   PrecioTotal")
        for i in 0 ... (arrayProductos.count-1) {
            self.arrayCuentaFin.append(self.arrayProductos[i].precio * Double(self.arrayCantidad[i]))
            print((String(self.arrayCantidad[i])) + "       " + self.arrayProductos[i].nombre + "               " + (String(self.arrayProductos[i].precio) + "        " + (String(self.arrayCuentaFin[i]))))
        }
        print("Cuenta: " + String(format: "%.2f" , (Double(self.precioFin))) + " Euros")
        print("--------")
        
     
        for productos in self.arrayProductos{
            self.nombreProductos.append(productos.nombre)
        }
        
        self.ticketActual = Ticket(arrayProductos: self.arrayProductos ,arrayCantidad: self.arrayCantidad ,fecha: myStringafd ,idLogin: (String(describing: self.login?.usr)))
        //(arrayProductos: self.arrayProductos ,arrayCantidad: self.arrayCantidad ,fecha: myStringafd,idLogin: (String(self.login?.usr)))
        
        performSegue(withIdentifier: "secondSegue", sender: self)
    }
    
        //Al hacer click en una celda
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let cell = collection.cellForItem(at: indexPath)
            cell?.layer.borderColor = UIColor.gray.cgColor
            cell?.layer.borderWidth = 2
            
            
            let logoutAlert = UIAlertController(title: "Introduzca cantidad", message: "\n\n\n\n\n\n\n", preferredStyle: .alert)
            logoutAlert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
            logoutAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
                //Devuelve la cantidad de un producto
                //print (Int(self.myUIStepper.value))
                
                if(self.isFiltering()){
                    //Me devuelve el nombre y el precio del objeto pulsado
                    self.nombre = self.filteredProduct[indexPath.row].nombre
                    self.precio = self.filteredProduct[indexPath.row].precio
                    
                    self.arrayProductos.append(self.filteredProduct[indexPath.row])
                }
                else{
                    self.nombre = self.product[indexPath.row].nombre
                    self.precio = self.product[indexPath.row].precio
                    
                    self.arrayProductos.append(self.product[indexPath.row])
                }
                let precio_tot = self.precio * (Double(self.myUIStepper.value))
                
                self.arrayCantidad.append(Int(self.myUIStepper.value))
                
                //print(nombre)
                //print("Una solo vale =",precio,"euros")
                //print("Precio total de este producto =",precio_tot,"euros")
                
                
                self.precioFin=precio_tot+self.precioFin
                
                //print("Precio total de este producto =",self.precioFin,"euros")
    
                let stringPrecio = String(format: "%.2f" , (Double(self.precioFin)))
                let stringLabel = (stringPrecio + " €")
                
                self.labelDinero.text = stringLabel
                
                
                //------------- Ticket ------------------
                
                
                
                
            }))
            
            //Label
            label = UILabel(frame:CGRect(x: 0, y: 150, width: 100, height: 100))
            label.text = "1"
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
            myUIStepper.maximumValue = 20
            myUIStepper.minimumValue = 1
            myUIStepper.stepValue = 1
            myUIStepper.addTarget(self, action: #selector(updateView), for: .valueChanged)
            
            logoutAlert.view.addSubview(myUIStepper)
            
            self.present(logoutAlert, animated: true, completion: nil)
            
        }
        
        //Actualice el counter
        @objc func updateView() {
            label.text = "\(Int(myUIStepper.value))"
        }
        
        func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            let cell = collection.cellForItem(at: indexPath)
            cell?.layer.borderColor = UIColor.gray.cgColor
            cell?.layer.borderWidth = 2
        }
    
    //celda
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 2
        
        
        print("ASDASDASDASDASDDS")
        if isFiltering() {
            //cell.imageProduct!.image = filteredProduct[indexPath.row].foto --> Original
            cell.imageProduct!.image = filteredProduct[indexPath.row].foto
            cell.labelName!.text = filteredProduct[indexPath.row].nombre
            cell.labelPrecio!.text = String(filteredProduct[indexPath.row].precio)
        } else {
            cell.imageProduct!.image = product[indexPath.row].foto
            cell.labelName!.text = product[indexPath.row].nombre
            cell.labelPrecio!.text = "\(product[indexPath.row].precio)"
        }
        
        return cell
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "secondSegue" {
           if let productController = segue.destination as? TicketViewController {
            productController.ticketActual = self.ticketActual
            productController.nombreProductos = self.nombreProductos
            }
        }
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController{
            if let productController = navVC.viewControllers[0] as? CollectionTicketController{
                productController.ticketActual = self.ticketActual
                productController.nombreProductos = self.nombreProductos
            }
        }
    }
    
    //let precio_fin = (Double(self.ticketActual.arrayCantidad[indexPath.row])) * self.ticketActual.arrayProductos[indexPath.row].precio
    
    /*
    // set the text from the data model
    //cell.textLabel?.text = self.nombreProductos[indexPath.row]
    cell.imagenProducto.image = self.ticketActual.arrayProductos[indexPath.row].foto
    cell.labelNombre.text = self.ticketActual.arrayProductos[indexPath.row].nombre
    cell.labelCantidad.text = String(self.ticketActual.arrayCantidad[indexPath.row])
    cell.labelPrecioUni.text = String(self.ticketActual.arrayProductos[indexPath.row].precio)
    cell.labelPrecioFin.text = String(precio_fin)
    
*/
 
}
        
        
        

