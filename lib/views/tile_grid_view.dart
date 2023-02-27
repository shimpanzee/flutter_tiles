import 'package:flutter/material.dart';
import 'package:flutter_tiles/view_models/tile_grid.dart';
import 'package:provider/provider.dart';

class TileGrid extends StatefulWidget {
  const TileGrid({super.key});

  @override
  State<TileGrid> createState() => _TileGridState();
}

class _TileGridState extends State<TileGrid> {
  @override
  Widget build(BuildContext context) {
    Provider.of<TileGridViewModel>(context).fetchTileSet();

    return ListView(
      children: [
        Container (
          // width: 1000,
          height: 50,
          // decoration: BoxDecoration(
          //   shape: BoxShape.circle
          // ),
          child: Row(
              children: [
                DropdownButton<String>(
                  value: Provider.of<TileGridViewModel>(context).dropDownValue1,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      Provider
                          .of<TileGridViewModel>(context, listen: false)
                          .dropDownValue1 = value!;
                    });
                  },
                  items: Provider.of<TileGridViewModel>(context).dropDownEntries.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: Provider.of<TileGridViewModel>(context).dropDownValue2,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    Provider.of<TileGridViewModel>(context, listen: false).dropDownValue2 = value!;
                  },
                  items: Provider.of<TileGridViewModel>(context).dropDownEntries.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
            ]
          )
        ),
        Container(
          height: 1000,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: Provider.of<TileGridViewModel>(context).gridRows.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 150,
                child: ListView(scrollDirection: Axis.horizontal, children: Provider.of<TileGridViewModel>(context).gridRows[index])
              );
            },
          )
          // child: FutureBuilder<TileSet>(
          //   future: tileSet,
          //   builder: (BuildContext context, AsyncSnapshot<TileSet> snapshot) {
          //     if (snapshot.hasData) {
          //       final tileSet = snapshot.data as TileSet;
          //       return buildLayout(tileSet);
          //     } else {
          //       return SizedBox(
          //         width: MediaQuery.of(context).size.width,
          //         height: 150,
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //  }
          //  )
        )
      ]
    );
  }

  // Widget buildLayout(TileSet tileSet) {
  //
  //   return ListView(
  //       children: [
  //         Container(
  //         height: 150,
  //           child: ListView(scrollDirection: Axis.horizontal, children: [] /* offsetBlendedRowBuilder(true)*/),
  //   )
  //         // ListView(scrollDirection: Axis.horizontal, children: offsetBlendedRowBuilder(false)),
  //         // ListView(scrollDirection: Axis.horizontal, children: offsetBlendedRowBuilder(true)),
  //         // ListView(scrollDirection: Axis.horizontal, children: offsetBlendedRowBuilder(false)),
  //         // Row(children: blendedRowBuilder(false)),
  //         // Row(children: blendedRowBuilder(true)),
  //         // Row(children: blendedRowBuilder(false)),
  //       ]
  //   );
  // }
}
