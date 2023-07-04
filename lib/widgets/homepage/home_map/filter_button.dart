import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 10, top: 10),
      child: SafeArea(
        top: false,
        child: FloatingActionButton(
          heroTag: "filter",
          backgroundColor: Colors.black,
          child: const Icon(Icons.filter_alt_rounded, color: Colors.white),
          onPressed: () {},
        ),
      ),
    );
  }
}
