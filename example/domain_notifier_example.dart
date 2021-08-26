import 'dart:async';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:domain_notifier/domain_notifier.dart' as dn;

class MyEvent extends dn.DomainEvent {
  String name;

  MyEvent(
      {required String aggregateId,
      String? eventId,
      String? occuredOn,
      required this.name})
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
  var controller = StreamController<AmqpMessage>();
  controller.stream.listen((data) {
    print('With stream');
    print(data.payloadAsJson);
    print('With stream end');
    controller.close();
  });
  consumer.consume(
      // subscriber: exampleConsume,
      controller: controller,
      queueName: 'queue-example',
      domainEvents: ['course.created']);

  eventRabbit.publish([domainEvent]);
  eventRabbit.connection.connection.close();
  connection.connection.close();
  return;
}

void exampleConsume(message) {
  // print(message.toString());
}
