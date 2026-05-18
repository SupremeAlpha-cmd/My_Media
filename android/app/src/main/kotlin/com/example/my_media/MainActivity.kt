package com.example.my_media

import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioTrack
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.my_media/audio"
    private var audioTrack: AudioTrack? = null
    private val executor = Executors.newSingleThreadExecutor()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize AudioTrack for PCM 16-bit 44.1kHz mono (Standard for record package)
        val sampleRate = 44100
        val channelConfig = AudioFormat.CHANNEL_OUT_MONO
        val audioFormat = AudioFormat.ENCODING_PCM_16BIT
        val bufferSize = AudioTrack.getMinBufferSize(sampleRate, channelConfig, audioFormat) * 2

        audioTrack = AudioTrack(
            AudioManager.STREAM_VOICE_CALL, // Routes to earpiece/bluetooth natively
            sampleRate,
            channelConfig,
            audioFormat,
            bufferSize,
            AudioTrack.MODE_STREAM
        )
        audioTrack?.play()

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "playBytes") {
                val bytes = call.argument<ByteArray>("bytes")
                if (bytes != null && audioTrack != null) {
                    executor.execute {
                        audioTrack?.write(bytes, 0, bytes.size)
                    }
                }
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        audioTrack?.stop()
        audioTrack?.release()
        audioTrack = null
        executor.shutdown()
        super.onDestroy()
    }
}
