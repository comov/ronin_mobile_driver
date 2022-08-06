import 'package:flutter/material.dart';

Widget callsPage() {
  return DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            TabBar(
              tabs: [
                Tab(
                  text: 'Incoming',
                ),
                Tab(
                  text: 'Outgoing',
                ),
                Tab(
                  text: 'Missed',
                ),
              ],
            )
          ],
        ),
      ),
      body: const Icon(
        Icons.call,
        size: 150,
      ),
    ),
  );
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    callsPage(),
    const Icon(
      Icons.camera,
      size: 150,
    ),
    const Icon(
      Icons.chat,
      size: 150,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Demo'),
      ),
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(100, (index) {
          return Center(
            child: Text(
              'Item $index',
              style: Theme.of(context).textTheme.headline5,
            ),
          );
        }),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class ChangedText extends StatefulWidget {
  const ChangedText(key) : super(key: key);

  @override
  State<ChangedText> createState() => _ChangedTextState();
}

class _ChangedTextState extends State<ChangedText> {
  var text = "";

  @override
  Widget build(BuildContext context) {
    return Text("Text from field $text");
  }
}
