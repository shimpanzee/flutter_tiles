import 'package:flutter/material.dart';

enum TileVariants {
  none,
  sequential,
  random
}

enum TileFlips {
  none,
  // alternate flip across the horizontal access
  horizontal,
  // alternate flip across the vertical access
  vertical
}

enum TileRotation {
  north(0),
  east(1),
  south(2),
  west(3);

  const TileRotation(this.quarterTurns);
  final int quarterTurns;
}

class TileProducer {
  final TileDefinition tileDefinition;
  final TileVariants variants;
  final List<double>? crops;
  final List<TileRotation>? rotations;
  final List<TileFlips>? flips;
  int sequence = 0;

  TileProducer({required this.tileDefinition, this.crops, this.variants = TileVariants.none, this.rotations, this.flips });

  Widget nextTile() {
    int variant = 1;
    switch (variants) {
      case TileVariants.sequential:
        variant = (sequence % tileDefinition.variantCount) + 1;
        break;
      case TileVariants.random:
        variant = 2;
        break;
      default:
          break;
    }

    double scaleX = 1;
    double scaleY = 1;

    TileFlips flip = TileFlips.none;
    if (flips != null) {
      final flipIndex = sequence % flips!.length;
      flip = flips![flipIndex];
    }
    switch (flip) {
      case TileFlips.vertical:
        scaleY = -1;
        break;
      case TileFlips.horizontal:
        scaleX = -1;
        break;
      default:
        break;
    }

    int quarterTurns = 0;
    if (rotations != null) {
      final rotationIndex = sequence % rotations!.length;
      final tileRotation = rotations![rotationIndex];
      quarterTurns = tileRotation.quarterTurns;
    }

    double crop = 1;
    if (crops != null) {
      final cropIndex = sequence % crops!.length;
      crop = crops![cropIndex];
    }

    final assetPath = tileDefinition.assetPath.replaceAll("\$variant", variant.toString());
    var image = Image.asset(
      assetPath,
      width: tileDefinition.width,
      height: tileDefinition.height,
      fit: BoxFit.fitWidth,
    );

    sequence += 1;

    return Container(
      padding: const EdgeInsets.all(2),
      child: ClipRect(
          child: Align(
              alignment: Alignment.topCenter,
              widthFactor: crop,
              child: RotatedBox(
                  quarterTurns: quarterTurns,
                  child:
                  Transform.scale(
                      scaleX: scaleX,
                      scaleY: scaleY,
                      child: image
                  )
              )
          )
      )
    );
  }
}

class TileSet  {
  TileSet({ required this.tileTypes });

  final Map<String, TileDefinition> tileTypes;

  factory TileSet.fromJson(Map<String, dynamic> data) {
    final tiles = data['tile_types'] as List<dynamic>?;
    final tileList = tiles != null ?
      tiles.map((tileData) => TileDefinition.fromJson(tileData)):
      <TileDefinition>[];

    final tileTypes = { for (var item in tileList) item.id : item };

    return TileSet(tileTypes: tileTypes);

  }

  TileProducer createTileProducer({
    required String id,
    TileVariants variants = TileVariants.none,
    List<double>? crops,
    List<TileRotation>? rotations,
    List<TileFlips>? flips}) {

    TileDefinition definition = tileTypes[id]!;

    return TileProducer(tileDefinition: definition, variants: variants, rotations: rotations, crops: crops, flips: flips);
  }
}

class TileDefinition {
  TileDefinition({ required this.id, required this.assetPath, required this.width, required this.height, this.variantCount = 0});
  final String id;
  final String assetPath;
  final double width;
  final double height;
  final int variantCount;

  factory TileDefinition.fromJson(Map<String, dynamic> data) {
    // note the explicit cast to String
    // this is required if robust lint rules are enabled
    final id = data['id'] as String;
    final assetPath = data['asset_path'] as String;
    final double width = data['width'].toDouble();
    final double height = data['height'].toDouble();
    final variantCount = data['variants'] as int?;
    return TileDefinition(id: id, assetPath: assetPath, height: height, width: width, variantCount: variantCount ?? 0);
  }
}
