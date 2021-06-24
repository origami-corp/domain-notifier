import 'package:domain_notifier/src/domain/event/domain_event.dart';

abstract class Event {
  List<Future<dynamic>> publish(List<DomainEvent> events);
}
