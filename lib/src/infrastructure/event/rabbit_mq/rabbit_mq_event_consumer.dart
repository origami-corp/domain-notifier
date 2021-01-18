import 'package:dart_amqp/dart_amqp.dart';

import './rabbit_mq_connection.dart';

class RabbitMqEventConsumer {
  RabbitMqEventConsumer({this.connection, this.exchangeName});

  RabbitMqConnection connection;
  String exchangeName;

  void consume(
      {Function suscriber, String queueName, List<String> domainEvents}) async {
    try {
      // final queue = await connection.queue(queueName);
      final exchange = await connection.exchange(exchangeName);
      final consumer =
          await exchange.bindQueueConsumer(queueName, domainEvents);
      // final consumer = await queue.consume(consumerTag: 'course.created');
      consumer.listen((AmqpMessage message) {
        print('Consuming $queueName');
        suscriber(message.payloadAsJson);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
