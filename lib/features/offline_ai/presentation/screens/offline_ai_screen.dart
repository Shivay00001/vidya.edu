import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/offline_ai_provider.dart';
import '../../domain/entities/offline_ai_model.dart';

class OfflineAiScreen extends ConsumerStatefulWidget {
  const OfflineAiScreen({super.key});

  @override
  ConsumerState<OfflineAiScreen> createState() => _OfflineAiScreenState();
}

class _OfflineAiScreenState extends ConsumerState<OfflineAiScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(offlineAiProvider.notifier).loadModels(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(offlineAiProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline AI Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOfflineToggle(state.isOfflineModeEnabled),
            const SizedBox(height: 32),
            const Text(
              'Available On-Device Models',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: state.isLoading && state.availableModels.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _buildModelsList(state.availableModels),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineToggle(bool isEnabled) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_rounded, size: 32, color: Colors.blue),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offline Mode',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Enable for local inference when internet is unavailable.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) =>
                ref.read(offlineAiProvider.notifier).toggleOfflineMode(value),
          ),
        ],
      ),
    );
  }

  Widget _buildModelsList(List<OfflineAiModel> models) {
    return ListView.builder(
      itemCount: models.length,
      itemBuilder: (context, index) {
        final model = models[index];
        return _buildModelItem(model);
      },
    );
  }

  Widget _buildModelItem(OfflineAiModel model) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.memory_rounded, color: Colors.purple),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(model.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('${model.sizeInMB.toStringAsFixed(1)} MB', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                if (model.isDownloaded)
                  const Icon(Icons.check_circle, color: Colors.green)
                else
                  IconButton(
                    icon: const Icon(Icons.download_rounded, color: Colors.blue),
                    onPressed: () => ref.read(offlineAiProvider.notifier).downloadModel(model.id),
                  ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(model.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

