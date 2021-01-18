A library for publish and consuming event domains from rabbitmq.

## Usage

A simple usage example for producer:

```dart
import 'package:domain_notifier/domain_notifier.dart' as dn;

// Create a class for your event
class MyEvent extends dn.DomainEvent {
  MyEvent({String aggregateId, String eventId, String occuredOn})
      : super(aggregateId: aggregateId, eventId: eventId, occuredOn: occuredOn);

  @override
  String eventName() {
    return 'course.created'; // Put the name of your event
  }
}

main() {
  final exchangeName = 'microservice';
  final configuration = dn.RabbitMqConfiguration(
      hostname: 'localhost', username: 'guest', password: 'guest');

  final connection = dn.RabbitMqConnection(configuration: configuration);

  final eventRabbit =
      dn.RabbitMqEvent(connection: connection, exchangeName: exchangeName);

  final domainEvent = MyEvent(
      aggregateId: '12312323343',
      eventId: 'as87da86f7asd98aasas',
      occuredOn: DateTime.now().toIso8601String());
  
  eventRabbit.publish([domainEvent]);
}
```

A simple usage example for consumer:

```dart
import 'package:domain_notifier/domain_notifier.dart' as dn;

main() {
  final exchangeName = 'microservice';
  final configuration = dn.RabbitMqConfiguration(
      hostname: 'localhost', username: 'guest', password: 'guest');

  final connection = dn.RabbitMqConnection(configuration: configuration);

  final consumer = dn.RabbitMqEventConsumer(
      connection: connection, exchangeName: exchangeName);

  consumer.consume(
      subscriber: (message) => print(message.toString()),
      queueName: 'queue-example',
      domainEvents: ['course.created']);
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/origami-corp/domain-notifier/issues

## TODO:
- [ ] Add testing
- [ ] Add memory client for testing purposes
