enum EventType {
  crash("crash"),
  shooting("shooting"),
  fire("fire"),
  explosion("explosion"),
  murder("murder"),
  other("other");

  final String event;

  const EventType(this.event);
}
