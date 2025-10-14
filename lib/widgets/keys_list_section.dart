import 'package:flutter/material.dart';
import 'package:vpncn2_app/widgets/key_item_tile.dart';
import 'package:vpncn2_app/services/keys_service.dart';
import 'package:vpncn2_app/services/user_service.dart';
import 'package:vpncn2_app/features/keys/domain/entities/key.dart' as KeyEntity;
import 'package:vpncn2_app/core/error/error_handler_mixin.dart';

class KeysListSection extends StatefulWidget {
  const KeysListSection({super.key});

  @override
  State<KeysListSection> createState() => KeysListSectionState();
}

class KeysListSectionState extends State<KeysListSection>
    with ErrorHandlerMixin {
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
    handleApiResult(
      result,
      onSuccess: (keys) {
        setState(() {
          _keys = keys;
          _isLoading = false;
        });
      },
      onRetry: () => _loadKeys(),
    );
  }

  Future<void> _onRefresh() async {
    await UserService.getCurrentUser();
    await _loadKeys();
  }

  int get count => _keys.length;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
              padding: const EdgeInsets.only(top: 8),
              itemBuilder: (context, index) {
                final key = _keys[index];
                final remainDays = key.endDate
                    .difference(DateTime.now())
                    .inDays;
                final quotaGB = (key.dataLimit / (1024 * 1024 * 1024)).round();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: KeyItemTile(
                    name: key.name,
                    quotaText: '${quotaGB}GB',
                    remainDays: remainDays > 0 ? remainDays : 0,
                    keyData: key,
                    onServerLocationChanged: (code, country) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Server location changed to $country'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
