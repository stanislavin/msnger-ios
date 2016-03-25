//
//  Errors.swift
//  Msnger
//
//  Created by Stanislav Slavin on 25/03/16.
//  Copyright © 2016 Stanislav Slavin. All rights reserved.
//

import Foundation

class Errors {
    static let ERROR_CODE_SUCCESS:Int32                      = 0;
    static let ERROR_CODE_UNSUCCESSFUL:Int32                 = -1;
    static let ERROR_CODE_TIMEOUT:Int32                      = -5;
    static let ERROR_CODE_GIS_FAILURE:Int32                  = -6;
    static let ERROR_GIS_TIMEOUT:Int32                       = -7;
    static let ERROR_INFOBIP_TIMEOUT:Int32                   = -8;
    static let ERROR_INFOBIP_REJECTED_NO_DESTINATION:Int32   = -9;
    static let ERROR_INFOBIP_PENDING:Int32                   = -10;
    static let ERROR_HOST_NOT_FOUND:Int32                    = -11;
    static let ERROR_GIS_RESULTS_EMPTY:Int32                 = -12;
    static let ERROR_INFOBIP_REJECTED_NO_PREFIX:Int32        = -13;
    
    static func errorCode2MessageTitleAndText(code:Int32) -> (title:String, text:String) {
        var title = "Message not sent"
        var text = ""
        switch code {
        case Errors.ERROR_CODE_SUCCESS:
            title = "Message sent"
        case Errors.ERROR_INFOBIP_PENDING:
            title = "Message sent"
            text = "Your message was submitted to operator for delivery."
        case Errors.ERROR_CODE_UNSUCCESSFUL:
            text = "Please try again later"
        case Errors.ERROR_CODE_TIMEOUT:
            text = "Timed out while waiting for result. Try again later."
        case Errors.ERROR_CODE_GIS_FAILURE:
            text = "Cannot retrieve street location. Try again later."
        case Errors.ERROR_GIS_TIMEOUT:
            text = "Timed out while getting street location. Try again later."
        case Errors.ERROR_INFOBIP_TIMEOUT:
            text = "Timed out while sending message. Try again later."
        case Errors.ERROR_INFOBIP_REJECTED_NO_DESTINATION:
            text = "Please check if recipient number is correct."
        case Errors.ERROR_HOST_NOT_FOUND:
            text = "Cannot connect to the server. Please check your connectivity settings."
        case Errors.ERROR_GIS_RESULTS_EMPTY:
            text = "Cannot obtain street address. Please check your GPS coverage."
        case Errors.ERROR_INFOBIP_REJECTED_NO_PREFIX:
            text = "Invalid prefix in recipient number."
        default:
            break
        }
        return (title, text)
    }
}