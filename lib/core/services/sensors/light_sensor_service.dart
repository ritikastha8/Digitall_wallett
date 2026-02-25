import 'package:flutter/services.dart';

class LightSensorService {
  LightSensorService._();

  static const EventChannel _eventChannel = EventChannel(
    'digital_wallett/light_sensor_events',
  );

  static Stream<double> get luxStream {
    return _eventChannel
        .receiveBroadcastStream()
        .where((event) {
          return event is num || double.tryParse('$event') != null;
        })
        .map((event) {
          if (event is num) {
            return event.toDouble();
          }
          return double.parse('$event');
        });
  }
}
