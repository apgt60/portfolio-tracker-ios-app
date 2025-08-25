import XCTest
@testable import Stock_Tracker

final class NetworkManagerTests: XCTestCase {

    var session: URLSessionMock!
    var sut: NetworkManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        session = URLSessionMock()
        sut = NetworkManager(session: session)
    }

    override func tearDownWithError() throws {
        session = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testRegisterUser_whenSuccessful_shouldReturnUser() throws {
        let expectation = XCTestExpectation(description: "Register user success")
        let response = RegisterUserResponse(email: "test@test.com", name: "Test User", success: true)
        let data = try JSONEncoder().encode(response)

        session.data = data
        session.response = HTTPURLResponse(url: URL(string: "http://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        sut.registerUser(email: "test@test.com", password: "password", firstName: "Test", lastName: "User") { (user, error) in
            XCTAssertNotNil(user)
            XCTAssertNil(error)
            XCTAssertEqual(user?.email, "test@test.com")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testRegisterUser_whenEmailTaken_shouldReturnEmailTakenError() throws {
        let expectation = XCTestExpectation(description: "Register user with taken email")
        let fieldError = FieldError(field: "username", error: "Email already in use")
        let response = GenericErrorResponse(errors: [fieldError])
        let data = try JSONEncoder().encode(response)

        session.data = data
        session.response = HTTPURLResponse(url: URL(string: "http://test.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)

        sut.registerUser(email: "test@test.com", password: "password", firstName: "Test", lastName: "User") { (user, error) in
            XCTAssertNil(user)
            XCTAssertNotNil(error)
            XCTAssertEqual(error, .emailTaken)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testGetUser_whenSuccessful_shouldReturnLoginResponse() throws {
        let expectation = XCTestExpectation(description: "Login success")
        let user = LocalUser(guid: "guid", email: "test@test.com", firstname: "Test", lastname: "User")
        let response = LoginResponse(token: "token", user: user)
        let data = try JSONEncoder().encode(response)

        session.data = data
        session.response = HTTPURLResponse(url: URL(string: "http://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        sut.getUser(email: "test@test.com", password: "password") { (loginResponse, error) in
            XCTAssertNotNil(loginResponse)
            XCTAssertNil(error)
            XCTAssertEqual(loginResponse?.token, "token")
            XCTAssertEqual(loginResponse?.user.email, "test@test.com")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testGetUser_whenInvalidCredentials_shouldReturnInvalidCredentialsError() throws {
        let expectation = XCTestExpectation(description: "Login with invalid credentials")
        let fieldError = FieldError(field: "username", error: "Invalid credentials")
        let response = GenericErrorResponse(errors: [fieldError])
        let data = try JSONEncoder().encode(response)

        session.data = data
        session.response = HTTPURLResponse(url: URL(string: "http://test.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)

        sut.getUser(email: "test@test.com", password: "password") { (loginResponse, error) in
            XCTAssertNil(loginResponse)
            XCTAssertNotNil(error)
            XCTAssertEqual(error, .invalidCredentials)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testGetStockWatches_whenSuccessful_shouldReturnStockWatches() throws {
        let expectation = XCTestExpectation(description: "Get stock watches success")
        let stockWatch = StockWatch(ticker: "AAPL", logo: "logo", altLogo: "altLogo", name: "Apple", count: 10, cost: "200", id: 1, guid: "guid", quote: 210, gainLoss: "10", totalAmount: "2100", totalCost: "2000", totalGainLoss: "100")
        let response = StockWatchResponse(success: true, watches: [stockWatch])
        let data = try JSONEncoder().encode(response)

        session.data = data
        session.response = HTTPURLResponse(url: URL(string: "http://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        sut.getStockWatches(authToken: "token") { (watches, error) in
            XCTAssertNotNil(watches)
            XCTAssertNil(error)
            XCTAssertEqual(watches?.count, 1)
            XCTAssertEqual(watches?.first?.ticker, "AAPL")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testAddStockWatch_whenInvalidTicker_shouldReturnInvalidTickerError() throws {
        let expectation = XCTestExpectation(description: "Add stock watch with invalid ticker")
        let response = AddStockErrorResponse(ticker: "INVALID", error: "invalid ticker symbol", success: false)
        let data = try JSONEncoder().encode(response)

        session.data = data
        session.response = HTTPURLResponse(url: URL(string: "http://test.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)

        sut.addStockWatch(authToken: "token", count: 1, ticker: "INVALID", cost: 1) { (addStockResponse, error) in
            XCTAssertNil(addStockResponse)
            XCTAssertNotNil(error)
            XCTAssertEqual(error, .invalidTicker)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
