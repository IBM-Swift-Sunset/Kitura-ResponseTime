/**
 * Copyright IBM Corporation 2016
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

class ResponseTime: RouterMiddleware {
    
    let startTime = NSDate()
    
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
        let previousOnResponseEnd = response.onResponseEnd ?? nil
        response.onResponseEnd = { [unowned self, unowned response] in
            let timeElapsed = self.startTime.timeIntervalSinceNow
            let milisecondsElapsed = Int(abs(timeElapsed * 1000))
            response.headers["X-Response-Time"] = String(milisecondsElapsed)
            if let previousOnResponseEnd = previousOnResponseEnd {
                previousOnResponseEnd()
            }
        }
        next()
    }
}