import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class OsmCopyright extends StatelessWidget {
  const OsmCopyright({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => launchUrl(
            Uri.parse("https://openstreetmap.org/copyright"),
            mode: LaunchMode.externalApplication
          ),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(5)
            ),
            child: const Text("© OpenStreetMap Contributors", style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ),
      ),
    );
  }
}
