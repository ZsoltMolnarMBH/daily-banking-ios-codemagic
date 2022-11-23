//
//  PDFKitView.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 08..
//

import Combine
import PDFKit
import BankAPI
import Resolver

enum DocumentSource: Equatable {
    case contract(String)
    case statement(String)
    case url(String)
}

class DocumentLoader: ObservableObject {

    private enum LoadError: Error {
        case malformedData
        case invalidUrl
        case invalidResponseCode
    }

    enum State {
        case idle
        case loading
        case loaded(document: PDFDocument)
        case loadFailed(ResultModel)

        var isLoaded: Bool {
            if case .loaded = self {
                return true
            }
            return false
        }

        var error: ResultModel? {
            if case .loadFailed(let model) = self {
                return model
            }
            return nil
        }
    }

    @LazyInjected(container: .root) private var api: APIProtocol
    @Published var state: State = .idle
    private var cancellable: AnyCancellable?

    var pdfData: Data? {
        if case .loaded(let doc) = state {
            return doc.dataRepresentation()
        }
        return nil
    }

    deinit {
        cancellable?.cancel()
    }

    func load(from source: DocumentSource?) {
        guard let source = source else {
            cancellable?.cancel()
            state = .idle
            return
        }
        cancellable = Just(source)
            .flatMap { [unowned self] source -> AnyPublisher<Data, Error> in
                switch source {
                case .contract(let id):
                    return download(type: .contract, id: id)
                case .statement(let id):
                    return download(type: .statement, id: id)
                case .url(let url):
                    return download(url: url)
                }
            }
            .receive(on: DispatchQueue(label: UUID().uuidString))
            .map { PDFDocument(data: $0) }
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .map { document -> State in
                if let document = document {
                    return .loaded(document: document)
                } else {
                    return .loadFailed(.documentLoadingError { [weak self] in self?.load(from: source) })
                }
            }
            .prepend(.loading)
            .assign(to: \.state, onWeak: self)
    }

    private func download(type: PdfDocumentType, id: String) -> AnyPublisher<Data, Error> {
        api.publisher(for: GetDocumentQuery(type: type, id: id), cachePolicy: .fetchIgnoringCacheCompletely)
            .map { $0.getPdfDocument }
            .tryMap { base64String -> Data in
                if let data = Data(base64Encoded: base64String) {
                    return data
                }
                throw LoadError.malformedData
            }
            .eraseToAnyPublisher()
    }

    private func download(url: String) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: url) else {
            return Fail<Data, Swift.Error>(error: LoadError.invalidUrl).eraseToAnyPublisher()
        }
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .mapError({ $0 as Error })
            .tryMap { (data, response) in
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    return data
                } else {
                    throw LoadError.invalidResponseCode
                }
            }
            .eraseToAnyPublisher()
    }
}
