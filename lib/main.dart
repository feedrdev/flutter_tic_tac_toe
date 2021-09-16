import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: const HomePage(title: 'Tic Tac Toe'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    const size = 80.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TileWidget(key: const Key('1'), size: size, onTap: () {}),
                TileWidget(key: const Key('2'), size: size, onTap: () {}),
                TileWidget(key: const Key('3'), size: size, onTap: () {}),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TileWidget(key: const Key('4'), size: size, onTap: () {}),
                TileWidget(key: const Key('5'), size: size, onTap: () {}),
                TileWidget(key: const Key('6'), size: size, onTap: () {}),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TileWidget(key: const Key('7'), size: size, onTap: () {}),
                TileWidget(key: const Key('8'), size: size, onTap: () {}),
                TileWidget(key: const Key('9'), size: size, onTap: () {}),
              ],
            ),
            SizedBox(height: size),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        tooltip: 'Start Over',
        icon: const Icon(Icons.restart_alt),
        label: Text('Restart'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TileWidget extends StatelessWidget {
  const TileWidget({
    Key? key,
    required this.size,
    required this.onTap,
    this.checked = false,
  }) : super(key: key);

  final double size;
  final Function() onTap;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
