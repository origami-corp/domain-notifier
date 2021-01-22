import 'package:domain_notifier/domain_notifier.dart' as dn;

class MyEvent extends dn.DomainEvent {
  String name;

  MyEvent({String aggregateId, String eventId, String occuredOn, this.name})
      : super(aggregateId: aggregateId, eventId: eventId, occuredOn: occuredOn);

  @override
  String eventName() {
    return 'course.created';
  }

  @override
  Map toPrimitives() {
    return {'name': name};
  }
}

void main() {
  final exchangeName = 'microservice';
  final configuration = dn.RabbitMqConfiguration(
      hostname: 'localhost', username: 'guest', password: 'guest');

  final connection = dn.RabbitMqConnection(configuration: configuration);

  final eventRabbit =
      dn.RabbitMqEvent(connection: connection, exchangeName: exchangeName);

  final domainEvent = MyEvent(aggregateId: '12312323343', name: 'Event name');

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
