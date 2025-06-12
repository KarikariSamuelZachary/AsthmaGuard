import 'package:flutter/material.dart'; // Required for IconData in asthmaTipCategories if used here
import 'package:mobile/data/health_tip_model.dart'; // Adjust path if necessary

class HealthTipsService {
  // Mock data for asthma health tips
  final List<HealthTip> _mockAsthmaTips = [
    HealthTip(
      id: 'asthma_1',
      category: 'trigger_avoidance',
      title: 'Identify and Avoid Asthma Triggers',
      description:
          'Learn common asthma triggers like pollen, dust mites, and smoke, and how to minimize exposure.',
      type: 'article',
      imageUrl:
          'https://images.unsplash.com/photo-1587614203976-6247eff1811a?w=800&auto=format&fit=crop',
      url: 'https://www.aafa.org/asthma-triggers-causes/',
    ),
    HealthTip(
      id: 'asthma_2',
      category: 'medication',
      title: 'Proper Inhaler Technique',
      description:
          'Ensure you are using your inhaler correctly for maximum effectiveness. Watch a video guide.',
      type: 'video',
      imageUrl:
          'https://images.unsplash.com/photo-1607619056574-7d8d3ee536ba?w=800&auto=format&fit=crop',
      url: 'https://www.youtube.com/watch?v=T_4_1MignhA',
    ),
    HealthTip(
      id: 'asthma_3',
      category: 'breathing_exercises',
      title: 'Pursed Lip Breathing Exercise',
      description:
          'Practice pursed lip breathing to help control shortness of breath during an asthma flare-up.',
      type: 'article',
      imageUrl:
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800&auto=format&fit=crop',
      url:
          'https://www.lung.org/lung-health-diseases/lung-disease-lookup/asthma/living-with-asthma/managing-asthma/breathing-exercises',
    ),
    HealthTip(
      id: 'asthma_4',
      category: 'emergency_actions',
      title: 'What To Do During an Asthma Attack',
      description:
          'Know the steps to take if you or someone else is having an asthma attack. Includes when to call for emergency help.',
      type: 'article',
      imageUrl:
          'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800&auto=format&fit=crop',
      url: 'https://www.asthma.org.uk/advice/asthma-attacks/',
    ),
    HealthTip(
      id: 'asthma_5',
      category: 'lifestyle',
      title: 'Maintaining a Healthy Lifestyle with Asthma',
      description:
          'Tips on diet, exercise, and sleep to help manage asthma symptoms and improve overall well-being.',
      type: 'article',
      imageUrl:
          'https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=800&auto=format&fit=crop',
      url: 'https://www.nhlbi.nih.gov/health/asthma/living-with',
    ),
    HealthTip(
      id: 'asthma_6',
      category: 'trigger_avoidance',
      title: 'Managing Allergies to Prevent Asthma Flares',
      description:
          'Understand how allergies can trigger asthma and learn strategies for managing them effectively.',
      type: 'article',
      imageUrl:
          'https://images.unsplash.com/photo-1600374906050-8a050318075c?w=800&auto=format&fit=crop',
      url: 'https://acaai.org/asthma/types-asthma/allergic-asthma/',
    ),
    HealthTip(
      id: 'asthma_7',
      category: 'medication',
      title: 'Understanding Your Asthma Medications',
      description:
          'Learn about the different types of asthma medications (controllers vs. relievers) and their roles.',
      type: 'article',
      imageUrl:
          'https://images.unsplash.com/photo-1584515933487-759828d27558?w=800&auto=format&fit=crop',
      url: 'https://www.cdc.gov/asthma/medications.htm',
    ),
    HealthTip(
      id: 'asthma_8',
      category: 'breathing_exercises',
      title: 'Diaphragmatic (Belly) Breathing',
      description:
          'Strengthen your diaphragm and improve breathing efficiency with this simple technique.',
      type: 'article',
      imageUrl:
          'https://images.unsplash.com/photo-1591278167969-6de437ef00a3?w=800&auto=format&fit=crop',
      url:
          'https://my.clevelandclinic.org/health/articles/9445-diaphragmatic-breathing',
    ),
    HealthTip(
      id: 'asthma_9',
      category: 'lifestyle',
      title: 'Asthma-Friendly Exercise',
      description:
          'Discover safe and effective ways to stay active with asthma, including recommended activities.',
      type: 'article',
      imageUrl:
          'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800&auto=format&fit=crop',
      url: 'https://www.asthma.com/living-with-asthma/asthma-and-exercise/',
    ),
    HealthTip(
      id: 'asthma_10',
      category: 'emergency_actions',
      title: 'Creating an Asthma Action Plan',
      description:
          'Work with your doctor to create a personalized asthma action plan for managing your symptoms.',
      type: 'article',
      imageUrl:
          'https://images.unsplash.com/photo-1550831107-1553da8c8464?w=800&auto=format&fit=crop',
      url:
          'https://www.lung.org/lung-health-diseases/lung-disease-lookup/asthma/living-with-asthma/managing-asthma/create-an-asthma-action-plan',
    ),
  ];

  final Map<String, dynamic> _mockFeaturedTip = {
    'id': 'asthma_ft_1', // Added id for potential navigation/tracking
    'title': "Breathe Easy: Your Asthma Action Plan",
    'description':
        "Learn how to create and use an asthma action plan to manage your symptoms effectively and know when to seek help.",
    'imageUrl':
        'https://images.unsplash.com/photo-1530021230391-9926039093e4?w=800&auto=format&fit=crop',
    'category': "emergency_actions",
    'url':
        'https://www.lung.org/lung-health-diseases/lung-disease-lookup/asthma/living-with-asthma/managing-asthma/create-an-asthma-action-plan',
    'type': 'article', // Added type for consistency
  };

  Future<Map<String, dynamic>> fetchAsthmaHealthTips({
    int page = 1,
    int limit = 6, // Default items per page
    String category = 'all',
    String searchQuery = '',
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    List<HealthTip> tipsToFilter = List.from(_mockAsthmaTips);

    // Filter by category
    if (category != 'all') {
      tipsToFilter =
          tipsToFilter.where((tip) => tip.category == category).toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      tipsToFilter = tipsToFilter.where((tip) {
        return tip.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            tip.description.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Paginate
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    bool hasMore = endIndex < tipsToFilter.length;

    List<HealthTip> paginatedTips = tipsToFilter.sublist(
        startIndex, endIndex.clamp(0, tipsToFilter.length));

    return {
      'featured': HealthTip(
        // Return as HealthTip object for consistency
        id: _mockFeaturedTip['id'],
        title: _mockFeaturedTip['title'],
        description: _mockFeaturedTip['description'],
        imageUrl: _mockFeaturedTip['imageUrl'],
        category: _mockFeaturedTip['category'],
        url: _mockFeaturedTip['url'],
        type: _mockFeaturedTip['type'],
      ),
      'tips': paginatedTips,
      'hasMore': hasMore,
      'currentPage': page,
      'totalResults': tipsToFilter.length, // Useful for display
    };
  }
}
