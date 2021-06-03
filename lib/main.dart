import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_selector/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme Selector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Theme Selector3'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Color pickerColor = themeColor;
  @override
  void initState() {
    super.initState();
    setTheme();
  }

  Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
  }

  setTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String colorString = prefs.getString('theme') ?? "#ffffff"; //
    setState(() {
      themeColor = hexToColor(colorString);
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
              style: TextStyle(color: themeColor),
            ),
            Text(
              '$_counter',
              style: TextStyle(fontSize: 50, color: themeColor),
            ),
            ElevatedButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Pick a color!'),
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        availableColors: [
                          Color(0xFF23234a),
                          Color(0xFF398860),
                          Color(0xFFF44336),
                          Color(0xFFE91E63),
                          Color(0xFF9C27B0),
                          Color(0xFF673AB7),
                          Color(0xFF3F51B5),
                          Color(0xFF2196F3),
                          Color(0xFF03A9F4),
                          Color(0xFF00BCD4),
                          Color(0xFFFFC107),
                          Color(0xFFFF9800),
                          Color(0xFFFF5722),
                          Color(0xFF795548),
                          Color(0xFF607D8B),
                          Color(0xFFF0909C),
                          Color(0xFF9E9E9E),
                          Color(0xFF000000),
                        ],
                        pickerColor: pickerColor,
                        onColorChanged: (Color color) {
                          pickerColor = color;
                        },
                      ),
                      //
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'Change Theme',
                          style: TextStyle(color: themeColor),
                        ),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String colorString = pickerColor.toString();
                          String valueString =
                              colorString.split('Color(0xff')[1].split(')')[0];
                          await prefs.setString("theme", "#$valueString");
                          setState(() => themeColor = pickerColor);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                "Change Theme",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: themeColor,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColor,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
