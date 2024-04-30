import 'dart:html';
import 'dart:ui_web';
import 'package:flutter/material.dart';

void registerAdView() {
  final PlatformViewRegistry platformViewRegistry = PlatformViewRegistry();
  // Registers the view factory for embedding the iframe
  platformViewRegistry.registerViewFactory(
      'adViewType',
      (int viewID) => IFrameElement()
        ..src = 'adview.html'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%');
}

Widget adsenseAdsView() {
  return const SizedBox(
    height: 460,
    width: 340,
    child: HtmlElementView(
      viewType: 'adViewType',
    ),
  );
}
