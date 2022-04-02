import 'package:flutter/material.dart';
import 'package:kosmos_client/kdecole-api/background_tasks.dart';
import 'package:kosmos_client/screens/login.dart';

import 'global.dart';
import 'kdecole-api/client.dart';
import 'screens/multiview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Global.readPrefs();
  await Global.initDB();
  registerTasks();
  runApp(const KosmosApp());
}

class PopupMenuItemWithIcon extends PopupMenuItem {
  PopupMenuItemWithIcon(String label, IconData icon, BuildContext context,
      {Key? key})
      : super(
          key: key,
          value: label,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Icon(
                  icon,
                  color: Global.theme!.colorScheme.brightness == Brightness.dark
                      ? Colors.white54
                      : Colors.black54,
                ),
              ),
              Text(label),
            ],
          ),
        );
}

class KosmosApp extends StatefulWidget {
  const KosmosApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return KosmosState();
  }
}

class KosmosState extends State with WidgetsBindingObserver {
  final title = 'Kosmos client';
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  Widget? _mainWidget;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  KosmosState() {
    Global.onLogin = () {
      setState(() {
        _mainWidget = const Main();
      });
    };
    _mainWidget = const Main();
    if (Global.token == null || Global.token == '') {
      _mainWidget = Login(Global.onLogin!);
    } else {
      print("Token:" + Global.token!);
      Global.client = Client(Global.token!);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    Global.theme = ThemeData(
      colorScheme: const ColorScheme.light().copyWith(
        primary: Colors.teal.shade100,
        onPrimary: Colors.black,
        secondary: Colors.deepPurple,
        surface: Colors.white,
        background: const Color.fromARGB(255, 245, 245, 245),
        onTertiary: Colors.black45,
      ),
      useMaterial3: true,
    );
    return MaterialApp(
      scaffoldMessengerKey: _messengerKey,
      navigatorKey: Global.navigatorKey,
      title: title,
      theme: ThemeData(
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.teal.shade100,
          onPrimary: Colors.black,
          secondary: Colors.deepPurple,
          surface: Colors.white,
          background: const Color.fromARGB(255, 245, 245, 245),
          onTertiary: Colors.black45,
        ),
        useMaterial3: true,
      ),
      /* darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark().copyWith(
          onTertiary: Colors.white54,
          primary: Colors.teal.shade900,
        ),
      ), */
      home: _mainWidget,
    );
  }
}
