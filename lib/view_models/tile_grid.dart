import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import '../models/tile_set.dart';

class TileGridViewModel with ChangeNotifier {
  List<String> _dropDownEntries = [];
  String? _dropDownValue1;
  String? _dropDownValue2;
  TileSet? _tileSet;
  List<List<Widget>> _gridRows = [];

  List<List<Widget> Function()> _builders = [];

  TileSet? get tileSet => _tileSet;
  String? get dropDownValue1 => _dropDownValue1;
  String? get dropDownValue2 => _dropDownValue2;
  List<List<Widget>> get gridRows => _gridRows;

  set dropDownValue1(String? value) {
    _dropDownValue1 = value;
    _updateGridRows();
    notifyListeners();
  }

  set dropDownValue2(String? value) {
    _dropDownValue2 = value;
    _updateGridRows();
    notifyListeners();
  }
  List<String> get dropDownEntries {
    return _dropDownEntries;
  }

  _updateGridRows() {
    if (_dropDownValue1 == null && _dropDownValue2 == null) {
      return;
    }

    List<Widget> Function()? builder1;
    List<Widget> Function()? builder2;

    if (_dropDownValue1 != null) {
      final index = _dropDownEntries.indexOf(_dropDownValue1!);
      builder1 = _builders[index];
    }

    if (_dropDownValue2 != null) {
      final index = _dropDownEntries.indexOf(_dropDownValue2!);
      builder2 = _builders[index];
    }

    const rows = 6;

    if (builder1 == null) {
      final builder = builder2!;
      _gridRows = [for (int i = 0; i < rows; ++i) builder()];
    } else if (builder2 == null) {
      final builder = builder1;
      _gridRows = [for (int i = 0; i < rows; ++i) builder()];
    } else {
      _gridRows = [for (int i = 0; i < rows; ++i) (i % 2 == 0) ? builder1() : builder2()];
    }
  }

  _configureDropDowns() {
    TileProducer cosmicSquareProducer = _tileSet!.createTileProducer(
        id: "cosmic_square",
        variants: TileVariants.sequential,
        flips: [TileFlips.none, TileFlips.vertical]
      // rotations: [TileRotation.north, TileRotation.east, TileRotation.south, TileRotation.west, ]
    );
    TileProducer offsetCosmicSquareProducer = _tileSet!.createTileProducer(
      id: "cosmic_square",
      variants: TileVariants.sequential,
      crops: [.50],
      // flips: [TileFlips.none, TileFlips.vertical]
      // rotations: [TileRotation.north, TileRotation.east, TileRotation.south, TileRotation.west, ]
    );
    TileProducer potterySquareProducer = _tileSet!.createTileProducer(
      id: "pottery_square",
      variants: TileVariants.sequential,
    );
    TileProducer offsetPotterySquareProducer = _tileSet!.createTileProducer(
      id: "pottery_square",
      crops: [.50],
      variants: TileVariants.sequential,
    );
    TileProducer potteryRectProducer = _tileSet!.createTileProducer(
        id: "pottery_rect",
        variants: TileVariants.sequential,
        rotations: [TileRotation.east]
    );

    const cols = 7;
    cosmicRowBuilder() => [
      // potteryRectProducer.nextTile(),
      for (int i = 0; i < cols; ++i) cosmicSquareProducer.nextTile()
    ];
    offsetCosmicRowBuilder() => [
      offsetCosmicSquareProducer.nextTile(),
      for (int i = 0; i < cols; ++i) cosmicSquareProducer.nextTile()
    ];
    potteryRowBuilder() => [
      for (int i = 0; i < cols; ++i) potterySquareProducer.nextTile()
    ];
    potteryRectRowBuilder() => [
      for (int i = 0; i < cols; ++i) potteryRectProducer.nextTile()
    ];
    blendedRowBuilder(bool evens) => [
      for (int i = 0; i < cols; ++i)
        (i % 2 == 0) ^ evens ?
        cosmicSquareProducer.nextTile() :
        potterySquareProducer.nextTile()
    ];
    offsetBlendedRowBuilder(bool offset) => offset ?
      [offsetPotterySquareProducer.nextTile()] + blendedRowBuilder(!offset) :
      blendedRowBuilder(!offset) + [offsetPotterySquareProducer.nextTile()];

    _dropDownEntries = [
      "Cosmic Square (vertical flips)",
      "Pottery Square",
      "Offset Cosmic Square (vertical flips)",
      "Mixed Square (pottery first)",
      "Mixed Square (cosmic first)",
      "Offset Mixed Square (pottery cropped)",
      "Offset Mixed Square",
    ];
    _builders = [
      cosmicRowBuilder,
      potteryRowBuilder,
      offsetCosmicRowBuilder,
      () => blendedRowBuilder(true),
      () => blendedRowBuilder(false),
      () => offsetBlendedRowBuilder(true),
      () => offsetBlendedRowBuilder(false)
    ];
    // _dropDownValue = "foo";

    notifyListeners();
  }

  Future<TileSet> fetchTileSet() async {
    if (_tileSet != null) {
      return _tileSet!;
    }

    String data = await rootBundle.loadString("assets/config/tiles.json");

    var map = jsonDecode(data);
    _tileSet = TileSet.fromJson(map);

    _configureDropDowns();

    return _tileSet!;
  }


}