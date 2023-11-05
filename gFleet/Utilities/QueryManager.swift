//
//  QueryManager.swift
//  gFleet
//
//  Created by Eric Rodriguez on 9/25/23.
//

import Foundation
import Combine

class QueryManager {
    static func osQuery(sql: String) -> AnyPublisher<String, Error> {
        return Future { promise in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/local/bin/osqueryi")
            process.arguments = ["--json", sql]

            let outputPipe = Pipe()
            process.standardOutput = outputPipe

            do {
                try process.run()
                process.waitUntilExit()

                let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
                let outputString = String(data: outputData, encoding: .utf8) ?? ""

                promise(.success(outputString))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    static func osQuerySQL(sql: String, completion: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.global().async {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/local/bin/osqueryi")
            process.arguments = ["--json", sql]

            let outputPipe = Pipe()
            process.standardOutput = outputPipe

            do {
                try process.run()
                process.waitUntilExit()

                let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
                let outputString = String(data: outputData, encoding: .utf8) ?? ""

                completion(.success(outputString))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
