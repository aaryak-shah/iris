import 'dart:io';

import 'package:iris/consts/content_type.dart';
import 'package:iris/core.dart';
import 'package:iris/utils.dart';

class IsAuthenticated extends Middleware {
  @override
  Future<void> run(Request req, Response res) async {
    if (req.body['password'] == "asasa") {
      await res.send("HELLO");
      await res.close();
    }
  }
}

class HomeRoute extends Route {
  HomeRoute(String name, {List<Middleware> middleware = const []})
      : super(name, middleware: middleware);

  @override
  Future<void> post(Request req, Response res) async {
    print("Running HomeRoute POST");
    res.setStatus(HttpStatus.ok);
    await res.send("SEND DATA");
    await res.close();
    // super.post(req, res);
  }
}

Future<void> main() async {
  RouteTable routes = RouteTable(middleware: [
    BodyParser(contentType: ContentType.application_Json)
  ], routes: {
    "/user": RouteTable(routes: {
      "/:userid": RouteTable(routes: {
        "/profile": RouteTable(routes: {
          "/:profileid": RouteTable(routes: {
            "/endprofile": HomeRoute(
              "/",
              middleware: [IsAuthenticated()],
            ),
          }),
        })
      }),
    })
  });

  IrisServer server = IrisServer(
    port: 5000,
    routes: routes,
  );
  /*await*/ server.start();
  print("Server started on port ${server.port}");
}
