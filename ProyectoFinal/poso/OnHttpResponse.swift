import Foundation


protocol OnHttpResponse{
    
    func onDataReceived(data: Data)
    func onErrorReceivingData(message: String)
    
}


