import 'dart:async';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:domain_notifier/src/domain/event/domain_event.dart';
import 'package:domain_notifier/src/domain/event/event.dart';

import 'package:domain_notifier/src/infrastructure/event/domain_event_json_serializer.dart';
import 'package:domain_notifier/src/infrastructure/event/rabbit_mq/rabbit_mq_connection.dart';

class RabbitMqEvent implements Event {
  RabbitMqEvent(
      {required this.connection,
      required this.exchangeName,
      this.onError = print}) {
    connection
        .exchange(exchangeName)
        .then((exchange) => print('Exchange validate $exchangeName'))
        .timeout(const Duration(hours: 1),
            onTimeout: () =>
                print('Please check the connection with your Rabbitmq'))
        .catchError(onError);
  }

  RabbitMqConnection connection;
  String exchangeName;
  Function onError;

  @override
  List<Future<dynamic>> publish(List<DomainEvent> events) {
    return events.map(_publisher).toList();
  }

  Future<dynamic> _publisher(DomainEvent event) {
    try {
      return _publishEvent(event);
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  Future<dynamic> _publishEvent(DomainEvent event) async {
    final completer = Completer<dynamic>();
    try {
      final body = DomainEventJsonSerializer.serialize(event);
      final routingKey = event.eventName();
      final messageId = event.eventId;
      final exchange = await connection.exchange(exchangeName);
      print('Publishing domain event, Exchange: $exchangeName');
      print(body);
      print('------');

      exchange!.publish(body, routingKey,
          properties: MessageProperties()
            ..corellationId = event.aggregateId
            ..persistent = true
            ..messageId = messageId
            ..contentType = 'application/json'
            ..contentEncoding = 'utf-8');
      completer.complete([body, routingKey, messageId, exchangeName]);
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }
}
