/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct MonoBankExchangeRate: Codable {
	let currencyCodeA: Int
	let currencyCodeB: Int
	let date: Int
	let rateBuy: Double
	let rateSell: Double
    let rateCross: Double

    enum CodingKeys: String, CodingKey {
		case currencyCodeA
		case currencyCodeB
		case date
		case rateBuy
		case rateSell
        case rateCross
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		currencyCodeA = try values.decode(Int.self, forKey: .currencyCodeA)
		currencyCodeB = try values.decode(Int.self, forKey: .currencyCodeB)
		date = try values.decode(Int.self, forKey: .date)
        rateBuy = try values.decodeIfPresent(Double.self, forKey: .rateBuy) ?? 0.0
        rateSell = try values.decodeIfPresent(Double.self, forKey: .rateSell) ?? 0.0
        rateCross = try values.decodeIfPresent(Double.self, forKey: .rateCross) ?? 0.0
	}
}
