import 'package:flutter_sync/services/helloworld.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class HelloService {
  ///here enter your host without the http part (e.g enter google.com now http://google.com)
  String baseUrl = "example.com";

  HelloService._internal();
  static final HelloService _instance = HelloService._internal();

  factory HelloService() => _instance;

  ///static HelloService instance that we will call when we want to make requests
  static HelloService get instance => _instance;

  ///HelloClient is the  class that was generated for us when we ran the generation command
  ///it represent our Hello service in our proto file.
  ///We will be calling any method from that service using this instance.
  ///We will pass a channel to it to initialize it
  late GreeterClient _helloClient;

  ///this will be used to create a channel once we create an instance of class.
  ///Call HelloService().init() before making any call.
  Future<void> init() async {
    _createChannel();
  }

  ///provide public access to the HelloClient instance
  GreeterClient get helloClient {
    return _helloClient;
  }

  ///here we create a channel and use it to initialize the HelloClient that was generated
  ///
  _createChannel() {
    final channel = ClientChannel(
      'localhost',
      port: 50051,
      options: ChannelOptions(
        credentials: ChannelCredentials.insecure(),
        codecRegistry:
            CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
      ),
    );
    _helloClient = GreeterClient(channel);
  }
}
