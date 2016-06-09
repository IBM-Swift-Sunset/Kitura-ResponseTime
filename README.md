# Kitura-ResponseTime

Middleware for [Kitura](https://github.com/IBM-Swift/Kitura).

This module tracks the response time for HTTP requests and sends the time back in the response header.

Response time is defined as the elapsed time from when the request is processed by this middleware to the time when the response is sent out in miliseconds.

## Installation

Add this package to your `Package.swift`.

## Use
```
import Kitura
import ResponseTime

let router = Router()
router.all(ResponseTime())
```

## Options
### ResponseTime(precision:, headerName:, includeSuffix:)

**precision**

The number of digits to include after the decimal point, defaults to `3` (ex: `4.143ms`).

**headerName**

The name of the header to set, defaults to `X-Response-Time`.

**includeSuffix**

Whether to include the `ms` suffix, defaults to `true`.
