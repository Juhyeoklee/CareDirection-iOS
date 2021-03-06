//
//  ProductTapService.swift
//  CareDirection
//
//  Created by 이주혁 on 2020/01/02.
//  Copyright © 2020 SwiftHelloWorld. All rights reserved.
//

import Foundation
import Alamofire

struct ProductTapService {
    static let shared = ProductTapService()
    
    let token = UserDefaults.standard
    
    func getTopTapList(completion: @escaping (NetworkResult<Any>) -> Void){
        let header : HTTPHeaders = [
            
            "Content-Type" : "application/json",
            "token" : "\(token.string(forKey: "token")!)"
        ]
        
        Alamofire.request(APIConstants.ProductTapListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseData { response in
            switch response.result {
                
            // 통신 성공 - 네트워크 연결
            case .success:
                if let value = response.result.value {
                    
                    if let status = response.response?.statusCode {
                        
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                print(value)
                                let result = try decoder.decode(ProductTap.self, from: value)
                                
                                completion(.success(result.data))
                            }
                            catch {
                                completion(.pathErr)
                                print(error.localizedDescription)
                            }
                        case 403:
                            completion(.pathErr)
                        case 500:
                            completion(.serverErr)
                        default:
                            break
                        }// switch
                    }// iflet
                }
                break
                
            // 통신 실패 - 네트워크 연결
            case .failure(let err):
                print(err.localizedDescription)
                completion(.networkFail)
                // .networkFail이라는 반환 값이 넘어감
                break
            }
        }
        
    }
    
    func getProductTop2List(component: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        
         let parameters: Parameters = [
             "query": component,
             "filter" : "nutrient",
             "limit" : 2
         ]
        Alamofire.request(APIConstants.SearchBaseURL, method: .get, parameters: parameters ,encoding: URLEncoding.queryString).responseData { response in
            
            // parameter 위치
            switch response.result {
                
            // 통신 성공 - 네트워크 연결
            case .success:
                if let value = response.result.value {
                    
                    if let status = response.response?.statusCode {
                        
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                print(value)
                                let result = try decoder.decode(ProductSearch.self, from: value)
                                
                                //print("success")
                                completion(.success(result.data.searchList))
                            }
                            catch {
                                completion(.pathErr)
                                print(error.localizedDescription)
                            }
                        case 204:
                            completion(.requestErr("no result"))
                        case 500:
                            completion(.serverErr)
                        default:
                            break
                        }// switch
                    }// iflet
                }
                break
                
            // 통신 실패 - 네트워크 연결
            case .failure(let err):
                print(err.localizedDescription)
                completion(.networkFail)
                // .networkFail이라는 반환 값이 넘어감
                break
            }
        }
    }
    
    func searchComponent(keyword: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let parameters: Parameters = [
            "query": keyword,
            "filter" : "nutrient",
        ]
        
        Alamofire.request(APIConstants.SearchBaseURL, method: .get, parameters: parameters, encoding: URLEncoding.queryString).responseData { response in
            // parameter 위치
            switch response.result {
                
            // 통신 성공 - 네트워크 연결
            case .success:
                if let value = response.result.value {
                    
                    if let status = response.response?.statusCode {
                        
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                print(response.response)
                                let result = try decoder.decode(ProductSearch.self, from: value)
                                
                                //print("success")
                                completion(.success(result.data))
                            }
                            catch {
                                completion(.pathErr)
                                print(error.localizedDescription)
                            }
                        case 204:
                            completion(.requestErr("no result"))
                        case 500:
                            completion(.serverErr)
                        default:
                            break
                        }// switch
                    }// iflet
                }
                break
                
            // 통신 실패 - 네트워크 연결
            case .failure(let err):
                print(err.localizedDescription)
                completion(.networkFail)
                // .networkFail이라는 반환 값이 넘어감
                break
            }
            
        }
    }
    
    func searchProduct(keyword: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let parameters: Parameters = [
            "query": keyword,
            "filter" : "product",
        ]
        
        Alamofire.request(APIConstants.SearchBaseURL, method: .get, parameters: parameters, encoding: URLEncoding.queryString).responseData { response in
            // parameter 위치
            switch response.result {
                
            // 통신 성공 - 네트워크 연결
            case .success:
                if let value = response.result.value {
                    
                    if let status = response.response?.statusCode {
                        
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                print(value)
                                let result = try decoder.decode(ProductSearch.self, from: value)
                                
                                //print("success")
                                completion(.success(result.data.searchList))
                            }
                            catch {
                                completion(.pathErr)
                                print(error.localizedDescription)
                            }
                        case 204:
                            completion(.requestErr("no result"))
                        case 500:
                            completion(.serverErr)
                        default:
                            break
                        }// switch
                    }// iflet
                }
                break
                
            // 통신 실패 - 네트워크 연결
            case .failure(let err):
                print(err.localizedDescription)
                completion(.networkFail)
                // .networkFail이라는 반환 값이 넘어감
                break
            }
            
        }
    }
    
    func getProductDetail(idx: Int, completion: @escaping (NetworkResult<Any>) -> Void){
        let URL = APIConstants.ProductBaseURL + "/\(idx)/info"
        
        let token = UserDefaults.standard
        
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            //"token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkeCI6MjQsImlhdCI6MTU3Nzg3NzY1NiwiZXhwIjo4Nzk3Nzg3NzY1NiwiaXNzIjoiY2FyZS1kaXJlY3Rpb24ifQ.WysKIH3-qDf3GTR-RKKl23hp_9byodzDm7TdISMTkmk"
            "token" : "\(token.string(forKey: "token")!)"
        ]

        
        Alamofire.request(URL, method: .get,parameters: nil ,encoding: JSONEncoding.default, headers: header).responseData { response in
            
            // parameter 위치
            switch response.result {
                
            // 통신 성공 - 네트워크 연결
            case .success:
                if let value = response.result.value {
                    
                    if let status = response.response?.statusCode {
                        
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                
                                let result = try decoder.decode(ProductDetail.self, from: value)
                                
                                completion(.success(result.data))
                            }
                            catch {
                                completion(.pathErr)
                                print(error.localizedDescription)
                            }
                        case 401:
                            completion(.requestErr("invalid token"))
                        case 500:
                            completion(.serverErr)
                        default:
                            break
                        }// switch
                    }// iflet
                }
                break
                
            // 통신 실패 - 네트워크 연결
            case .failure(let err):
                print("detail network fail")
                print(err.localizedDescription)
                completion(.networkFail)
                // .networkFail이라는 반환 값이 넘어감
                break
            }
        }
    }
    
    func productDetailEfficacy(idx: Int, completion: @escaping (NetworkResult<Any>) -> Void){
        let URL = APIConstants.ProductBaseURL + "/\(idx)/efficacy"
        let token = UserDefaults.standard
        
        //let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkeCI6MjQsImlhdCI6MTU3Nzg3NzY1NiwiZXhwIjo4Nzk3Nzg3NzY1NiwiaXNzIjoiY2FyZS1kaXJlY3Rpb24ifQ.WysKIH3-qDf3GTR-RKKl23hp_9byodzDm7TdISMTkmk"
        
        let header: HTTPHeaders = [
            //"token" : token
            "token" : "\(token.string(forKey: "token")!)"
        ]
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseData(){
            response in
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    
                    if let status = response.response?.statusCode {
                        
                        switch status {
                        case 200:
                            do {

                                print(value)
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(ProductEfficacy.self, from: value)
                                completion(.success(result.data))
                            }
                            catch {
                                print("productDetailEfficacy decode error")
                                completion(.pathErr)
                                print(error.localizedDescription)
                            }
                        case 401:
                            completion(.requestErr("invalid token"))
                        case 500:
                            completion(.serverErr)
                        default:
                            break
                        }// switch
                    }// iflet
                }
                break
                
            // 통신 실패 - 네트워크 연결
            case .failure(let err):
                print(err.localizedDescription)
                completion(.networkFail)
                // .networkFail이라는 반환 값이 넘어감
                break
            }
        }
    }
    func lowerPriceData(idx: Int, quantity: Int, completion: @escaping(NetworkResult<Any>) -> Void){
        let URL = APIConstants.ProductBaseURL + "/\(idx)/lowprice"
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    
                    if let status = response.response?.statusCode {
                        
                        switch status {
                        case 201:
                            do {
                                let decoder = JSONDecoder()
  
                                let result = try decoder.decode(ProductLowerPrice.self, from: value)
                                
                                completion(.success(result.data))
                            }
                            catch {
                                completion(.pathErr)
                                print(error.localizedDescription)
                            }
                        case 401:
                            completion(.requestErr("invalid token"))
                        case 500:
                            completion(.serverErr)
                        default:
                            break
                        }// switch
                    }// iflet
                }
                break
                
            // 통신 실패 - 네트워크 연결
            case .failure(let err):
                print(err.localizedDescription)
                completion(.networkFail)
                // .networkFail이라는 반환 값이 넘어감
                break
            }
        }
        
    }
    
    func getProductComponentStandard(idx: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let URL = APIConstants.ProductBaseURL + "/\(idx)/standard"
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        let parameters: Parameters = [
                  "product_idx": idx,
              ]
        
        Alamofire.request(URL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: header).responseData() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    
                    if let status = response.response?.statusCode {
                        
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                print(value)
                                let result = try decoder.decode(ProductStandard.self, from: value)
                                
                                completion(.success(result.data))
                            }
                            catch {
                                completion(.pathErr)
                                print(error.localizedDescription)
                            }
                        case 400:
                            completion(.requestErr("invalid data"))
                        case 500:
                            completion(.serverErr)
                        default:
                            break
                        }// switch
                    }// iflet
                }
                break
                
            // 통신 실패 - 네트워크 연결
            case .failure(let err):
                print(err.localizedDescription)
                completion(.networkFail)
                // .networkFail이라는 반환 값이 넘어감
                break
            }
        }
    }
    
    
}
