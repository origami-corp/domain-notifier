import 'package:domain_notifier/src/domain/value_object/uuid.dart';

abstract class DomainEvent {
  DomainEvent({this.aggregateId, String eventId, String occuredOn})
      : assert(aggregateId != '') {
    // ignore: prefer_if_null_operators
    _eventId = eventId != null ? eventId : Uuid.random();
    // ignore: prefer_if_null_operators
    _occuredOn = occuredOn != null ? occuredOn : DateTime.now().toString();
  }

  final String aggregateId;
  String _eventId;
  String _occuredOn;

  String get eventId => _eventId;
  String get occuredOn => _occuredOn;

  String eventName();
  Map toPrimitives();
}
