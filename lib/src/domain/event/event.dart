import 'package:domain_notifier/src/domain/event/domain_event.dart';

abstract class Event {
  void publish(List<DomainEvent> events) {}
}
