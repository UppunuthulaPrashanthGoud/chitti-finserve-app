import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/banner_model.dart';
import '../../core/network_service.dart';

class BannerRepository {
  static Future<BannerListModel> loadBanners() async {
    try {
      // Try to fetch from API first
      final response = await NetworkService.get('/banners/active');
      final jsonMap = NetworkService.parseResponse(response);
      
      // Debug logging to see the raw response
      print('🔧 BannerRepository Debug - Raw API Response:');
      print('   Response: $jsonMap');
      
      // Filter only active banners
      final activeBanners = (jsonMap['data'] as List)
          .where((banner) => banner['isActive'] == true)
          .toList();
      
      // Debug logging for each banner's image path
      for (var banner in activeBanners) {
        print('🔧 Banner: ${banner['title']}');
        print('   Image path: ${banner['image']}');
        print('   Image path type: ${banner['image'].runtimeType}');
      }
      
      return BannerListModel.fromJson({
        'data': activeBanners,
        'pagination': jsonMap['pagination'],
      });
    } catch (e) {
      print('❌ BannerRepository Error: $e');
      // Fallback to local JSON if API fails
      try {
        final String response = await rootBundle.loadString('assets/json/banners.json');
        final data = await json.decode(response);
        return BannerListModel.fromJson(data);
      } catch (fallbackError) {
        print('❌ BannerRepository Fallback Error: $fallbackError');
        // Final fallback to hardcoded banners
        return BannerListModel(data: [
          BannerModel(
            id: 'banner1',
            title: 'Personal Loans',
            description: 'Quick approval up to ₹25 Lakhs',
            image: 'assets/images/banners/personal_loan_banner.jpg',
            link: '#',
            sortOrder: 1,
            isActive: true,
          ),
          BannerModel(
            id: 'banner2',
            title: 'Business Loans',
            description: 'Grow your business with flexible financing',
            image: 'assets/images/banners/business_loan_banner.jpg',
            link: '#',
            sortOrder: 2,
            isActive: true,
          ),
          BannerModel(
            id: 'banner3',
            title: 'Home Loans',
            description: 'Make your dream home a reality',
            image: 'assets/images/banners/home_loan_banner.jpg',
            link: '#',
            sortOrder: 3,
            isActive: true,
          ),
          BannerModel(
            id: 'banner4',
            title: 'Car Loans',
            description: 'Drive your dream car today',
            image: 'assets/images/banners/car_loan_banner.jpg',
            link: '#',
            sortOrder: 4,
            isActive: true,
          ),
        ]);
      }
    }
  }
} 