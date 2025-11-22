import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Returns a generated PNG image in [ByteData] format with the requested size.
Future<ByteData> createCustomMarkerIconImage({required Size size, required String pngAssetPath}) async {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(recorder);
  final _MarkerPainter painter = _MarkerPainter(pngAssetPath);

  await painter.paint(canvas, size);

  final ui.Image image = await recorder.endRecording().toImage(size.width.floor(), size.height.floor());

  final ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return bytes!;
}

class _MarkerPainter extends CustomPainter {
  final String pngAssetPath;

  _MarkerPainter(this.pngAssetPath);

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    final Offset center = Offset(size.width / 2, size.height / 2);

    /// Load and draw PNG at the center
    final ui.Image pngImage = await _loadPng(pngAssetPath);
    final Rect dstRect = Rect.fromCenter(center: center, width: 40, height: 40);

    /// Draw PNG
    canvas.drawImageRect(pngImage, Rect.fromLTWH(0, 0, pngImage.width.toDouble(), pngImage.height.toDouble()), dstRect, Paint());
  }

  @override
  bool shouldRepaint(_MarkerPainter oldDelegate) => false;

  /// Helper function to load a PNG image as `ui.Image`
  Future<ui.Image> _loadPng(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }
}
