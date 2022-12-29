import 'dart:io';

import 'package:iris/consts/content_type.dart';
import 'package:iris/core.dart';
import 'package:iris/utils.dart';

class HomeRoute extends Route {
  HomeRoute(String name, List<Middleware> middleware)
      : super(name, middleware: middleware);

  @override
  Future<void> post(Request req, Response res) async {
    print("Running HomeRoute POST");
    print("${req.body}");
    res.append([1,2,3]);
    sleep(Duration(seconds: 1));
    res.append([75,76]);
    sleep(Duration(seconds: 1));
    res.append([71,72]);
    await res.send("SEND DATA");
    await res.close();
    // super.post(req, res);
  }
}

Future<void> main() async {
  RouteTable routes = RouteTable(
    routes: {
      "/": HomeRoute(
        "/",
        [BodyParser(contentType: ContentType.text_Plain)],
      ),
    },
  );

  IrisServer server = IrisServer(
    port: 5000,
    routes: routes,
  );
  /*await*/ server.start();
  print("Server started on port ${server.port}");
}
