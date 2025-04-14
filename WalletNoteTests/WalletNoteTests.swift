//
//  WalletNoteTests.swift
//  WalletNoteTests
//
//  Created by 高野　泰生 on 2025/02/04.
//

import XCTest
@testable import WalletNote

final class WalletNoteTests: XCTestCase {

    func testAddCash() {
        var walletData = WalletData()
        walletData.addCash(1000)
        XCTAssertEqual(walletData.getCashAmount(1000), 1, "1000円札が1枚追加されるべきです")
    }

    func testRemoveCash() {
        var walletData = WalletData()
        walletData.addCash(1000)
        walletData.removeCash(1000)
        XCTAssertEqual(walletData.getCashAmount(1000), 0, "1000円札が1枚減少するべきです")
    }

    func testPlus() {
        var walletData1 = WalletData()
        var walletData2 = WalletData()
        walletData1.addCash(1000, 2) // 1000円札を2枚追加
        walletData2.addCash(1000, 3) // 1000円札を3枚追加

        let result = walletData1.plus(walletData2)
        XCTAssertEqual(result.getCashAmount(1000), 5, "1000円札が合計5枚になるべきです")
    }

    func testMinus() {
        var walletData1 = WalletData()
        var walletData2 = WalletData()
        walletData1.addCash(1000, 5) // 1000円札を5枚追加
        walletData2.addCash(1000, 3) // 1000円札を3枚追加

        let result = walletData1.minus(walletData2)
        XCTAssertEqual(result.getCashAmount(1000), 2, "1000円札が合計2枚になるべきです")
    }
}
