import 'package:dart_amqp/dart_amqp.dart';

import './rabbit_mq_connection.dart';

class RabbitMqEventConsumer {
  RabbitMqEventConsumer({this.connection, this.exchangeName});

  RabbitMqConnection connection;
  String exchangeName;

  void consume(Function suscriber, String queueName) async {
    try {
      final queue = await connection.queue(queueName);
      final consumer = await queue.consume();
      consumer.listen((AmqpMessage message) {
        suscriber(message.payloadAsJson);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
