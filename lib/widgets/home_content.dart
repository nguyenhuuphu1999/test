import 'package:flutter/material.dart';
import 'package:vpncn2_app/widgets/key_item_tile.dart';
import 'package:vpncn2_app/widgets/common_search_field.dart';
import 'package:vpncn2_app/services/user_service.dart';
import 'package:vpncn2_app/services/keys_service.dart';
import 'package:vpncn2_app/features/keys/domain/entities/key.dart' as KeyEntity;

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<KeyEntity.Key> _keys = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    setState(() {
      _isLoading = true;
    });

    final result = await KeysService.getKeys(status: 1, pageSize: 10);

    result.when(
      ok: (keys) {
        setState(() {
          _keys = keys;
          _isLoading = false;
        });
      },
      err: (failure) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load keys: ${failure.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  Future<void> _onRefresh() async {
    // Refresh user data
    await UserService.getCurrentUser();

    // Refresh keys data
    await _loadKeys();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Home screen refreshed!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Field
        CommonSearchField.home(onChanged: (value) {}),

        const SizedBox(height: 24),

        // Key Items with Pull-to-Refresh
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _keys.isEmpty
                ? const Center(
                    child: Text(
                      'No keys found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _keys.length,
                    itemBuilder: (context, index) {
                      final key = _keys[index];
                      final remainDays = key.endDate
                          .difference(DateTime.now())
                          .inDays;
                      final quotaGB = (key.dataLimit / (1024 * 1024 * 1024))
                          .round();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: KeyItemTile(
                          name: key.name,
                          quotaText: '${quotaGB}GB',
                          remainDays: remainDays > 0 ? remainDays : 0,
                          onServerLocationChanged: (code, country) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Server location changed to $country',
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
