import 'dart:io';

import 'package:iris/core.dart';

class IrisServer {
  late int _port;
  late RouteTable routes;
  late HttpServer server;

  IrisServer({required int port, required this.routes}) {
    _port = port;
  }

  Future<void> start() async {
    try {
      // define server
      server = await HttpServer.bind(InternetAddress.anyIPv4, port);
      routes.constructRegexRoutes('', [], routes.routes);
      // setup listener
      await server.forEach((HttpRequest request) async {
        // calculate path segments
        List<String> segments = List.from(request.uri.pathSegments);
        segments.removeWhere((element) => element == "");

        Request req = Request(request);
        await req.getRaw();
        Response res = Response(request.response);

        // obtain route and middleware
        List<Middleware> pathMiddleware = [];
        Route route = routes.findRoute(
          request: req,
          route: segments.join('/'),
          pathMiddleware: pathMiddleware,
        );

        // execute targets
        await route.handleRoute(
          request: req,
          response: res,
          pathMiddleware: pathMiddleware,
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  int get port => _port;
}
