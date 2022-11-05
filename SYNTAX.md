# Syntax Definition

## (Basic) Creating an HTTP Server

```dart
import "package:iris/server.dart";

async void main() {
    const port = 8080;
    try {
        IrisServer server = IrisServer
            .http()
            .start(port);
        print("Server started on port $port");
    } catch(e) {
        print(e);
    }
}
```

## Extensive Example

```dart
// login_route.dart
import "package:iris/types.dart";
import "package:iris/route.dart";
import "package:iris/validation.dart";

class MyPasswordType extends CustomType {
    String passwordStr;
    MyPasswordType(required this.passwordStr);

    @override
    void validator() {
        if (...)
            throw CustomTypeError("...");
    }
}

class RegisterData extends RequestData {
    Email email;
    Name<Names.charset.en> name;
    String bio;
    AlphaNum referalCode;
    MyPasswordType password;

    @override
    void validator() {
        if (...)
            throw CustomTypeError("...");
        else if (...)
            throw CustomTypeError("...");
    }
}

class RegisterResponse extends ResponseData {
    Jwt token;
    Profile user;

    @override
    Json toJson() {
        ...
        return jsonObject;
    }
}

class RegisterRoute extends Route<RegisterData, RegisterResponse> {
    @override
    void postRoute(RegisterData req, RegisterResponse res) {
        // No need to validate req data. happens automatically
        ...
        try {
            ...
            // req.cookies
            // req.body
            // req.params
            // req.query
            // req.headers *
            // req.injected
            // add relevant data to "res" object
        } catch(e) {
            ...
        }
        // res.json(Json(...));
        res
            ..setCookie(Cookie())
            ..status(200)
            ..reply();
        // res.str("...")
        // res.bytes(...)
        // res.protobuf(ProtocolBuffer(...))
        // res.file(File())
    }
}
```

```dart
import "package:iris/middleware.dart";

class RequestLogger extends Middleware<RegisterData> {
    @override
    bool run(RegisterData req, ResponseData res) {
        ...
    }
}
```

```dart
// main.dart
import "package:iris/server.dart";

void main() {
    // HttpConfig config = 
    RouteTable routes = RouteTable(
        routes: {
            "/": IndexRoute(),
            "/register": RegisterRoute(middleware: [RequestLogger()]),
            "/browse": RouteTable(
                routes: {
                    "/": BrowseRoute(),
                    "/product/:id": ProductRoute(),
                }
            ),
            "profile": RouteTable(
                routes: {
                    "/": ProfileRoute(),
                    "/history": PurchaseHistoryRoute(),
                    "/settings": ProfileSettingsRoute(),
                }
            ),
            "*": CustomNotFound(),
        }
    )
    const port = 8080;
    try {
        IrisServer server = IrisServer.httpREST(secure: false)
        server
            ..settings(config)
            ..routes(routes)
            ..useMiddleware(List<Middleware>[...])
            ..start(port);
        print("Server started on port $port");
    } catch(e) {
        print(e);
    }
}
```

# HTTP Headers

## Request Headers

Important:
- Accept
- 

Additional:

## Response Headers