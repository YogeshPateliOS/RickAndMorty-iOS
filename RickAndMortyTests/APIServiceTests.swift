import XCTest
@testable import RickAndMorty

final class APIServiceTests: XCTestCase {
    private struct Item: Decodable, Equatable { let id: Int }
    private struct TestEndpoint: ServiceEndPoint {
        let baseUrl = "https://example.com"
        let path = "/items"
    }

    private func makeSUT() -> APIService {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        return APIService(session: URLSession(configuration: configuration))
    }

    func testDecodesSuccessfulResponse() async throws {
        StubURLProtocol.stub = (200, Data(#"{"id":7}"#.utf8))
        let item: Item = try await makeSUT().request(type: TestEndpoint())
        XCTAssertEqual(item, Item(id: 7))
    }

    func testNotFoundStatusThrowsNotFound() async {
        StubURLProtocol.stub = (404, Data())
        await assertThrows(NetworkError.notFound)
    }

    func testServerErrorThrowsStatusCode() async {
        StubURLProtocol.stub = (500, Data())
        await assertThrows(NetworkError.server(statusCode: 500))
    }

    func testInvalidJSONThrowsDecodingError() async {
        StubURLProtocol.stub = (200, Data("not json".utf8))
        do {
            let _: Item = try await makeSUT().request(type: TestEndpoint())
            XCTFail("Expected a decoding error")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }

    private func assertThrows(_ expected: NetworkError, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            let _: Item = try await makeSUT().request(type: TestEndpoint())
            XCTFail("Expected \(expected)", file: file, line: line)
        } catch {
            XCTAssertEqual(error as? NetworkError, expected, file: file, line: line)
        }
    }
}

private final class StubURLProtocol: URLProtocol {
    nonisolated(unsafe) static var stub: (status: Int, data: Data) = (200, Data())

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let response = HTTPURLResponse(url: request.url!, statusCode: Self.stub.status, httpVersion: nil, headerFields: nil)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Self.stub.data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
