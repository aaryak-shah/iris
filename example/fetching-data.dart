import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final server = await createServer();
  print('Server started: ${server.address} port ${server.port}');
  await handleRequests(server);
}

Future<HttpServer> createServer() async {
  final address = InternetAddress.loopbackIPv4;
  const port = 4040;
  return await HttpServer.bind(address, port);
}

Future<void> handleRequests(HttpServer server) async {
  await for (HttpRequest req in server) {


    // print("aa");
    print(req);
    switch (req.method) {
      case 'GET':
        handleGet(req);
        break;
      case 'POST':
        handlePost(req);
        break;
      default:
        handleDefault(req);
    }
  }
}

var myStringStorage = 'Hello from a Dart server';

void handleGet(HttpRequest req) async {

    req.response
    ..write(myStringStorage)
    ..close();

//     req.response.headers.contentType = ContentType.json;
//     //CORS Header, so the anybody can use this
//     req.response.headers.add(
//       'Access-Control-Allow-Origin',
//       '*',
//       preserveHeaderCase: true,
//     );

//     try {
//       final offset =
//           int.parse(req.requestedUri.queryParameters['offset'] ?? '0');
//       final pageSize =
//           int.parse(req.requestedUri.queryParameters['pageSize'] ?? '10');
//       final sortIndex =
//           int.parse(req.requestedUri.queryParameters['sortIndex'] ?? '1');
//       final sortAsc =
//           int.parse(req.requestedUri.queryParameters['sortAsc'] ?? '1') == 1;
// // ... sending data in the for loop

//       // fileContent.sort((a, b) => sortContacts(a, b, sortIndex, sortAsc));
//       req.response.write(
//         jsonEncode(
//            myStringStorage
//         ),
//       );


//        } catch (e) {
//       print('Something went wrong: $e');
//       req.response.statusCode = HttpStatus.internalServerError;
//     }
//     // print(req)
//     await req.response.close();


}

Future<void> handlePost(HttpRequest request) async {
  
  // myStringStorage = await utf8.decoder.bind(request).join();
  // print(myStringStorage);
 
//  print(json.decode(reques))
  String jsonString = await request.cast<List<int>>().transform(utf8.decoder).join();
  var data = json.decode(jsonString);
  print(data);
  
   request.response.write(
        // jsonEncode(
           data
        // ),
      );




    await request.response.close();

  // request.response
  //   ..write('Got it. Thanks.')
  //   ..close();
  // print(request.response);
  // print(request.response.toString());
}

void handleDefault(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.methodNotAllowed
    ..write('Unsupported request: ${request.method}.')
    ..close();
}