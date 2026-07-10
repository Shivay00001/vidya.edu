import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/adaptive_learning_provider.dart';
import '../../domain/entities/skill_mastery.dart';

class MasteryScreen extends ConsumerStatefulWidget {
  const MasteryScreen({super.key});

  @override
  ConsumerState<MasteryScreen> createState() => _MasteryScreenState();
}

class _MasteryScreenState extends ConsumerState<MasteryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(adaptiveLearningProvider.notifier).loadMasteryData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adaptiveLearningProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge Mastery'),
        centerTitle: true,
      ),
      body: state.isLoading && state.masteryList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.error != null && state.masteryList.isEmpty
              ? Center(child: Text(state.error!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOverviewCard(context, state.masteryList),
                      const SizedBox(height: 32),
                      _buildSectionHeader('Skill Breakdown'),
                      const SizedBox(height: 16),
                      ...state.masteryList.map((m) => _buildSkillItem(context, m)),
                      const SizedBox(height: 32),
                      _buildSectionHeader('Recommended for You'),
                      const SizedBox(height: 16),
                      _buildSuggestions(state.suggestions),
                    ],
                  ),
                ),
    );
  }

  Widget _buildOverviewCard(BuildContext context, List<SkillMastery> masteryList) {
    final averageMastery = masteryList.isEmpty 
        ? 0.0 
        : masteryList.map((m) => m.masteryScore).reduce((a, b) => a + b) / masteryList.length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Average Mastery Score',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '${(averageMastery * 100).toInt()}%',
            style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Keep it up! You\'re making great progress in Quantum Physics.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSkillItem(BuildContext context, SkillMastery mastery) {
    final color = _getMasteryColor(mastery.level);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mastery.skillName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    mastery.level.name.toUpperCase(),
                    style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: mastery.masteryScore,
              backgroundColor: Colors.grey.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              borderRadius: BorderRadius.circular(4),
              minHeight: 8,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.trending_up, size: 14, color: Colors.green),
                const SizedBox(width: 4),
                const Text('Strengths: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    mastery.strengthAreas.join(', '),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(List<String> suggestions) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: suggestions.map((s) => Chip(
        label: Text(s, style: const TextStyle(fontSize: 12)),
        backgroundColor: Colors.grey.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      )).toList(),
    );
  }

  Color _getMasteryColor(MasteryLevel level) {
    switch (level) {
      case MasteryLevel.novice:
        return Colors.blue;
      case MasteryLevel.intermediate:
        return Colors.green;
      case MasteryLevel.advanced:
        return Colors.orange;
      case MasteryLevel.expert:
        return Colors.red;
      case MasteryLevel.master:
        return Colors.purple;
    }
  }
}

