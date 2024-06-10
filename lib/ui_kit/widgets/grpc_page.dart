import 'package:flutter/material.dart';
import 'package:flutter_sync/hello_service.dart';
import 'package:flutter_sync/services/helloworld.pb.dart';
import 'package:grpc/grpc.dart';

class GRPCPage extends StatefulWidget {
  const GRPCPage({super.key});

  @override
  State<GRPCPage> createState() => _GRPCPageState();
}

class _GRPCPageState extends State<GRPCPage> {
  ///call sayHello from helloClient service
  var hello = "default";

  Future<void> sayHello() async {
    try {
      HelloRequest helloRequest = HelloRequest();
      helloRequest.name = "Itachi";

      var helloResponse =
          await HelloService.instance.helloClient.sayHello(helloRequest);

      ///do something with your response here
      setState(() {
        hello = helloResponse.message;
      });
    } on GrpcError catch (e) {
      ///handle all grpc errors here
      ///errors such us UNIMPLEMENTED,UNIMPLEMENTED etc...
      print(e);
    } catch (e) {
      ///handle all generic errors here
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            hello,
          ),
          FloatingActionButton(
            onPressed: sayHello,
            tooltip: 'Said Hello',
            child: const Icon(Icons.add),
          ), // This trai
        ],
      ),
    );
  }
}
