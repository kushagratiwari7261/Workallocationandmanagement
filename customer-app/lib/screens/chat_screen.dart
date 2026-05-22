import 'package:flutter/material.dart';
import '../core/socket.dart';
import '../core/theme.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChatScreen extends StatefulWidget {
  final String bookingId;

  const ChatScreen({super.key, required this.bookingId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initSocket();
  }

  Future<void> _initSocket() async {
    final socket = await SocketService().getSocket();
    socket.emit('chat:join', {'bookingId': widget.bookingId});

    SocketService().addListener('chat:message', _onMessageReceived);

    // Mock initial welcoming message
    setState(() {
      _messages.add({
        'sender': 'provider',
        'text': 'Hi, I am Ramesh, your assigned cleaning professional. I am on my way to your location!',
        'timestamp': DateTime.now().toIso8601String(),
      });
    });
  }

  void _onMessageReceived(dynamic data) {
    if (data is Map && data['bookingId'] == widget.bookingId) {
      setState(() {
        _messages.add({
          'sender': 'provider',
          'text': data['message'] ?? '',
          'timestamp': DateTime.now().toIso8601String(),
        });
      });
      _scrollToBottom();
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final socket = await SocketService().getSocket();
    socket.emit('chat:send', {
      'bookingId': widget.bookingId,
      'message': text,
    });

    setState(() {
      _messages.add({
        'sender': 'customer',
        'text': text,
        'timestamp': DateTime.now().toIso8601String(),
      });
    });
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ramesh Kumar', style: TextStyle(fontWeight: FontWeight.extrabold, fontSize: 16)),
            Text('Service Provider', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.textMain,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isCustomer = msg['sender'] == 'customer';
                return Align(
                  alignment: isCustomer ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isCustomer ? AppTheme.primary : Colors.grey.shade100,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isCustomer ? 16 : 0),
                        bottomRight: Radius.circular(isCustomer ? 0 : 16),
                      ),
                    ),
                    child: Text(
                      msg['text'] ?? '',
                      style: TextStyle(
                        color: isCustomer ? Colors.white : AppTheme.textMain,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Input Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppTheme.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(LucideIcons.send, color: AppTheme.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SocketService().removeListener('chat:message', _onMessageReceived);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
