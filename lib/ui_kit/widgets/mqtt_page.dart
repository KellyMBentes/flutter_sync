import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTPage extends StatefulWidget {
  const MQTTPage({super.key});

  @override
  State<MQTTPage> createState() => _MQTTPageState();
}

class _MQTTPageState extends State<MQTTPage> {
  final _serverController = TextEditingController(text: 'broker.emqx.io');
  final _clientIDController = TextEditingController(text: 'mqttx_d2f8fa58');
  final _portController = TextEditingController(text: '1883');
  final _usernameController = TextEditingController(text: 'username1234');
  final _passwordController = TextEditingController(text: 'abcd1234');
  final _topicController = TextEditingController();
  var _isConnected = false;
  String _selectedTopic = '';
  Map<String, List<String>> topicsAndMessages = {};
  late MqttServerClient client;

  @override
  void initState() {
    super.initState();
  }

  Future<MqttClient> connect() async {
    client = MqttServerClient.withPort(_serverController.text,
        _clientIDController.text, int.parse(_portController.text));
    client.logging(on: true);
    client.keepAlivePeriod = 60;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;

    final connMess = MqttConnectMessage()
        .authenticateAs(_usernameController.text, _passwordController.text)
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMess;
    try {
      print('Connecting');
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }
    print("connected");

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMessage = c![0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

      final topic = c[0].topic;
      setState(() {
        topicsAndMessages[topic]?.add(payload.toString());
        var listOfAlls = topicsAndMessages.keys
            .where((element) => element.characters.last == '#');

        for (int i = 0; i < listOfAlls.length; i++) {
          var currentTopic = listOfAlls.elementAt(i);
          var name = currentTopic.substring(0, currentTopic.length - 2);

          if (topic.startsWith(name)) {
            topicsAndMessages[currentTopic]?.add(payload.toString());
          }
        }
      });
    });

    return client;
  }

// Connected callback
  void onConnected() {
    setState(() {
      _isConnected = true;
    });
  }

// Disconnected callback
  void onDisconnected() {
    setState(() {
      _isConnected = false;
    });
  }

// Subscribed callback
  void onSubscribed(String topic) {
    setState(() {
      topicsAndMessages[topic] = [];
      _selectedTopic = topic;
    });
  }

// Subscribed failed callback
  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

// Unsubscribed callback
  void onUnsubscribed(String? topic) {
    print('Unsubscribed topic: $topic');
  }

// Ping callback
  void pong() {
    print('Ping response client callback invoked');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: GridWidget(children: [
            TextFormField(
              controller: _serverController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Server",
              ),
              maxLines: 1,
            ),
            TextFormField(
              controller: _clientIDController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Client ID",
              ),
              maxLines: 1,
            ),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Username",
              ),
              maxLines: 1,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
              maxLines: 1,
            ),
            TextFormField(
              controller: _portController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Port",
              ),
              maxLines: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _isConnected
                      ? null
                      : () {
                          connect();
                        },
                  child: const Text('Connect'),
                ),
                OutlinedButton(
                  onPressed: !_isConnected
                      ? null
                      : () {
                          client.disconnect();
                        },
                  child: const Text('Disonnect'),
                ),
              ],
            )
          ]),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: Opacity(
            opacity: _isConnected ? 1.0 : 0.5,
            child: IgnorePointer(
              ignoring: !_isConnected,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 400,
                            child: TextFormField(
                              controller: _topicController,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Topic",
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        var topic = _topicController.text;
                                        if (!topicsAndMessages
                                            .containsKey(topic)) {
                                          client.subscribe(
                                              topic, MqttQos.atLeastOnce);
                                        }
                                      },
                                      icon: const Icon(Icons.check_circle))),
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: topicsAndMessages.keys.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedTopic = topicsAndMessages.keys
                                            .elementAt(index);
                                      });
                                    },
                                    child: Text(
                                      topicsAndMessages.keys.elementAt(index),
                                      style: TextStyle(
                                        fontWeight: topicsAndMessages.keys
                                                    .elementAt(index) ==
                                                _selectedTopic
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 1.0,
                    height: double.infinity,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: topicsAndMessages[_selectedTopic]?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(topicsAndMessages[_selectedTopic]
                                    ?[index] ??
                                ''),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GridWidget extends StatelessWidget {
  final List<Widget> children;

  const GridWidget({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          mainAxisExtent: 40,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      );
    });
  }
}

// END
