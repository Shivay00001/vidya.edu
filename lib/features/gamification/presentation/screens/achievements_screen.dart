import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/gamification_provider.dart';
import '../../domain/entities/achievement.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(gamificationProvider.notifier).loadGamificationData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gamificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements & Badges'),
        centerTitle: true,
      ),
      body: state.isLoading && state.achievements.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.error != null && state.achievements.isEmpty
              ? Center(child: Text(state.error!))
              : CustomScrollView(
                  slivers: [
                    _buildSectionHeader('Your Badges'),
                    _buildBadgesGrid(state.badges),
                    _buildSectionHeader('Achievements'),
                    _buildAchievementsList(state.achievements),
                  ],
                ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Widget _buildBadgesGrid(List<Badge> badges) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final badge = badges[index];
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.stars_rounded, color: Theme.of(context).primaryColor, size: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  badge.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  badge.criteria,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          },
          childCount: badges.length,
        ),
      ),
    );
  }

  Widget _buildAchievementsList(List<Achievement> achievements) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final achievement = achievements[index];
            return _buildAchievementItem(achievement);
          },
          childCount: achievements.length,
        ),
      ),
    );
  }

  Widget _buildAchievementItem(Achievement achievement) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: achievement.isUnlocked 
                ? Colors.amber.withOpacity(0.1) 
                : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            achievement.isUnlocked ? Icons.emoji_events_rounded : Icons.lock_outline,
            color: achievement.isUnlocked ? Colors.amber : Colors.grey,
          ),
        ),
        title: Text(
          achievement.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: achievement.isUnlocked ? null : Colors.grey,
          ),
        ),
        subtitle: Text(
          achievement.description,
          style: TextStyle(
            fontSize: 12,
            color: achievement.isUnlocked ? null : Colors.grey,
          ),
        ),
        trailing: achievement.isUnlocked 
            ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
            : null,
      ),
    );
  }
}


