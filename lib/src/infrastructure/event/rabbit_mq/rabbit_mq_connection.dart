import 'package:dart_amqp/dart_amqp.dart' as ampq;

class RabbitMqConfiguration {
  RabbitMqConfiguration({this.hostname, this.username, this.password});
  final String hostname;
  final String username;
  final String password;
}

class RabbitMqConnection {
  RabbitMqConnection({RabbitMqConfiguration configuration}) {
    _configuration = configuration;
    _connectionSettings ??= ampq.ConnectionSettings(
        host: _configuration.hostname,
        authProvider: ampq.PlainAuthenticator(
            _configuration.username, _configuration.password));
    _connection = ampq.Client(settings: _connectionSettings);
  }

  ampq.Client _connection;
  ampq.Channel _channel;

  ampq.ConnectionSettings _connectionSettings;

  final Map<String, ampq.Exchange> _exchanges = {};
  final Map<String, ampq.Queue> _queues = {};
  RabbitMqConfiguration _configuration;

  Future<ampq.Channel> channel() async {
    _channel ??= await _connection.channel();
    return _channel;
  }

  Future<ampq.Exchange> exchange(String name) async {
    if (_exchanges[name] == null) {
      _exchanges[name] = await _setExchange(name);
    }
    return _exchanges[name];
  }

  Future<ampq.Queue> queue(String name) async {
    if (_queues[name] == null) {
      _queues[name] = await _setQueue(name);
    }
    return _queues[name];
  }

  Future<ampq.Queue> _setQueue(String name) async {
    final channelInfo = await channel();
    return await channelInfo.queue(name, durable: true, arguments: {});
  }

  Future<ampq.Exchange> _setExchange(name) async {
    final channelInfo = await channel();
    return await channelInfo.exchange(name, ampq.ExchangeType.TOPIC,
        durable: true);
  }

  // AMPQ.ConnectionSettings _setConnection() {
  //   return _connectionSettings;
  // }
}
