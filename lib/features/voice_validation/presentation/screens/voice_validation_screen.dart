import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/voice_validation_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VoiceValidationScreen extends ConsumerStatefulWidget {
  const VoiceValidationScreen({super.key});

  @override
  ConsumerState<VoiceValidationScreen> createState() => _VoiceValidationScreenState();
}

class _VoiceValidationScreenState extends ConsumerState<VoiceValidationScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(voiceValidationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Validation'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildQuestionCard(context),
            const Spacer(),
            if (state.result != null) _buildResultCard(context, state.result!)
            else if (state.isLoading) _buildLoadingState(context)
            else _buildInstructionText(context, state.isListening),
            const Spacer(),
            _buildMicrophoneSection(context, state.isListening),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Explain the concept of wave-particle duality in quantum mechanics.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, dynamic result) {
    return Card(
      elevation: 0,
      color: result.isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: result.isCorrect ? Colors.green : Colors.red),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(
              result.isCorrect ? Icons.check_circle_rounded : Icons.error_rounded,
              color: result.isCorrect ? Colors.green : Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              result.isCorrect ? 'Correct Answer!' : 'Needs Improvement',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: result.isCorrect ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              result.feedback,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Confidence Score: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${(result.confidenceScore * 100).toInt()}%'),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).scale();
  }

  Widget _buildLoadingState(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        const Text('Analyzing your voice...', style: TextStyle(fontStyle: FontStyle.italic)),
      ],
    );
  }

  Widget _buildInstructionText(BuildContext context, bool isListening) {
    return Text(
      isListening ? 'Listening...' : 'Tap the microphone to start speaking your answer.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: isListening ? Theme.of(context).primaryColor : Colors.grey,
        fontWeight: isListening ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildMicrophoneSection(BuildContext context, bool isListening) {
    return GestureDetector(
      onLongPressStart: (_) => ref.read(voiceValidationProvider.notifier).startListening(),
      onLongPressEnd: (_) => ref.read(voiceValidationProvider.notifier).stopAndValidate('q1', 'wave-particle duality'),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isListening ? Colors.red.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: isListening ? Colors.red : Theme.of(context).primaryColor,
              child: const Icon(Icons.mic_rounded, color: Colors.white, size: 40),
            ),
          ).animate(
            target: isListening ? 1 : 0,
            onPlay: (controller) => controller.repeat(),
          ).scale(
            begin: const Offset(1, 1),
            end: const Offset(1.2, 1.2),
            duration: 800.ms,
          ),
          const SizedBox(height: 16),
          const Text(
            'Hold to record',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

