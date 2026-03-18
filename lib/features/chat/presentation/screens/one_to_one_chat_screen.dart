import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            _headerSection(),
            Expanded(child: _conversationBody()),
            _composerSection(),
          ],
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.chevron_left_rounded,
              size: 34,
              color: Color(0xFF5B5B5B),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Row(
              children: [
                _profileAvatar(
                  imagePath: AppImages.demoProfile,
                  size: 60,
                  showOnlineIndicator: true,
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nusrat Jahan',
                      style: TextStyle(
                        fontSize: 26,
                        color: Color(0xFF1F1F1F),
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Active Now',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF787878),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call_outlined,
              size: 28,
              color: Color(0xFF666666),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              size: 28,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _conversationBody() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        _acceptedStatusStrip(),
        const SizedBox(height: 78),
        _centerTimelineText('Jul 8, 2025, 1:51 PM'),
        const SizedBox(height: 20),
        _textMessageRow(
          isMe: true,
          message:
              'Hello, I have liked your profile and believe it to be a good Match. If you like my profile too, kindly accept this Invitation. Please feel free to contact me to take this conversation ahead. Warm Regards, Mehedi H',
        ),
        _textMessageRow(
          isMe: false,
          message: 'Hello! Nice to meet you',
        ),
        const SizedBox(height: 8),
        _centerTimelineText('8 min ago'),
        const SizedBox(height: 8),
        _textMessageRow(
          isMe: true,
          message: 'Hello! Nice to meet you too 😊',
        ),
        _textMessageRow(
          isMe: false,
          message: 'That would be wonderful! How about this weekend?',
        ),
        _voiceMessageRow(isMe: true),
        _voiceMessageRow(isMe: false),
      ],
    );
  }

  Widget _acceptedStatusStrip() {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: Color(0xFFEBD9E2),
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'This Profile is Accepted',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Color(0xFFEBD9E2),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _centerTimelineText(String value) {
    return Center(
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 19,
          color: Color(0xFF9A9A9A),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _textMessageRow({
    required bool isMe,
    required String message,
  }) {
    final bubbleColor =
        isMe ? const Color(0xFFF4E8EE) : const Color(0xFFEFEFEF);
    final bubbleRadius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: Radius.circular(isMe ? 20 : 8),
      bottomRight: Radius.circular(isMe ? 8 : 20),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) _profileAvatar(imagePath: AppImages.demoProfile, size: 42),
          if (!isMe) const SizedBox(width: 10),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: bubbleRadius,
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Color(0xFF2C2C2C),
                  fontSize: 19,
                  height: 1.35,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 10),
          if (isMe) _profileAvatar(imagePath: AppImages.demoProfile2, size: 42),
        ],
      ),
    );
  }

  Widget _voiceMessageRow({required bool isMe}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) _profileAvatar(imagePath: AppImages.demoProfile, size: 42),
          if (!isMe) const SizedBox(width: 10),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            child: Container(
              height: 108,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4E8EE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4F4F4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: SizedBox(
                      height: 44,
                      child: CustomPaint(
                        painter: _WaveformPainter(color: Color(0xFF666666)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 10),
          if (isMe) _profileAvatar(imagePath: AppImages.demoProfile2, size: 42),
        ],
      ),
    );
  }

  Widget _composerSection() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE3E3E3), width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: SafeArea(
        top: false,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type a message',
                    hintStyle: TextStyle(
                      color: Color(0xFF8F8F8F),
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              _composerIcon(Icons.copy_all_rounded),
              const SizedBox(width: 10),
              _composerIcon(Icons.mic_none_rounded),
              const SizedBox(width: 10),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.near_me_rounded,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _composerIcon(IconData icon) {
    return Icon(
      icon,
      size: 24,
      color: const Color(0xFF727272),
    );
  }

  Widget _profileAvatar({
    required String imagePath,
    required double size,
    bool showOnlineIndicator = false,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (showOnlineIndicator)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF11A251),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  const _WaveformPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const spacing = 8.0;
    final centerY = size.height / 2;

    var x = 0.0;
    var index = 0;
    while (x <= size.width) {
      final amplitude = (math.sin(index * 0.65) + 1) / 2;
      final barHeight = 9 + (amplitude * (size.height - 8));
      canvas.drawLine(
        Offset(x, centerY - (barHeight / 2)),
        Offset(x, centerY + (barHeight / 2)),
        paint,
      );
      x += spacing;
      index++;
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
