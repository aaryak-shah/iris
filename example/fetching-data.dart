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

}



Future<void> handlePost(HttpRequest request) async {
  

  String jsonString = await request.cast<List<int>>().transform(utf8.decoder).join();
  
  print(jsonString);
  bool isform = false;
  var formdata = {};

  for(int i = 5 ; i < jsonString.length; i++){
      
      if(jsonString.substring(i-5, i) == "name="){
          isform = true;
          i++;
          int start = i;
          while( i < jsonString.length && !((jsonString[i-1] == '"' && jsonString[i] == '\r') || (jsonString[i-1] == '"' && jsonString[i] ==';')) ){
            i++;
          }
          int end = i-1;
          String key = jsonString.substring(start, end);
          while( i < jsonString.length && !(jsonString[i-1] == '\n' && jsonString[i] == '\r')){
            i++;
          }
          String value = "";

          if( i < jsonString.length ){
            i+=2;
            start = i;
            while(jsonString[i] != '\r'){
              i++;
            }
            end = i;
            value = jsonString.substring(start, end);
            
          }
          formdata[key] = value;
          

      }
  }
  
  if(!isform){
    request.response.write(
          jsonString
      );
  }

  request.response.write(
      formdata
  );

  await request.response.close();


}

void handleDefault(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.methodNotAllowed
    ..write('Unsupported request: ${request.method}.')
    ..close();
}