//
//  EventoService.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 21/05/24.
//

import Foundation
import Alamofire

class EventoService {
    
    private let baseURL = ApiUrls.baseEventosTIAPIURL()
    
    func buscarEventos(page: Int, completion: @escaping(_ eventos: [Evento], _ error: Int?) -> Void) {
        let path = "\(self.baseURL)/api/evento?page=\(page)"
        
        AF.request(path,
                   method: .get,
                   encoding: URLEncoding.default)
            .response{ response in
                switch response.result {
                    case .success(let json):
                        switch response.response?.statusCode {
                            case 200:
                                guard let data = response.data else { return }
                                do {
                                    let eventoResponse = try JSONDecoder().decode(EventoResponse.self, from: data)
                                    let eventos = eventoResponse.eventos ?? []
                                    completion(eventos, nil)
                                } catch {
                                    print("Error retriving questions \(error)")
                                    completion([], 0)
                                }
                                break
                            
                            case 401:
                                completion([], 401)
                                break
                            
                            case 403:
                                completion([], 403)
                                break
                            
                            case 500:
                                completion([], 500)
                                break
                            
                            default:
                                completion([], 0)
                                break
                        }
                    
                    case .failure(let error):
                        completion([], 0)
                        break
                }
            }
    }
    
}
