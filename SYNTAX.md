# Syntax Definition

## Creating an HTTP Server

```dart
import "package:trident/server.dart";

async void main() {
    const port = 8080;
    try {
        TridentServer server = TridentServer
            .http()
            .start(port);
        print("Server started on port $port");
    } catch(e) {
        print(e);
    }
}
```

## Setting Routes

```dart
// login_route.dart
import "package:trident/types.dart";
import "package:trident/route.dart";
import "package:trident/validation.dart";

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
    void customValidator() {
        if (...)
            throw CustomTypeError("...");
        else if (...)
            throw CustomTypeError("...");
    }
}

class RegisterRoute extends Route<RegisterData> {
    @override
    void post(RegisterData req, Response res) {
        // No need to validate req data. happens automatically
        ...
        try {
            ...
        } catch(e) {
            ...
        }
        res.json();
    }
}
```

```dart
// main.dart
import "package:trident/server.dart";

void main() {
    // HttpConfig config = 
    RouteTable routes = RouteTable(
        routes: {
            "/": IndexRoute(),
            "/register": RegisterRoute(),
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
        TridentServer server = TridentServer.http(secure: false)
        server.settings(config)
            ..routes(routes)
            ..useMiddleware(List<Middleware>[...])
            ..start(port);
        print("Server started on port $port");
    } catch(e) {
        print(e);
    }
}
```