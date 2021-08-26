import 'dart:io';

import 'package:dart_amqp/dart_amqp.dart' as ampq;

class RabbitMqConfiguration {
  RabbitMqConfiguration(
      {required this.hostname,
      required this.username,
      required this.password,
      this.port = 5672});
  final String hostname;
  final String username;
  final String password;
  final int port;
}

class RabbitMqConnection {
  RabbitMqConnection({required RabbitMqConfiguration configuration}) {
    _configuration = configuration;
    _connectionSettings = ampq.ConnectionSettings(
        tlsContext: _configuration.hostname.contains('https://')
            ? SecurityContext(withTrustedRoots: true)
            : null,
        host: _configuration.hostname.replaceAll('https://', ''),
        port: _configuration.port,
        authProvider: ampq.PlainAuthenticator(
            _configuration.username, _configuration.password),
        maxConnectionAttempts: 1000,
        reconnectWaitTime: const Duration(milliseconds: 3000));
    connection = ampq.Client(settings: _connectionSettings);
    print(_connectionSettings.reconnectWaitTime);

    //connection.errorListener(errorListener);
  }

  late ampq.Client connection;
  late ampq.Channel? _channel;

  late ampq.ConnectionSettings _connectionSettings;

  final Map<String, ampq.Exchange> _exchanges = {};
  final Map<String, ampq.Queue> _queues = {};
  late RabbitMqConfiguration _configuration;

  Future<ampq.Channel?> channel() async {
    _channel ??= await connection.channel();
    return _channel;
  }

  Future<ampq.Exchange?> exchange(String name) async {
    if (_exchanges[name] == null) {
      _exchanges[name] = await _setExchange(name);
    }
    return _exchanges[name];
  }

  Future<ampq.Queue?> queue(String name, {bool durable = false}) async {
    if (_queues[name] == null) {
      _queues[name] = await _setQueue(name, durable: durable);
    }
    return _queues[name];
  }

  Future<ampq.Queue> _setQueue(String name, {bool durable = false}) async {
    final channelInfo = await channel();
    return await channelInfo!.queue(name, durable: durable, arguments: {});
  }

  Future<ampq.Exchange> _setExchange(name) async {
    final channelInfo = await channel();
    final exchange = await channelInfo!.exchange(name, ampq.ExchangeType.TOPIC,
        durable: true); // arguments: {"": ""}

    return exchange;
  }
}
