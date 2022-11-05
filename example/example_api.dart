import "package:iris/iris.dart";

Future<void> main() async {
  RouteTable routes = RouteTable(
    routes: {
      "/": Route("/"),
      "register": Route("register"),
      "browse": RouteTable(routes: {
        "/": Route("/browse/"),
        "product/:id": Route("/browse/product/???"),
      }),
      "profile": RouteTable(routes: {
        "/": Route("/profile/"),
        "history": Route("/profile/history"),
        "settings": Route("/profile/settings"),
      }),
      // "*": CustomNotFound(),
    },
  );

  IrisServer server = IrisServer(
    port: 5000,
    routes: routes,
  );
  /*await*/ server.start();
  print("Server started on port ${server.port}");
}
