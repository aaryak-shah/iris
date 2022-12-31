import 'dart:io';

import 'package:meta/meta.dart';
import 'package:iris/src/middleware.dart';
import 'package:iris/src/request.dart';
import 'package:iris/src/response.dart';

abstract class _RouteRoot {
  List<Middleware> middleware = [];
  _RouteRoot(this.middleware);
}

class Route<T extends Response> extends _RouteRoot {
  String name;

  @nonVirtual
  Future<void> handleRoute({
    required Request request,
    required List<Middleware> pathMiddleware,
    required Response response,
  }) async {
    bool allMiddlewaresCalled = true;

    for (Middleware mw in pathMiddleware) {
      // TODO: mw(req, res) -> if res is sent then end connection
      // DOUBT: if OK is set true by previous middleware or any one.
      // res.ok = false; // middleware code edits the res.ok to true
      mw.run(request, response);
      if (response.sent) {
        allMiddlewaresCalled = false;
        break;
      }
    }

    // TODO: based on HTTP verb, run handler method
    if (allMiddlewaresCalled) {
      switch (request.method) {
        case "GET":
          {
            get(request, response);
          }
          break;
        case "HEAD":
          {
            head(request, response);
          }
          break;
        case "POST":
          {
            post(request, response);
          }
          break;
        case "PUT":
          {
            put(request, response);
          }
          break;
        case "PATCH":
          {
            patch(request, response);
          }
          break;
        case "DELETE":
          {
            delete(request, response);
          }
          break;
        case "CONNECT":
          {
            connect(request, response);
          }
          break;
        case "OPTIONS":
          {
            options(request, response);
          }
          break;
        case "TRACE":
          {
            trace(request, response);
          }
          break;
        default:
          {
            //statements;
          }
          break; // reduntant ig
      }
    }
  }

  Future<void> _sendNotFoundError(Request req, Response res) async {
    res.setStatus(HttpStatus.notFound);
    await res.send("404: Not Found");
    await res.close();
  }

  Future<void> get(Request req, Response res) async =>
      _sendNotFoundError(req, res);
  Future<void> head(Request req, Response res) async =>
      _sendNotFoundError(req, res);
  Future<void> post(Request req, Response res) async =>
      _sendNotFoundError(req, res);
  Future<void> put(Request req, Response res) async =>
      _sendNotFoundError(req, res);
  Future<void> patch(Request req, Response res) async =>
      _sendNotFoundError(req, res);
  Future<void> delete(Request req, Response res) async =>
      _sendNotFoundError(req, res);
  Future<void> connect(Request req, Response res) async =>
      _sendNotFoundError(req, res);
  Future<void> options(Request req, Response res) async =>
      _sendNotFoundError(req, res);
  Future<void> trace(Request req, Response res) async =>
      _sendNotFoundError(req, res);
  Route(this.name, {List<Middleware> middleware = const []})
      : super(middleware);
}

class RouteTable extends _RouteRoot {
  Map<String, _RouteRoot> routes;
  Map<RegExp, Route> regexRoutes = {};
  Map<RegExp, List<String>> regexParamNames = {};

  // TODO: validate routes so "/" endpoints cannot be set as RouteTables.
  RouteTable({required this.routes, List<Middleware> middleware = const []})
      : super(middleware);

  void constructRegexRoutes(
    String rule,
    List<String> paramsList,
    Map<String, _RouteRoot> routes,
  ) {
    // Capture named route parameters between two forward slashes
    String parameterRegexRule = r"([^\/]+)\/";

    routes.forEach((path, route) {
      // If it is a named route
      if (path.startsWith("/:")) {
        // Add a new RegEx rule for the parameter to the existing rule
        paramsList.add(path.substring(2));
        rule += parameterRegexRule;
      } else {
        // Otherwise if it is a simple string, add it to the existing rule
        rule += path.substring(1) + r"\/";
      }

      // If we are at the end of the route tree (i.e. a terminal route)
      if (route is Route) {
        // Add the created RegEx rule to the maps
        RegExp regExpRule = RegExp(rule + r"?$", caseSensitive: false);
        regexRoutes[regExpRule] = route;
        regexParamNames[regExpRule] = List.from(paramsList);
      } else {
        // If the route is a RouteTable, recursively call the function for the sub-routes
        constructRegexRoutes(rule, paramsList, (route as RouteTable).routes);
      }

      // For backtracking, undo the rules created for the previous route
      if (path.startsWith("/:")) {
        paramsList.removeLast();
        int end = rule.length - parameterRegexRule.length - 1;
        rule = rule.substring(0, end);
      } else {
        int end = rule.length - path.length - 1;
        rule = rule.substring(0, end);
      }
    });
  }

  Route findRoute({
    required String route,
    required Request request,
    required List<Middleware> pathMiddleware,
  }) {
    // By default, when no route is matched, it is a not found route
    Route matchedRoute = Route('');
    // Keep a list of keys used in the route table (used to traverse for collecting middlewares)
    List<String> traversal = route.split('/');
    print(regexParamNames);

    // Iterate over all the created RegEx rules to find a match for the given route
    for (MapEntry regexRoute in regexRoutes.entries) {
      RegExp exp = regexRoute.key;
      Route handler = regexRoute.value;

      RegExpMatch? match = exp.firstMatch(route);
      // If a match is successfully found
      if (match != null) {
        int paramIndex = 1;
        // Index of the string in the traversal list that has been replaced by a parameter name in the previous iteration
        int lastReplaced = -1;

        for (String parameterName in regexParamNames[exp]!) {
          // Parameter value captured in the group
          String param = match.group(paramIndex) ?? "";

          // Make the value accessible through request.params
          request.params[parameterName] = param;

          // Search for the parameter value in the part of the traversal list that is beyond the previous replacement index
          // and then replace it with the parameter name so as to make it possible to search for the route in the table
          int index = traversal
                  .sublist(lastReplaced + 1)
                  .indexWhere((val) => val == param) +
              lastReplaced +
              1;
          traversal[index] = ":$parameterName";
          lastReplaced = index;
          paramIndex++;
        }
        matchedRoute = handler;
        break;
      }
    }

    Map<String, _RouteRoot> children = routes;

    // Use the traversal list to find the path of the route in the route table and collect associated middlewares
    for (String path in traversal) {
      path = '/$path';
      if (children.containsKey(path)) {
        pathMiddleware.addAll(children[path]!.middleware);
        if (children[path]! is! Route) {
          children = (children[path]! as RouteTable).routes;
        }
      }
    }

    print(request.params);
    print(traversal);
    return matchedRoute;
  }
}
