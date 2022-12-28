import 'package:iris/consts/content_type.dart';
import 'package:iris/core.dart';
import 'package:iris/utils.dart';

class HomeRoute extends Route {
  HomeRoute(String name, List<Middleware> middleware)
      : super(name, middleware: middleware);

  @override
  void post(Request req, Response res) {
    print("Running HomeRoute POST");
    print("${req.body}");
    super.post(req, res);
  }
}

Future<void> main() async {
  RouteTable routes = RouteTable(
    routes: {
      "/": HomeRoute(
        "/",
        [BodyParser(contentType: ContentType.application_UrlEncoded)],
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
