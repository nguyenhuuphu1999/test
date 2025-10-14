import 'package:flutter/material.dart';
import 'package:vpncn2_app/constants/app_colors.dart';
import 'package:vpncn2_app/utils/responsive.dart';
import 'package:vpncn2_app/services/locations_service.dart';
import 'package:vpncn2_app/features/locations/domain/entities/location.dart';
import 'package:vpncn2_app/core/error/error_handler_mixin.dart';

class ChangeLocationModal extends StatefulWidget {
  final String deviceId;
  final String deviceName;

  const ChangeLocationModal({
    super.key,
    required this.deviceId,
    required this.deviceName,
  });

  @override
  State<ChangeLocationModal> createState() => _ChangeLocationModalState();
}

class _ChangeLocationModalState extends State<ChangeLocationModal>
    with ErrorHandlerMixin {
  final TextEditingController _searchController = TextEditingController();
  LocationsResponse? _locationsData;
  bool _isLoading = true;
  String? _selectedLocationId;
  List<Location> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
    _searchController.addListener(_filterLocations);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLocations() async {
    setState(() {
      _isLoading = true;
    });

    final result = await LocationsService.getLocations(
      deviceId: widget.deviceId,
      search: null,
    );

    handleApiResult(
      result,
      onSuccess: (locationsData) {
        setState(() {
          _locationsData = locationsData;
          _selectedLocationId = locationsData.currentLocation.id;
          _filteredLocations = locationsData.allLocations;
          _isLoading = false;
        });
      },
      onRetry: () => _loadLocations(),
    );
  }

  void _filterLocations() {
    if (_locationsData == null) return;

    final searchQuery = _searchController.text.toLowerCase();
    setState(() {
      if (searchQuery.isEmpty) {
        _filteredLocations = _locationsData!.allLocations;
      } else {
        _filteredLocations = _locationsData!.allLocations
            .where(
              (location) =>
                  location.location.toLowerCase().contains(searchQuery),
            )
            .toList();
      }
    });
  }

  Color _getUptimeColor(double uptime) {
    if (uptime >= 80) return Colors.green;
    if (uptime >= 50) return Colors.orange;
    return Colors.red;
  }

  Widget _buildFlagIcon(String location) {
    // Simple flag representation based on location name
    // In a real app, you'd use actual flag images
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getLocationColor(location),
      ),
      child: Center(
        child: Text(
          location.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getLocationColor(String location) {
    // Simple color mapping for demo
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    return colors[location.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(Responsive.width(context, 6)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: Responsive.height(context, 3)),

          // Header
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.PRIMARY_COLOR,
                  size: Responsive.getFontSize(context, 24),
                ),
              ),
              SizedBox(width: Responsive.width(context, 4)),
              Expanded(
                child: Text(
                  'Change Location',
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 18),
                    fontWeight: FontWeight.w600,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                ),
              ),
              Icon(
                Icons.public,
                color: AppColors.PRIMARY_COLOR,
                size: Responsive.getFontSize(context, 24),
              ),
            ],
          ),
          SizedBox(height: Responsive.height(context, 3)),

          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_locationsData != null) ...[
            // Current Location Section
            Text(
              'Current Location of ${widget.deviceName}:',
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, 14),
                color: AppColors.TEXT_SECONDARY_COLOR,
              ),
            ),
            SizedBox(height: Responsive.height(context, 1)),
            _buildLocationItem(
              _locationsData!.currentLocation,
              isCurrent: true,
            ),
            SizedBox(height: Responsive.height(context, 3)),

            // Select Location Section
            Row(
              children: [
                Text(
                  'Select Location',
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 14),
                    color: AppColors.TEXT_SECONDARY_COLOR,
                  ),
                ),
                SizedBox(width: Responsive.width(context, 3)),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search Country',
                        hintStyle: TextStyle(
                          fontSize: Responsive.getFontSize(context, 14),
                          color: AppColors.TEXT_HINT_COLOR,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.TEXT_HINT_COLOR,
                          size: Responsive.getFontSize(context, 20),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.height(context, 2)),

            // Locations List
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredLocations.length,
                itemBuilder: (context, index) {
                  final location = _filteredLocations[index];
                  final isCurrent =
                      location.id == _locationsData!.currentLocation.id;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: _buildFlagIcon(location.location),
                      title: Text(
                        location.location,
                        style: TextStyle(
                          fontSize: Responsive.getFontSize(context, 16),
                          fontWeight: FontWeight.w500,
                          color: isCurrent
                              ? AppColors.PRIMARY_COLOR
                              : AppColors.TEXT_PRIMARY_COLOR,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getUptimeColor(location.uptime),
                            ),
                          ),
                          SizedBox(width: Responsive.width(context, 1)),
                          Text(
                            '${location.uptime.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: Responsive.getFontSize(context, 14),
                              color: AppColors.TEXT_SECONDARY_COLOR,
                            ),
                          ),
                          SizedBox(width: Responsive.width(context, 2)),
                          Radio<String>(
                            value: location.id,
                            groupValue: _selectedLocationId,
                            onChanged: isCurrent
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedLocationId = value;
                                    });
                                  },
                            activeColor: AppColors.PRIMARY_COLOR,
                          ),
                        ],
                      ),
                      onTap: isCurrent
                          ? null
                          : () {
                              setState(() {
                                _selectedLocationId = location.id;
                              });
                            },
                    ),
                  );
                },
              ),
            ),
          ],

          SizedBox(height: Responsive.height(context, 3)),

          // Change Location Button
          if (!_isLoading &&
              _locationsData != null &&
              _selectedLocationId != _locationsData!.currentLocation.id)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _changeLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.PRIMARY_COLOR,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: Responsive.height(context, 2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Change Location',
                  style: TextStyle(
                    fontSize: Responsive.getFontSize(context, 16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildLocationItem(Location location, {bool isCurrent = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.PRIMARY_COLOR.withOpacity(0.1)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrent ? AppColors.PRIMARY_COLOR : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          _buildFlagIcon(location.location),
          SizedBox(width: Responsive.width(context, 3)),
          Expanded(
            child: Text(
              location.location,
              style: TextStyle(
                fontSize: Responsive.getFontSize(context, 16),
                fontWeight: FontWeight.w600,
                color: AppColors.PRIMARY_COLOR,
              ),
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getUptimeColor(location.uptime),
            ),
          ),
          SizedBox(width: Responsive.width(context, 1)),
          Text(
            '${location.uptime.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: Responsive.getFontSize(context, 14),
              color: AppColors.TEXT_SECONDARY_COLOR,
            ),
          ),
          SizedBox(width: Responsive.width(context, 2)),
          Radio<String>(
            value: location.id,
            groupValue: _selectedLocationId,
            onChanged: null, // Current location is always selected
            activeColor: AppColors.PRIMARY_COLOR,
          ),
        ],
      ),
    );
  }

  Future<void> _changeLocation() async {
    if (_selectedLocationId == null) return;

    // TODO: Implement change location API call
    // For now, just show success message
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location changed successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
