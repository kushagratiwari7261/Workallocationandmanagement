import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'supabase.dart';
import 'api.dart';

class SocketService with WidgetsBindingObserver {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  SocketService._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  io.Socket? _socket;
  final List<MapEntry<String, Function>> _listeners = [];
  bool _isBackgrounded = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _isBackgrounded = true;
      _pauseSocket();
    } else if (state == AppLifecycleState.resumed) {
      _isBackgrounded = false;
      _resumeSocket();
    }
  }

  void _pauseSocket() {
    if (_socket?.connected == true) {
      _socket?.disconnect();
      debugPrint('[Socket 🔌] App backgrounded — disconnected socket');
    }
  }

  Future<void> _resumeSocket() async {
    if (_socket == null) return;
    try {
      final session = SupabaseService.currentSession;
      if (session?.accessToken == null) return;

      _socket?.auth = {'token': session!.accessToken};
      _socket?.connect();
      debugPrint('[Socket 🔗] App resumed — reconnected socket');
    } catch (e) {
      debugPrint('[Socket ❌] Resume socket failed: $e');
    }
  }

  Future<io.Socket> getSocket() async {
    if (_socket?.connected == true) {
      return _socket!;
    }

    final session = SupabaseService.currentSession;
    final token = session?.accessToken;

    if (_socket != null) {
      _socket?.auth = {'token': token};
      _socket?.connect();
      return _socket!;
    }

    _socket = io.io(
      ApiClient.baseUrl,
      io.OptionBuilder()
          .setTransports(['polling', 'websocket'])
          .setAuth({'token': token})
          .enableAutoConnect()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .setReconnectionDelayMax(10000)
          .build(),
    );

    _socket?.onConnect((_) {
      debugPrint('[Socket 🔗] Connected to Workla Socket.IO server');
    });

    _socket?.onConnectError((err) {
      if (!_isBackgrounded) {
        debugPrint('[Socket ❌] Connection error: $err');
      }
    });

    _socket?.onDisconnect((_) {
      debugPrint('[Socket 🔌] Disconnected from server');
    });

    // Reattach all active listeners
    for (var entry in _listeners) {
      _socket?.on(entry.key, entry.value);
    }

    return _socket!;
  }

  void addListener(String event, Function(dynamic) handler) {
    _listeners.add(MapEntry(event, handler));
    _socket?.on(event, handler);
  }

  void removeListener(String event, Function(dynamic) handler) {
    _listeners.removeWhere((entry) => entry.key == event && entry.value == handler);
    _socket?.off(event, handler);
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
    _listeners.clear();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    disconnect();
  }
}
