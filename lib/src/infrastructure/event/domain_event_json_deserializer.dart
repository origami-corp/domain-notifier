import 'dart:convert';

import 'package:domain_notifier/domain_notifier.dart';

class DomainEventJsonDeserializer {
  static DomainEvent deserialize(String domainEvent) {
    final eventData = json.decode(domainEvent);
    // ignore: unused_local_variable
    final eventName = eventData['data']['type'];

    return null;
  }
}
