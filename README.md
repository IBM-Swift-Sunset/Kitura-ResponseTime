# Kitura-ResponseTime
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)
![Apache 2](https://img.shields.io/badge/license-Apache2-blue.svg?style=flat)

Middleware for [Kitura](https://github.com/IBM-Swift/Kitura).

This module tracks the response time for HTTP requests and sends the time back in the response header. Response time is defined as the elapsed time from when the request is processed by this middleware to the time when the response is sent out in miliseconds.

## Installation

Add this repo to your package dependencies in your `Package.swift`.

## Usage
```
import Kitura
import ResponseTime

let router = Router()
router.all(middleware: ResponseTime())
```

**Note:** In order to get correct numbers it is important to place this middleware as early as
possible in the list of handlers and middleware of your application. Any time spent
in handlers or middleware that run before this middleware is invoked will not be
counted.

## Options

### `ResponseTime(precision:, headerName:, includeSuffix:)`

**precision**

The number of digits to include after the decimal point. Defaults to `3` (ex: `4.143ms`).

**headerName**

The name of the header to set. Defaults to `X-Response-Time`.

**includeSuffix**

Whether to include the `ms` suffix. Defaults to `true`.

## License
Apache 2.0
