import Foundation
import Alamofire
import SwiftyJSON

public class FDNetwork : NSObject{
    
    //class func
    public class func getVersion() -> String {
        return "1.0"
    }
    
    public class func getBuildVersion() -> String {
        return "20210630"
    }
    
    public class func GET(url : String, param : [String : String]?, success : @escaping ((Any)->()), failure : @escaping ((String)->())) {
        FDNetwork.HTTP(method: .get, url: url, header: nil, param: param, success: success, failure: failure)
    }
    
    public class func POST(url : String, param : [String : String]?, success : @escaping ((Any)->()), failure : @escaping ((String)->())) {
        FDNetwork.HTTP(method: .post, url: url, header: nil, param: param, success: success, failure: failure)
    }
    
    public class func PUT(url : String, param : [String : String]?, success : @escaping ((Any)->()), failure : @escaping ((String)->())) {
        FDNetwork.HTTP(method: .put, url: url, header: nil, param: param, success: success, failure: failure)
    }
    
    public class func DELETE(url : String, param : [String : String]?, success : @escaping ((Any)->()), failure : @escaping ((String)->())) {
        FDNetwork.HTTP(method: .delete, url: url, header: nil, param: param, success: success, failure: failure)
    }
    
    public class func PATCH(url : String, param : [String : String]?, success : @escaping ((Any)->()), failure : @escaping ((String)->())) {
        FDNetwork.HTTP(method: .patch, url: url, header: nil, param: param, success: success, failure: failure)
    }

    public class func GET(url : String, header: [String : String]?, param : [String : String]?, success : @escaping ((Any)->()), failure : @escaping ((String)->())) {
        FDNetwork.HTTP(method: .get, url: url, header: header, param: param, success: success, failure: failure)
    }
    
    public class func POST(url : String, header: [String : String]?, param : [String : String]?, success : @escaping ((Any)->()), failure : @escaping ((String)->())) {
        FDNetwork.HTTP(method: .post, url: url, header: header, param: param, success: success, failure: failure)
    }
    
    public class func PUT(url : String, header: [String : String]?, param : [String : String]?, success : @escaping ((Any)->()), failure : @escaping ((String)->())) {
        FDNetwork.HTTP(method: .put, url: url, header: header, param: param, success: success, failure: failure)
    }
    
    public class func DELETE(url : String, header: [String : String]?, param : [String : String]?, success : @escaping ((Any)->()), failure : @escaping ((String)->())) {
        FDNetwork.HTTP(method: .delete, url: url, header: header, param: param, success: success, failure: failure)
    }
    
    public class func PATCH(url : String, header: [String : String]?, param : [String : String]?, success : @escaping ((Any)->()), failure : @escaping ((String)->())) {
        FDNetwork.HTTP(method: .patch, url: url, header: header, param: param, success: success, failure: failure)
    }
    
    public class func HTTP(method: HTTPMethod, url : String, header: [String : String]?, param : [String : String]?, success : @escaping ((Any)->()), failure : @escaping ((String)->())) {
        let httpHeader = HTTPHeaders.init(header ?? [:])
        AF.request(url, method: method, parameters: param, encoder: URLEncodedFormParameterEncoder.default, headers: httpHeader, interceptor: nil)
            .responseData { response in
                switch response.result {
                case .success:
                    if response.data != nil {
                        let json = JSON(response.data ?? Data.init())
                        if (json.dictionaryObject != nil) {
                            success(json.dictionaryObject!)
                        }else if (json.arrayObject != nil){
                            success(json.arrayObject!)
                        }else{
                            let string = String(data: response.data!, encoding: .utf8)
                            let str = string as! NSString
                            if str.hasPrefix("**YGKJ") && str.hasSuffix("YGKJ##") {
                                let preStr = str.substring(from: 6) as! NSString
                                let sufStr = preStr.substring(to: preStr.length - 6)
                                let newJson = JSON.init(parseJSON: sufStr)
                                if newJson.dictionaryObject != nil {
                                    success(newJson.dictionaryObject!)
                                }else{
                                    failure(NSLocalizedString("Network.RequestFailed", comment: ""))
                                }
                            }else{
                                failure(NSLocalizedString("Network.RequestFailed", comment: ""))
                            }
                        }
                    }else{
                        success(response.data!)
                    }
                case let .failure(error):
                    failure(error.localizedDescription)
                }
            }
    }
    
    static let manager = FDNetwork()

    private class func defaultManager() ->FDNetwork {
        return manager
    }
}

