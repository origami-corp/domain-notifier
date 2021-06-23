import 'package:dart_amqp/dart_amqp.dart';

import './rabbit_mq_connection.dart';

class RabbitMqEventConsumer {
  RabbitMqEventConsumer({this.connection, this.exchangeName});

  RabbitMqConnection connection;
  String exchangeName;

  void consume(
      {Function subscriber,
      String queueName,
      List<String> domainEvents}) async {
    try {
      // final queue = await connection.queue(queueName);
      final exchange = await connection.exchange(exchangeName);
      if ((domainEvents == null || domainEvents.isEmpty)) {
        throw ArgumentError(
            "One or more domain events (routing keys) needs to be specified for this exchange ${exchangeName}");
      }

      Queue queue = await connection.queue(queueName, durable: true);

      for (String routingKey in domainEvents) {
        await queue.bind(exchange, routingKey);
      }

      final consumer = await queue.consume();
      consumer.listen((AmqpMessage message) {
        print('Consuming $queueName');
        print(message.payloadAsString);
        subscriber(message);
      });
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }
}
