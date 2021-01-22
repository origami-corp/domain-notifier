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
      final consumer =
          await exchange.bindQueueConsumer(queueName, domainEvents);
      consumer.listen((AmqpMessage message) {
        print('Consuming $queueName');
        subscriber(message.payloadAsJson);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
