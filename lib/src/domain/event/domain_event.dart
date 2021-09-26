import 'package:domain_notifier/src/domain/value_object/uuid.dart';

abstract class DomainEvent {
  DomainEvent({required this.aggregateId, String? eventId, String? occuredOn})
      : assert(aggregateId != '') {
    // ignore: prefer_if_null_operators
    _eventId = eventId != null ? eventId : Uuid.random();
    // ignore: prefer_if_null_operators
    _occuredOn = occuredOn != null ? occuredOn : DateTime.now().toString();
  }

  final String aggregateId;
  late String _eventId;
  late String _occuredOn;

  String get eventId => _eventId;
  String get occuredOn => _occuredOn;

  String eventName({String? name});
  Map toPrimitives();
}
