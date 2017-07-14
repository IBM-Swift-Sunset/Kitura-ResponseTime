/**
 * Copyright IBM Corporation 2016, 2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Kitura
import Foundation

/// A Kitura 'RouterMiddleware' that reports the time (in milliseconds) that a request took in
/// one of the HTTP response headers (X-Response-Time by default).
///
/// - Note: In order to get correct numbers it is important to place this middleware as early as
///        possible in the list of handlers and middleware of your application. Any time spent
///        in handlers or middleware that run before this middleware is invoked will not be
///        counted.
public class ResponseTime: RouterMiddleware {
    
    let precision: Int
    let headerName: String
    let includeSuffix: Bool
    
    /// Initialize a `ResponseTime` instance
    ///
    /// - Parameter precision: The precision of the reported response time. Defaults to
    ///                       three digits to the right of the decimal point.
    /// - Parameter headerName: The name of the HTTP response header to use to report the
    ///                        response time. Defaults to "X-Response-Time".
    /// - Parameter includeSuffix: If `true` a suffix of "ms" will be added to the reported
    ///                           response time.
    public init(precision: Int = 3, headerName: String = "X-Response-Time", includeSuffix: Bool = true) {
        self.precision = precision
        self.headerName = headerName
        self.includeSuffix = includeSuffix
    }

    /// Process an incoming request and inject the `ResponseTime` `Kitura.RouterResponse.onEndInvoked`
    /// lifecycle handler.
    ///
    /// - Parameter request: The `RouterRequest` object used to get information
    ///                     about the HTTP request.
    /// - Parameter response: The `RouterResponse` object used to respond to the
    ///                       HTTP request
    /// - Parameter next: The closure to invoke to enable the Router to check for
    ///                  other handlers or middleware to work with this request.
    public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        let startTime = NSDate()
        var previousOnEndInvoked = {}
        previousOnEndInvoked = response.setOnEndInvoked() { [unowned self, unowned response] in
            let timeElapsed = startTime.timeIntervalSinceNow
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = self.precision
            let milisecondOutput = formatter.string(from: NSNumber(value: abs(timeElapsed) * 1000))
            if let milisecondOutput = milisecondOutput {
                let value = self.includeSuffix ? milisecondOutput + "ms" : milisecondOutput
                response.headers[self.headerName] = value
            }
            previousOnEndInvoked()
        }
        next()
    }
}
