import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sehirli/widgets/homepage/home_map.dart';
import 'package:sehirli/widgets/homepage/home_topbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white
    ));

    return const Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: HomeTopBar(),
          ),
          Divider(color: Colors.grey, thickness: 2, height: 2),
          Expanded(
            child: HomeMap(),
          )
        ],
      ),
    );
  }
}