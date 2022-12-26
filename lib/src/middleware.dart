import 'package:iris/src/request.dart';
import 'package:iris/src/response.dart';

import 'request.dart';
import 'response.dart';

typedef Middleware = void Function(Request req, Response res);

void DataPreprocessingMiddleware(Request req, Response res){

}