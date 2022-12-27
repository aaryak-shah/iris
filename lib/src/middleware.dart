import 'package:iris/src/request.dart';
import 'package:iris/src/response.dart';

abstract class Middleware {
  void run(Request req, Response res);
}
