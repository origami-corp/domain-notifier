import 'package:domain_notifier/domain_notifier.dart' as dn;

class MyEvent extends dn.DomainEvent {
  MyEvent({String aggregateId, String eventId, String occuredOn})
      : super(aggregateId: aggregateId, eventId: eventId, occuredOn: occuredOn);

  @override
  String eventName() {
    return 'course.created';
  }
}

void main() {
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

  final consumer = dn.RabbitMqEventConsumer(
      connection: connection, exchangeName: exchangeName);
  consumer.consume(
      subscriber: exampleConsume,
      queueName: 'queue-example',
      domainEvents: ['course.created']);

  eventRabbit.publish([domainEvent]);
}

void exampleConsume(message) {
  print(message.toString());
}
