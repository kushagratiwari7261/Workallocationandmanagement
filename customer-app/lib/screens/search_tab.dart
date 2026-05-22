import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _results = [];

  final List<String> _allServices = [
    'Deep Kitchen Cleaning',
    'Full Bathroom Scrub',
    'Ceiling Fan Repair',
    'Switchboard Setup',
    'AC Gas Refilling',
    'Bedbug Pest Spray',
    'Balcony Wall Paint',
  ];

  void _search(String query) {
    if (query.isEmpty) {
      setState(() {
        _results = [];
      });
      return;
    }
    setState(() {
      _results = _allServices
          .where((s) => s.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Services',
          style: TextStyle(fontWeight: FontWeight.extrabold, fontSize: 20, color: AppTheme.textMain),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: 'What service are you looking for?',
                prefixIcon: const Icon(LucideIcons.search, color: AppTheme.textMuted),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(LucideIcons.x, color: AppTheme.textMuted),
                        onPressed: () {
                          _searchController.clear();
                          _search('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _results.isEmpty && _searchController.text.isNotEmpty
                ? const Center(
                    child: Text(
                      'No matching services found',
                      style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold),
                    ),
                  )
                : _searchController.text.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.search, size: 48, color: Colors.grey.shade200),
                          const SizedBox(height: 12),
                          const Text(
                            'Try searching "Cleaning", "AC", or "Paint"...',
                            style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final item = _results[index];
                          return ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(LucideIcons.activity, color: AppTheme.primary, size: 18),
                            ),
                            title: Text(
                              item,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textMain),
                            ),
                            trailing: const Icon(LucideIcons.chevronRight, color: AppTheme.textMuted, size: 16),
                            onTap: () {
                              // Navigate to booking details
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
