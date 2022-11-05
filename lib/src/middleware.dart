import 'package:iris/src/request.dart';
import 'package:iris/src/response.dart';

typedef Middleware = void Function(Request req, Response res);
