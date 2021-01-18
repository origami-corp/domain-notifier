import 'package:dart_amqp/dart_amqp.dart';
import 'package:domain_notifier/src/domain/event/domain_event.dart';
import 'package:domain_notifier/src/domain/event/event.dart';

import 'package:domain_notifier/src/infrastructure/event/domain_event_json_serializer.dart';
import 'package:domain_notifier/src/infrastructure/event/rabbit_mq/rabbit_mq_connection.dart';

class RabbitMqEvent implements Event {
  RabbitMqEvent({this.connection, this.exchangeName});

  RabbitMqConnection connection;
  String exchangeName;

  @override
  void publish(List<DomainEvent> events) {
    events.forEach(_publisher);
  }

  void _publisher(DomainEvent event) {
    try {
      _publishEvent(event);
    } catch (e) {
      print(e.toString());
    }
  }

  void _publishEvent(DomainEvent event) async {
    final body = DomainEventJsonSerializer.serialize(event);
    final routingKey = event.eventName();
    final messageId = event.eventId;
    final exchange = await connection.exchange(exchangeName);
    print('Publishing domain event, Exchange: $exchangeName');
    print(body);
    print('------');
    exchange.publish(body, routingKey,
        properties: MessageProperties()
          ..persistent = true
          ..messageId = messageId
          ..contentType = 'application/json'
          ..contentEncoding = 'utf-8');
  }
}
