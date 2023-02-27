import 'package:flutter/material.dart';
import 'package:flutter_tiles/views/tile_grid_view.dart';
import 'package:flutter_tiles/view_models/tile_grid.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const TileApp());
}

class TileApp extends StatelessWidget {
  const TileApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: TileGridViewModel())
      ],
      child: MaterialApp(
        title: 'Tile Grid',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const TilePage(),
    )
  );
  }
}

class TilePage extends StatefulWidget {
  const TilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<TilePage> createState() => _TilePageState();
}

class _TilePageState extends State<TilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tiles, Tiles, Tiles"),
      ),
      body: const TileGrid()
    );
  }
}

