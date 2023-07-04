import 'package:flutter/material.dart';

import 'package:sehirli/models/event_type.dart';
import 'package:sehirli/widgets/custom_button.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventTypeSelector extends StatefulWidget {
  const EventTypeSelector({super.key});

  @override
  State<EventTypeSelector> createState() => EventTypeSelectorState();
}

class EventTypeSelectorState extends State<EventTypeSelector> {
  EventType? _eventType;
  EventType? get eventType => _eventType;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomButton(
          onPressed: () {
            setState(() {
              _eventType = EventType.crash;
            });
          },
          backgroundColor: eventType == EventType.crash
              ? Colors.grey
              : Colors.white,
          foregroundColor: Colors.black,
          child: const Icon(FontAwesomeIcons.carBurst, color: Colors.black, size: 18)
        ),
        CustomButton(
          onPressed: () {
            setState(() {
              _eventType = EventType.shooting;
            });
          },
          backgroundColor: eventType == EventType.shooting
              ? Colors.grey
              : Colors.white,
          foregroundColor: Colors.black,
          child: const Icon(FontAwesomeIcons.gun, color: Colors.black, size: 18),
        ),
        CustomButton(
          onPressed: () {
            setState(() {
              _eventType = EventType.fire;
            });
          },
          backgroundColor: eventType == EventType.fire
              ? Colors.grey
              : Colors.white,
          foregroundColor: Colors.black,
          child: const Icon(FontAwesomeIcons.fire, color: Colors.black, size: 18),
        ),
        CustomButton(
          onPressed: () {
            setState(() {
              _eventType = EventType.explosion;
            });
          },
          backgroundColor: eventType == EventType.explosion
              ? Colors.grey
              : Colors.white,
          foregroundColor: Colors.black,
          child: const Icon(FontAwesomeIcons.explosion, color: Colors.black, size: 18),
        ),
        CustomButton(
          onPressed: () {
            setState(() {
              _eventType = EventType.murder;
            });
          },
          backgroundColor: eventType == EventType.murder
              ? Colors.grey
              : Colors.white,
          foregroundColor: Colors.black,
          child: const Icon(Icons.person, color: Colors.black, size: 18),
        ),
      ],
    );
  }
}
