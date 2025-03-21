import 'package:flutter/material.dart';
import 'package:myapp/src/core/di/dependency_injection.dart';
import 'package:myapp/src/core/repositories/base_repository.dart';
import 'package:myapp/src/core/theme/colors.dart';
import 'package:myapp/src/features/home/domain/entities/advisory.dart';
import 'package:myapp/src/features/home/domain/usecases/get_advisory_data.dart';

class AIAdvisoryFeed extends StatefulWidget {
  const AIAdvisoryFeed({super.key});

  @override
  State<AIAdvisoryFeed> createState() => _AIAdvisoryFeedState();
}

class _AIAdvisoryFeedState extends State<AIAdvisoryFeed> {
  late GetAdvisoryData _getAdvisoryData;
  bool _isLoading = true;
  List<Advisory>? _advisories;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getAdvisoryData = DependencyInjection().getAdvisoryData;
    _fetchAdvisories();
  }

  Future<void> _fetchAdvisories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _getAdvisoryData.execute();
    
    setState(() {
      _isLoading = false;
      
      result.when(
        success: (data) {
          _advisories = data;
          _errorMessage = null;
        },
        failure: (error) {
          _advisories = null;
          _errorMessage = error.message;
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    } else if (_errorMessage != null) {
      return _buildErrorState();
    } else if (_advisories == null || _advisories!.isEmpty) {
      return _buildEmptyState();
    } else {
      return _buildAdvisoryContent();
    }
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading AI recommendations...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red[300],
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Unable to load advisory data',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Please check your internet connection and try again.',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _fetchAdvisories,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          'No advisory data available',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildAdvisoryContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'AI Recommendations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            Text(
              'Today',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._advisories!.map((advisory) => _buildAdvisoryItem(advisory)),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Navigate to detailed advisory page
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF2E7D32),
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('View All'),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvisoryItem(Advisory advisory) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: advisory.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              advisory.icon,
              color: advisory.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: advisory.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        advisory.priority,
                        style: TextStyle(
                          color: advisory.color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      advisory.type.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  advisory.description,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
