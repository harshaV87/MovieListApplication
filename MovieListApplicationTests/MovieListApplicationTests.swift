//
//  MovieListApplicationTests.swift
//  MovieListApplicationTests
//
//  Created by Venkata harsha Balla on 4/15/21.
//

import XCTest
@testable import MovieListApplication

class MovieListApplicationTests: XCTestCase {

    var sut : DataAPI!
    
    var mockSession: MockURLSession!

    override func setUp() {
        
        sut = DataAPI()
    }

    override func tearDown() {
        
          sut = nil
        mockSession = nil
        
        super.tearDown()
        
    }

    // Testing the actual URL Client
    
    func test_checkDataCallStatusCode_rightURLCurrentMovies_shouldBeEqual200() {
        
        let expectationIn = expectation(description: "201 Status expected")
        var codeOut: Int?
        
        sut.getDataDetail(url: Properties.NowPlayingURL, typeO: CurrentMovies.self) { (_, code) in
            
            codeOut = code
            
            expectationIn.fulfill()
            
        }
        
        waitForExpectations(timeout: 7, handler: nil)
        
        XCTAssertEqual(codeOut, 200, "the code is \(codeOut ?? 0)")
        
    }

    func test_checkDataCallStatusCode_rightURLCurrentMovies_shouldFailInvertedExpectation() {
      
        // inverting the expectation to see if we get nil when expectation i failed
        
        let expectationIn = expectation(description: "Nil status expected ")
    
        expectationIn.isInverted = true
        
        var codeOut: Int?
        
        sut.getDataDetail(url: Properties.NowPlayingURL, typeO: CurrentMovies.self) { (_, code) in
            
            codeOut = code
            
            expectationIn.fulfill()
            
        }
        
        waitForExpectations(timeout: 0, handler: nil)
        
        XCTAssertNil(codeOut, "the code is nil")
    }
    
    func test_checkDataCallStatusCode_wrongURLCurrentMovies_shouldBeEqual401() {
      
        let expectationIn = expectation(description: "401 code expected")
    
        var codeOut: Int?
        
        // removed a string element from the end
        let ModifiedUrl = "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=undefined&api_key=55957fcf3ba81b137f8fc01ac5a31fb"
        
        sut.getDataDetail(url: ModifiedUrl, typeO: CurrentMovies.self) { (_, code) in
            
            codeOut = code
            
            expectationIn.fulfill()
            
        }
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(codeOut, 401, "the code is \(codeOut ?? 0)")

    }
    
    func test_checkDataCallActualData_wrongURLCurrentMovies_FailureshouldBeNotNil() {

        let expectationIn = expectation(description: "codeExpect")
    
        var result : Result<CurrentMovies, Error>?
        
        // removed a string element from the end
        let ModifiedUrl = "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=undefined&api_key=55957fcf3ba81b137f8fc01ac5a31fb"
        
        sut.getDataDetail(url: ModifiedUrl, typeO: CurrentMovies.self) { ( resultOut, _) in
            
         result = resultOut
            
        expectationIn.fulfill()
            
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        switch result {
        
        case .failure(let error):

            let error = error.localizedDescription

            // for the purpose of simplicity error is printed if the parsing fails
            print(error)
            
            XCTAssertNotNil(error)
            
        case .none:
            
            print("nothing exist")
            
        case .some(.success(_)):
            
            print("success")
        }
        
    }
    
    func test_checkDataCallActualData_rightURLCurrentMovies_ResultshouldBeNotNil() {
      
        let expectationIn = expectation(description: "codeExpectRight")
    
        var result : Result<CurrentMovies, Error>?
        
        sut.getDataDetail(url: Properties.NowPlayingURL, typeO: CurrentMovies.self) { ( resultOut, _) in
            
         result = resultOut
            
            expectationIn.fulfill()
            
        }
        
        waitForExpectations(timeout: 7, handler: nil)
        
        switch result {
        

        case .failure(let error):

            let error = error.localizedDescription

            XCTAssertNil(error)
            
            
        case .none:
            
            print("nothing exist")
            
        case .success(let post):

            XCTAssertNotNil(post)
        }
        
    }
    
    
    
    // Functions for mocking
    
    private func loadJsonData(file: String) -> Data? {
        //1
        if let jsonFilePath = Bundle(for: type(of:  self)).path(forResource: file, ofType: ".json") {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)
            //2
            if let jsonData = try? Data(contentsOf: jsonFileURL) {
                return jsonData
            }
        }
        //3
        return nil
    }
    
    private func createMockSession(fromJsonFile file: String,
                            andStatusCode code: Int,
                            andError error: Error?) -> MockURLSession? {

       let data = loadJsonData(file: file)
       let response = HTTPURLResponse(url: URL(string: "TestUrl")!, statusCode: code, httpVersion: nil, headerFields: nil)
    
        return MockURLSession(completionHandler: (data, response, error))
    }
    
    
    
    // network mock tests
    
    func test_NetworkClient_MockData_successResult() {
        mockSession = createMockSession(fromJsonFile: "data",
    andStatusCode: 200, andError: nil)
      
        sut = DataAPI(withSession: mockSession)
        sut.getDataDetail(url: "TestUrl", typeO: CurrentMovies.self) { (resultOut, statusCode) in

            switch resultOut {
            
            case .failure(let error):

                let error = error.localizedDescription

                XCTAssertNil(error)

            case .success(let post):

                let exp1 = post.results[1].originalTitle
                
                let notEqualExp2 = post.results[2].originalTitle
                
                let resultCount = post.results.count

                XCTAssertEqual(exp1, "Raya and the Last Dragon", "the actual title of the second movie title is \(exp1)")
                
                XCTAssertNotEqual(exp1, notEqualExp2, "The third movie title is not equal to the second movie title. but actual title is \(notEqualExp2)")
                
                XCTAssertEqual(resultCount, 20, "The actual result count is 20 and the count from the call is \(resultCount)")
                
            }

        }
        
    }
    
    

    
    func test_CheckingMovieDetail_MovieDetails_ShouldRetrieveCorrectData() {
        
        
        let movieIDPassedOn = 791373
        
        let movieDetailUrl = Properties.gettingMovieDetails(movieID: movieIDPassedOn)
        
        let expectationIn = expectation(description: "codeExpectRight")
    
        var result : Result<MovieDetails, Error>?
        
        var statusCodeOut : Int?
        
        sut.getDataDetail(url: movieDetailUrl, typeO: MovieDetails.self) { ( resultOut, statuscode) in
            
         result = resultOut
            
            statusCodeOut = statuscode
            
            expectationIn.fulfill()
            
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNotEqual(statusCodeOut, 401)
        
        switch result {
        

        case .failure(let error):

            let error = error.localizedDescription

            XCTAssertNil(error)
                    
        case .none:
            
            print("nothing exist")
            
        case .success(let post):

            XCTAssertNotNil(post)
            
            let exp1 = post.id
            
            XCTAssertEqual(movieIDPassedOn, exp1, "The id must be equal")
            
        }
        
    }
}
