import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_mate/models/resource_model.dart';
import 'package:mind_mate/services/firebase_service.dart';
import 'package:flutter/foundation.dart';

class ResourceService {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final CollectionReference _resourcesCollection = FirebaseService.getCollection('resources');

  // Get all resources
  Future<List<Resource>> getResources() async {
    try {
      final QuerySnapshot snapshot = await _resourcesCollection
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return Resource.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting resources: $e');
      }
      return [];
    }
  }

  // Get resource by ID
  Future<Resource?> getResourceById(String resourceId) async {
    try {
      final DocumentSnapshot doc = await _resourcesCollection.doc(resourceId).get();
      if (doc.exists) {
        return Resource.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting resource by ID: $e');
      }
      return null;
    }
  }

  // Get resources by category
  Future<List<Resource>> getResourcesByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await _resourcesCollection
          .where('categories', arrayContains: category)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return Resource.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting resources by category: $e');
      }
      return [];
    }
  }

  // Get resources by type
  Future<List<Resource>> getResourcesByType(ResourceType type) async {
    try {
      final QuerySnapshot snapshot = await _resourcesCollection
          .where('type', isEqualTo: type.index)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return Resource.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting resources by type: $e');
      }
      return [];
    }
  }

  // Get featured resources
  Future<List<Resource>> getFeaturedResources() async {
    try {
      final QuerySnapshot snapshot = await _resourcesCollection
          .where('featured', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return Resource.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting featured resources: $e');
      }
      return [];
    }
  }

  // Search resources
  Future<List<Resource>> searchResources(String query) async {
    try {
      // Firestore doesn't support full-text search,
      // so this is a simple implementation that looks for the query in the title and description
      final QuerySnapshot snapshot = await _resourcesCollection.get();
      
      final List<Resource> resources = snapshot.docs
          .map((doc) => Resource.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      
      final String lowercaseQuery = query.toLowerCase();
      
      return resources.where((resource) {
        final String lowercaseTitle = resource.title.toLowerCase();
        final String lowercaseDescription = resource.description.toLowerCase();
        
        return lowercaseTitle.contains(lowercaseQuery) || 
               lowercaseDescription.contains(lowercaseQuery);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error searching resources: $e');
      }
      return [];
    }
  }

  // Increment view count for a resource
  Future<bool> incrementResourceViewCount(String resourceId) async {
    try {
      await _resourcesCollection.doc(resourceId).update({
        'viewCount': FieldValue.increment(1),
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error incrementing resource view count: $e');
      }
      return false;
    }
  }

  // Get recommended resources based on assessment results
  Future<List<Resource>> getRecommendedResources(
    String assessmentType,
    int score,
  ) async {
    try {
      // This is a simplified implementation
      // In a real app, you would have a more sophisticated recommendation system
      
      // Get resources by relevant category based on assessment type
      String category = '';
      
      switch (assessmentType) {
        case 'anxiety':
          category = 'Anxiety';
          break;
        case 'depression':
          category = 'Depression';
          break;
        case 'stress':
          category = 'Stress Management';
          break;
        case 'attention':
          category = 'Academic Success';
          break;
        default:
          category = 'Mindfulness';
      }
      
      // Get resources for this category
      return getResourcesByCategory(category);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting recommended resources: $e');
      }
      return [];
    }
  }
} 