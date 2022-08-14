import Foundation
struct MonoBankExchangeRate: Codable {
    let date: Int
    let buy: Double
    let sell: Double
    let cross: Double
    let currencyCodeA: Int
    let currencyCodeB: Int

    enum CodingKeys: String, CodingKey {
        case date
        case buy = "rateBuy"
        case sell = "rateSell"
        case cross = "rateCross"
        case currencyCodeA
        case currencyCodeB
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decode(Int.self, forKey: .date)
        buy = try values.decodeIfPresent(Double.self, forKey: .buy) ?? 0.0
        sell = try values.decodeIfPresent(Double.self, forKey: .sell) ?? 0.0
        cross = try values.decodeIfPresent(Double.self, forKey: .cross) ?? 0.0
        currencyCodeA = try values.decode(Int.self, forKey: .currencyCodeA)
        currencyCodeB = try values.decode(Int.self, forKey: .currencyCodeB)
    }
//	let currencyCodeA: Int 🥸
//	let currencyCodeB: Int
//	let date: Int
//	let rateBuy: Double
//	let rateSell: Double
//    let rateCross: Double
//
//    enum CodingKeys: String, CodingKey {
//		case currencyCodeA
//		case currencyCodeB
//		case date
//		case rateBuy
//		case rateSell
//        case rateCross
//	}
//
//	init(from decoder: Decoder) throws { 🥸    
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		currencyCodeA = try values.decode(Int.self, forKey: .currencyCodeA)
//		currencyCodeB = try values.decode(Int.self, forKey: .currencyCodeB)
//		date = try values.decode(Int.self, forKey: .date)
//        rateBuy = try values.decodeIfPresent(Double.self, forKey: .rateBuy) ?? 0.0
//        rateSell = try values.decodeIfPresent(Double.self, forKey: .rateSell) ?? 0.0
//        rateCross = try values.decodeIfPresent(Double.self, forKey: .rateCross) ?? 0.0
//	}
}
