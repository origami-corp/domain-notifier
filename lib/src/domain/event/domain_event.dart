import 'package:domain_notifier/src/domain/value_object/uuid.dart';

abstract class DomainEvent {
  DomainEvent({this.aggregateId, String eventId, String occuredOn})
      : assert(aggregateId != '') {
    _eventId = eventId.isNotEmpty ? eventId : Uuid.random();
    _occuredOn = occuredOn.isNotEmpty ? occuredOn : DateTime.now().toString();
  }

  final String aggregateId;
  String _eventId;
  String _occuredOn;

  String get eventId => _eventId;
  String get occuredOn => _occuredOn;

  String eventName();
}
