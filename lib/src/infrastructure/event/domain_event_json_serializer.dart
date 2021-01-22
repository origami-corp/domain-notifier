import 'dart:convert';

import 'package:domain_notifier/src/domain/event/domain_event.dart';

class DomainEventJsonSerializer {
  static String serialize(DomainEvent domainEvent) {
    return json.encode({
      'data': {
        'id': domainEvent.eventId,
        'type': domainEvent.eventName(),
        'occurred_on': domainEvent.occuredOn,
        'attributes': {
          ...domainEvent.toPrimitives(),
          'id': domainEvent.aggregateId
        }
      },
      'meta': []
    });
  }
}
