import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AiAssistant extends StatefulWidget {
  const AiAssistant({super.key});

  @override
  State<AiAssistant> createState() => _AiAssistantState();
}

class _AiAssistantState extends State<AiAssistant> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();

  final List<Map<String, String>> messages = [
    {
      'role': 'assistant',
      'content':
          'Hi, Zafar, hope you are doing good.\nLets connect as scheduled and start learning 😊',
      'time': '1 Aug 4:00 PM',
    },
    {
      'role': 'user',
      'content': 'Sure Ma’am. I’m very excited. 😍',
      'time': '4:23 PM',
    },
    {
      'role': 'assistant',
      'content':
          'That’s a great start. Let’s meet again tomorrow.\nAnd don’t forget to finish the homework.\n\nGoodnight Zafar 😴',
      'time': '2 Aug 9:08 PM',
    },
    {
      'role': 'user',
      'content': 'Thank you very much! Happy. 😊',
      'time': '9:09 PM',
    },
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({
        'role': 'user',
        'content': text,
        'time': _formatTimeOfDay(TimeOfDay.now()),
      });
      _controller.clear();
    });

    // scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Placeholder: hook this to image_picker later
  void _pickImage() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Image picker not wired yet")));
  }

  // Placeholder: hook this to speech_to_text later
  void _voiceInput() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Voice input not wired yet")));
  }

  static String _formatTimeOfDay(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Assistant', style: GoogleFonts.outfit()),
        centerTitle: true,
      ),

      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUser = message['role'] == 'user';

                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.78,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.blueAccent
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: isUser
                              ? const Radius.circular(16)
                              : Radius.zero,
                          bottomRight: isUser
                              ? Radius.zero
                              : const Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['content'] ?? '',
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              message['time'] ?? '',
                              style: TextStyle(
                                fontSize: 10,
                                color: isUser ? Colors.white70 : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom input bar
            _ChatInputBar(
              controller: _controller,
              onSend: _sendMessage,
              onPickImage: _pickImage,
              onVoice: _voiceInput,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onPickImage;
  final VoidCallback onVoice;

  const _ChatInputBar({
    required this.controller,
    required this.onSend,
    required this.onPickImage,
    required this.onVoice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -2),
            color: Colors.black.withAlpha(06),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onPickImage,
            icon: const Icon(Icons.image_outlined),
            tooltip: "Image",
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: "Message...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Voice
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: IconButton(
              onPressed: onVoice,
              icon: const Icon(Icons.mic_none_rounded),
              tooltip: "Voice",
            ),
          ),

          const SizedBox(width: 8),

          // Send
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onSend,
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
              tooltip: "Send",
            ),
          ),
        ],
      ),
    );
  }
}
