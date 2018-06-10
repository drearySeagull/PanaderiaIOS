import Foundation

class ClienteHttp {
    // URL de nuestra API
    let urlApi: String = "https://proyecto-ios-markin.c9users.io"
    let respuesta: OnHttpResponse
    var urlPeticion: URLRequest
    // En la clasa POSO métodos que tranforman json en objetos y viceversa
    
    // Si el String no es una URL no crea la instancia
    // _ no son obligatorios
    // target - accion a ejecutar (urlApi + target)
    // responseObject - objeto a través del cual se pasa el resultado que se obtiene
    // method - GET, POST, PUT, DELETE
    // en data le pasas un diccionario con los datos que se quieren pasar en el body (los datos de json), any puede ser cualquier valor
    
    //target, destino a donde se va a mandar la peticion y toa la pesca. es la url + /panes. "nombre del archivo" sin el php
    //authorization es el bearer y basic
    //responseObject es le objeto de la clase onhttp que creamos para que notifique los cambios
    
    init?(target: String, authorization: String, responseObject: OnHttpResponse,_ method: String = "GET", _ data : [String:Any] = [:]) {
        guard let url = URL(string: self.urlApi + target) else {
            return nil
        }
        switch(method){
            case "POST":
                print("gola")
            case"GET":
                print("get")
            default://Sera el get por defecto
                print("deafult")
        }
        self.respuesta = responseObject
        self.urlPeticion = URLRequest(url: url)
        self.urlPeticion.httpMethod = method
        self.urlPeticion.addValue("application/json", forHTTPHeaderField: "Content-Type")
        self.urlPeticion.addValue(authorization, forHTTPHeaderField: "Authorization")
        
        if method != "GET" && data.count > 0 {
            guard let json = RestJsonUtil.dictToJson(data: data) else {
                return nil
            }
            self.urlPeticion.httpBody = json
        }
        
    }
    
    // crear el objeto y lanzar la petición
    // doInBackground
    func request() {
        // Iniciar el símbolo de red
        let sesion = URLSession(configuration: URLSessionConfiguration.default)
        let task = sesion.dataTask(with: self.urlPeticion,  completionHandler: self.callBack)
        task.resume()
    }
    
    // callBack es el onPostExecute
    private func callBack(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        // Conexión asíncrona a la hebra principal
        DispatchQueue.main.async {
            // Finalizar el símbolo de red
            guard error == nil else {
                self.respuesta.onErrorReceivingData(message: "este error")
                return
            }
            guard let datos = data else {
                self.respuesta.onErrorReceivingData(message: "error datos")
                return
            }
            self.respuesta.onDataReceived(data: datos)
        }
    }
}

