package com.ritika.digital_wallett_system.digital_wallett_system

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity(), SensorEventListener {
    private val lightSensorChannelName = "digital_wallett/light_sensor_events"
    private var sensorManager: SensorManager? = null
    private var lightSensor: Sensor? = null
    private var lightEventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        lightSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_LIGHT)

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            lightSensorChannelName
        ).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    lightEventSink = events
                    val sensor = lightSensor
                    if (sensor == null) {
                        lightEventSink?.error(
                            "NO_LIGHT_SENSOR",
                            "Light sensor is not available on this device.",
                            null
                        )
                        return
                    }
                    sensorManager?.registerListener(
                        this@MainActivity,
                        sensor,
                        SensorManager.SENSOR_DELAY_NORMAL
                    )
                }

                override fun onCancel(arguments: Any?) {
                    lightEventSink = null
                    sensorManager?.unregisterListener(this@MainActivity, lightSensor)
                }
            }
        )
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event?.sensor?.type == Sensor.TYPE_LIGHT) {
            lightEventSink?.success(event.values[0].toDouble())
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    override fun onPause() {
        super.onPause()
        sensorManager?.unregisterListener(this)
    }

    override fun onResume() {
        super.onResume()
        val sensor = lightSensor
        if (sensor != null && lightEventSink != null) {
            sensorManager?.registerListener(this, sensor, SensorManager.SENSOR_DELAY_NORMAL)
        }
    }

    override fun onDestroy() {
        sensorManager?.unregisterListener(this)
        super.onDestroy()
    }
}
