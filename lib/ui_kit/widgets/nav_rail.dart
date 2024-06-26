import 'package:flutter/material.dart';
import 'package:flutter_sync/ui_kit/widgets/grpc_page.dart';
import 'package:flutter_sync/ui_kit/widgets/mqtt_page.dart';

class NavRail extends StatefulWidget {
  const NavRail({super.key});

  @override
  State<NavRail> createState() => _NavRailDemoState();
}

class _NavRailDemoState extends State<NavRail> with RestorationMixin {
  final RestorableInt _selectedIndex = RestorableInt(0);

  @override
  String get restorationId => 'nav_rail_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedIndex, 'selected_index');
  }

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const destinationFirst = "MQTT";
    const destinationSecond = "gRPC";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Demo'),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex.value,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex.value = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(
                  Icons.router,
                ),
                label: Text(
                  destinationFirst,
                ),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.cloud,
                ),
                label: Text(
                  destinationSecond,
                ),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Flexible(
            flex: 1,
            child:
                _selectedIndex.value == 0 ? const MQTTPage() : const GRPCPage(),
          ),
        ],
      ),
    );
  }
}

// END
