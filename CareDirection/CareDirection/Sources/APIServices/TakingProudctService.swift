//
//  TakingProudctService.swift
//  CareDirection
//
//  Created by 이주혁 on 2020/01/02.
//  Copyright © 2020 SwiftHelloWorld. All rights reserved.
//

import Foundation
import Alamofire


struct TakingProductService {
    static let shared = TakingProductService()
    
    func getCurrentTakingList(date: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        //let token = UserDefaults.standard
        
        let header : HTTPHeaders = [
            "Content-Type" : "application/json",
            "token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkeCI6MjQsImlhdCI6MTU3Nzg3NzY1NiwiZXhwIjo4Nzk3Nzg3NzY1NiwiaXNzIjoiY2FyZS1kaXJlY3Rpb24ifQ.WysKIH3-qDf3GTR-RKKl23hp_9byodzDm7TdISMTkmk"
        ]

        let body : Parameters = [
            "date" : date
        ]
        
        Alamofire.request(APIConstants.ProductDoseURL, method: .get, parameters: body, encoding: URLEncoding.default, headers: header).responseData(){ response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    
                    if let status = response.response?.statusCode {
                        
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(TakingProductInfoList.self, from: value)
                                completion(.success(result.data))
                            }
                            catch {
                                completion(.pathErr)
                                print(error.localizedDescription)
                            }
                        case 400:
                            completion(.requestErr("입력 값에 null이 존재합니다."))
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
    
    func searchProductToRegist(keyword: String, completion: @escaping(NetworkResult<Any>)->Void){
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkeCI6MjR9.3M9PT1mj9u13eAAhtwBJ7Y4Gn2MaJ2D09Fyvt_MLEkE"
        
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "token": token
        ]
        let parameter: Parameters = [
            "query" : keyword
        ]
        
        Alamofire.request(APIConstants.SearchDoseProductURL, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: header).responseData(){ response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    
                    if let status = response.response?.statusCode {
                        
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(TakingProductSearchList.self, from: value)
                                completion(.success(result.data))
                            }
                            catch {
                                completion(.pathErr)
                                print(error.localizedDescription)
                            }
                        case 400:
                            completion(.requestErr("입력 값에 null이 존재합니다."))
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
    func getProductSimpleData(idx: Int, completion: @escaping (NetworkResult<Any>) -> Void){
        let URL = APIConstants.ProductBaseURL + "/\(idx)/"
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkeCI6MjQsImlhdCI6MTU3Nzg3NzY1NiwiZXhwIjo4Nzk3Nzg3NzY1NiwiaXNzIjoiY2FyZS1kaXJlY3Rpb24ifQ.WysKIH3-qDf3GTR-RKKl23hp_9byodzDm7TdISMTkmk"
        
        let header: HTTPHeaders = [
            "token" : token
        ]
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseData() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    if let status = response.response?.statusCode {
                        
                        switch status {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(SimpleProductResult.self, from: value)
                                print(result)
                                completion(.success(result.data))
                            }
                            catch {
                                completion(.pathErr)
                                print(error.localizedDescription)
                            }
                        case 400:
                            completion(.requestErr("입력값에 Null Value"))
                        case 401:
                            completion(.requestErr("유효하지 않은 token 입니다."))
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
    
    func registTakingProduct(idx: Int, quantity: Int, startDate: String, alarm: String, completion: @escaping(NetworkResult<Any>) -> Void){
        let URL = APIConstants.ProductBaseURL + "/\(idx)/dose"
        
        let body:Parameters = [
            "dose_daily_quantity" : quantity,
            "dose_start_date" : startDate,
            "dose_alarm" : alarm
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData(){
            response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    
                    if let status = response.response?.statusCode {
                        
                        switch status {
                        case 201:
                            do {
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(ResponseString2.self, from: value)
                                print(result)
                                completion(.success(result.message))
                            }
                            catch {
                                completion(.pathErr)
                                print(error.localizedDescription)
                            }
                        case 403:
                             completion(.requestErr("duplicated"))
                        case 400:
                            completion(.requestErr("입력값에 Null Value"))
                        case 401:
                            completion(.requestErr("유효하지 않은 token 입니다."))
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
