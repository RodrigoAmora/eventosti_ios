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
        let path = "\(self.baseURL)/evento?page=\(page)"
        
        AF.request(path,
                   method: .get,
                   encoding: URLEncoding.default)
            .response{ response in
                switch response.result {
                case .success(_):
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
                    
                    case .failure(_):
                        completion([], 0)
                        break
                }
            }
    }
    
    func buscarEventosPeloNome(nome: String, page: Int, completion: @escaping(_ eventos: [Evento]?, _ error: Int?) -> Void) {
        let path = "\(self.baseURL)/evento/buscarPorNome?nome=\(nome)&page=\(page)"
        
        AF.request(path,
                   method: .get,
                   encoding: URLEncoding.default)
            .response{ response in
                switch response.result {
                    case .success(_):
                        switch response.response?.statusCode {
                            case 200:
                                guard let data = response.data else { return }
                                do {
                                    let eventoResponse = try JSONDecoder().decode(EventoResponse.self, from: data)
                                    let eventos = eventoResponse.eventos ?? []
                                    completion(eventos, nil)
                                } catch {
                                    print("Error retriving questions \(error)")
                                    completion(nil, 0)
                                }
                                break
                            
                            case 401:
                                completion(nil, 401)
                                break
                            
                            case 403:
                                completion(nil, 403)
                                break
                            
                            case 404:
                                completion([], 403)
                                break
                            
                            case 500:
                                completion(nil, 500)
                                break
                            
                            default:
                                completion(nil, 0)
                                break
                        }
                    
                    case .failure(_):
                        completion(nil, 0)
                        break
                }
            }
    }
    
}
