import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:torch_light/torch_light.dart';
//
import '../widgets.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter FlashLight App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Oxygen",
      ),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  bool isFlashOn = true;
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode
            ? Color.fromARGB(255, 245, 245, 245)
            : Color.fromARGB(255, 24, 24, 24),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            "Flashy",
            style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500),
          ),
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: h / 2.2,
                child: DayNightSwitcher(
                    isDarkModeEnabled: isFlashOn,
                    onStateChanged: (val) {
                      setState(() {
                        isFlashOn = val;
                        isDarkMode = !isDarkMode;
                      });

                      isFlashOn
                          ? _turnOffFlash(context)
                          : _turnOnFlash(context);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _turnOnFlash(BuildContext context) async {
  try {
    await TorchLight.enableTorch();
  } on Exception catch (_) {
    _showErrorMes('Could not enable Flashlight', context);
  }
}

Future<void> _turnOffFlash(BuildContext context) async {
  try {
    await TorchLight.disableTorch();
  } on Exception catch (_) {
    _showErrorMes('Could not enable Flashlight', context);
  }
}

void _showErrorMes(String mes, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mes)));
}
