//
//  Caa.swift
//  Tools
//
//  Created by 范东 on 2021/8/11.
//

import UIKit

class CurrencyConverterModel: BaseModel {
    var base_code = ""
    var conversion_rates = CurrencyConverterModelConversion_rates()
    var documentation = ""
    var result = ""
    var terms_of_use = ""
    var time_last_update_unix: Int = 0
    var time_last_update_utc = ""
    var time_next_update_unix: Int = 0
    var time_next_update_utc = ""

}

class CurrencyConverterModelConversion_rates: BaseModel {
    var AED: Float = 0.0
    var AFN: Float = 0.0
    var ALL: Float = 0.0
    var AMD: Float = 0.0
    var ANG: Float = 0.0
    var AOA: Float = 0.0
    var ARS: Float = 0.0
    var AUD: Float = 0.0
    var AWG: Float = 0.0
    var AZN: Float = 0.0
    var BAM: Float = 0.0
    var BBD: Float = 0.0
    var BDT: Float = 0.0
    var BGN: Float = 0.0
    var BHD: Float = 0.0
    var BIF: Float = 0.0
    var BMD: Float = 0.0
    var BND: Float = 0.0
    var BOB: Float = 0.0
    var BRL: Float = 0.0
    var BSD: Float = 0.0
    var BTN: Float = 0.0
    var BWP: Float = 0.0
    var BYN: Float = 0.0
    var BZD: Float = 0.0
    var CAD: Float = 0.0
    var CDF: Float = 0.0
    var CHF: Float = 0.0
    var CLP: Float = 0.0
    var CNY: Float = 0.0
    var COP: Float = 0.0
    var CRC: Float = 0.0
    var CUC: Float = 0.0
    var CUP: Float = 0.0
    var CVE: Float = 0.0
    var CZK: Float = 0.0
    var DJF: Float = 0.0
    var DKK: Float = 0.0
    var DOP: Float = 0.0
    var DZD: Float = 0.0
    var EGP: Float = 0.0
    var ERN: Float = 0.0
    var ETB: Float = 0.0
    var EUR: Float = 0.0
    var FJD: Float = 0.0
    var FKP: Float = 0.0
    var FOK: Float = 0.0
    var GBP: Float = 0.0
    var GEL: Float = 0.0
    var GGP: Float = 0.0
    var GHS: Float = 0.0
    var GIP: Float = 0.0
    var GMD: Float = 0.0
    var GNF: Float = 0.0
    var GTQ: Float = 0.0
    var GYD: Float = 0.0
    var HKD: Float = 0.0
    var HNL: Float = 0.0
    var HRK: Float = 0.0
    var HTG: Float = 0.0
    var HUF: Float = 0.0
    var IDR: Float = 0.0
    var ILS: Float = 0.0
    var IMP: Float = 0.0
    var INR: Float = 0.0
    var IQD: Float = 0.0
    var IRR: Float = 0.0
    var ISK: Float = 0.0
    var JMD: Float = 0.0
    var JOD: Float = 0.0
    var JPY: Float = 0.0
    var KES: Float = 0.0
    var KGS: Float = 0.0
    var KHR: Float = 0.0
    var KID: Float = 0.0
    var KMF: Float = 0.0
    var KRW: Float = 0.0
    var KWD: Double = 0.0
    var KYD: Float = 0.0
    var KZT: Float = 0.0
    var LAK: Float = 0.0
    var LBP: Float = 0.0
    var LKR: Float = 0.0
    var LRD: Float = 0.0
    var LSL: Float = 0.0
    var LYD: Float = 0.0
    var MAD: Float = 0.0
    var MDL: Float = 0.0
    var MGA: Float = 0.0
    var MKD: Float = 0.0
    var MMK: Float = 0.0
    var MNT: Float = 0.0
    var MOP: Float = 0.0
    var MRU: Float = 0.0
    var MUR: Float = 0.0
    var MVR: Float = 0.0
    var MWK: Float = 0.0
    var MXN: Float = 0.0
    var MYR: Float = 0.0
    var MZN: Float = 0.0
    var NAD: Float = 0.0
    var NGN: Float = 0.0
    var NIO: Float = 0.0
    var NOK: Float = 0.0
    var NPR: Float = 0.0
    var NZD: Float = 0.0
    var OMR: Double = 0.0
    var PAB: Float = 0.0
    var PEN: Float = 0.0
    var PGK: Float = 0.0
    var PHP: Float = 0.0
    var PKR: Float = 0.0
    var PLN: Float = 0.0
    var PYG: Float = 0.0
    var QAR: Float = 0.0
    var RON: Float = 0.0
    var RSD: Float = 0.0
    var RUB: Float = 0.0
    var RWF: Float = 0.0
    var SAR: Float = 0.0
    var SBD: Float = 0.0
    var SCR: Float = 0.0
    var SDG: Float = 0.0
    var SEK: Float = 0.0
    var SGD: Float = 0.0
    var SHP: Float = 0.0
    var SLL: Float = 0.0
    var SOS: Float = 0.0
    var SRD: Float = 0.0
    var SSP: Float = 0.0
    var STN: Float = 0.0
    var SYP: Float = 0.0
    var SZL: Float = 0.0
    var THB: Float = 0.0
    var TJS: Float = 0.0
    var TMT: Float = 0.0
    var TND: Float = 0.0
    var TOP: Float = 0.0
    var TRY: Float = 0.0
    var TTD: Float = 0.0
    var TVD: Float = 0.0
    var TWD: Float = 0.0
    var TZS: Float = 0.0
    var UAH: Float = 0.0
    var UGX: Float = 0.0
    var USD: Float = 0.0
    var UYU: Float = 0.0
    var UZS: Float = 0.0
    var VES: Float = 0.0
    var VND: Float = 0.0
    var VUV: Float = 0.0
    var WST: Float = 0.0
    var XAF: Float = 0.0
    var XCD: Float = 0.0
    var XDR: Float = 0.0
    var XOF: Float = 0.0
    var XPF: Float = 0.0
    var YER: Float = 0.0
    var ZAR: Float = 0.0
    var ZMW: Float = 0.0

}
