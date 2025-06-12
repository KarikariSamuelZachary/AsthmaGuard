// Main screen for displaying asthma health tips.
import 'package:flutter/material.dart';
import 'package:mobile/data/health_tip_model.dart';
import 'package:mobile/services/health_tips_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  final HealthTipsService _healthTipsService = HealthTipsService();

  List<HealthTip> _tips = [];
  HealthTip? _featuredTip;

  String _selectedCategory = 'all';
  String _searchQuery = '';

  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMorePages = true;
  int _currentPage = 1;
  static const int _itemsPerPage = 6;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHealthTips(isInitialLoad: true);
    _searchController.addListener(() {
      if (_searchQuery != _searchController.text) {
        setState(() {
          _searchQuery = _searchController.text;
          _currentPage = 1; // Reset to first page on new search
          _tips = []; // Clear existing tips
          _hasMorePages = true; // Assume there might be pages
        });
        _loadHealthTips(isInitialLoad: true); // Fetch new search results
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHealthTips({bool isInitialLoad = false}) async {
    if (isInitialLoad) {
      setState(() {
        _isLoading = true;
        _currentPage = 1;
        _tips = [];
        _hasMorePages = true;
      });
    } else {
      if (!_hasMorePages || _isLoadingMore) return;
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      final data = await _healthTipsService.fetchAsthmaHealthTips(
        page: _currentPage,
        limit: _itemsPerPage,
        category: _selectedCategory,
        searchQuery: _searchQuery,
      );

      if (mounted) {
        setState(() {
          if (isInitialLoad) {
            _featuredTip = data['featured'] as HealthTip?;
            _tips = data['tips'] as List<HealthTip>;
          } else {
            _tips.addAll(data['tips'] as List<HealthTip>);
          }
          _hasMorePages = data['hasMore'] as bool;
          _currentPage = data['currentPage'] as int;

          if (isInitialLoad) _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (isInitialLoad) _isLoading = false;
          _isLoadingMore = false;
          // Optionally show an error message to the user
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading health tips: $e')),
        );
      }
    }
  }

  void _onCategorySelected(String categoryId) {
    setState(() {
      _selectedCategory = categoryId;
      _currentPage = 1;
      _tips = [];
      _hasMorePages = true;
    });
    _loadHealthTips(isInitialLoad: true);
  }

  void _loadNextPage() {
    if (_hasMorePages && !_isLoadingMore) {
      setState(() {
        _currentPage++;
      });
      _loadHealthTips();
    }
  }

  Future<void> _launchURL(String? urlString) async {
    if (urlString == null) return;
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $urlString')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Asthma Health Tips',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF4285F4),
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _loadHealthTips(isInitialLoad: true),
              child: CustomScrollView(
                slivers: [
                  _buildSearchSliver(isDark),
                  if (_featuredTip != null &&
                      _searchQuery.isEmpty &&
                      _selectedCategory == 'all')
                    _buildFeaturedTipSliver(_featuredTip!, isDark),
                  _buildCategoriesSliver(isDark),
                  _buildTipsGridSliver(isDark),
                  if (_isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  if (!_isLoadingMore && _hasMorePages && _tips.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 32.0),
                        child: ElevatedButton(
                          onPressed: _loadNextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4285F4),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text('Load More Tips'),
                        ),
                      ),
                    ),
                  if (!_isLoading && !_isLoadingMore && _tips.isEmpty)
                    SliverFillRemaining(
                      // Use SliverFillRemaining to center content
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            _searchQuery.isNotEmpty ||
                                    _selectedCategory != 'all'
                                ? 'No tips found matching your criteria. Try adjusting your search or category.'
                                : 'No health tips available at the moment. Please check back later.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color:
                                    isDark ? Colors.white70 : Colors.grey[600]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildSearchSliver(bool isDark) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search tips (e.g., inhaler, triggers)...',
            hintStyle:
                TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
            prefixIcon: Icon(Icons.search,
                color: isDark ? Colors.grey[400] : Colors.grey[600]),
            filled: true,
            fillColor: isDark ? Colors.grey[800] : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          ),
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildFeaturedTipSliver(HealthTip featuredTip, bool isDark) {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () => _launchURL(featuredTip.url),
        child: Container(
          height: 220,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: featuredTip.imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(featuredTip.imageUrl!),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4), BlendMode.darken),
                  )
                : null,
            color: featuredTip.imageUrl == null
                ? (isDark ? Colors.grey[800] : Colors.blueGrey[100])
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  featuredTip.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                          blurRadius: 2,
                          color: Colors.black54,
                          offset: Offset(1, 1))
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  featuredTip.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    shadows: [
                      Shadow(
                          blurRadius: 1,
                          color: Colors.black38,
                          offset: Offset(1, 1))
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSliver(bool isDark) {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: asthmaTipCategories.length,
          itemBuilder: (context, index) {
            final category = asthmaTipCategories[index];
            final bool isSelected = _selectedCategory == category['id'];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(category['label'] as String),
                avatar: Icon(
                  category['icon'] as IconData,
                  color: isSelected
                      ? (isDark ? Colors.white : Colors.blue.shade800)
                      : (isDark ? Colors.grey[300] : Colors.grey[700]),
                  size: 18,
                ),
                selected: isSelected,
                onSelected: (_) =>
                    _onCategorySelected(category['id'] as String),
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                selectedColor:
                    isDark ? Colors.blue.shade700 : Colors.blue.shade100,
                labelStyle: TextStyle(
                  color: isSelected
                      ? (isDark ? Colors.white : Colors.blue.shade900)
                      : (isDark ? Colors.grey[200] : Colors.black87),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                        color: isSelected
                            ? (isDark
                                ? Colors.blue.shade500
                                : Colors.blue.shade300)
                            : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                        width: 1)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTipsGridSliver(bool isDark) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75, // Adjust for content
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final tip = _tips[index];
            return _buildTipCard(tip, isDark);
          },
          childCount: _tips.length,
        ),
      ),
    );
  }

  Widget _buildTipCard(HealthTip tip, bool isDark) {
    final categoryMeta = asthmaTipCategories.firstWhere(
        (cat) => cat['id'] == tip.category,
        orElse: () =>
            {'label': 'General', 'icon': Icons.info_outline} // Fallback
        );

    return GestureDetector(
      onTap: () => _launchURL(tip.url),
      child: Card(
        elevation: 3,
        clipBehavior: Clip.antiAlias, // Ensures image corners are rounded
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tip.imageUrl != null)
              Expanded(
                flex: 3, // Give more space to image
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(tip.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: tip.type == 'video'
                      ? Center(
                          child: Icon(Icons.play_circle_fill,
                              color: Colors.white.withOpacity(0.8), size: 40))
                      : null,
                ),
              ),
            if (tip.imageUrl == null) // Placeholder if no image
              Expanded(
                flex: 3,
                child: Container(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  width: double.infinity,
                  child: Icon(Icons.image_not_supported,
                      size: 40,
                      color: isDark ? Colors.grey[400] : Colors.grey[600]),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    maxLines: 2, // Adjust as needed
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(categoryMeta['icon'] as IconData,
                          size: 14,
                          color: isDark
                              ? Colors.blue.shade300
                              : Colors.blue.shade700),
                      const SizedBox(width: 4),
                      Text(
                        categoryMeta['label'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Colors.blue.shade300
                              : Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
