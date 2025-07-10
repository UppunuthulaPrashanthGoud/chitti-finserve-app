import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/banner_model.dart';

class BannerRepository {
  static Future<BannerListModel> loadBanners() async {
    try {
      final String response = await rootBundle.loadString('assets/json/banners.json');
      final data = await json.decode(response);
      final bannerList = BannerListModel.fromJson(data);
      return bannerList;
    } catch (e, stackTrace) {
      // Fallback hardcoded banners
      
      // Fallback hardcoded banners
      return BannerListModel(banners: [
        BannerModel(
          id: 'banner1',
          title: 'Personal Loans',
          subtitle: 'Quick approval up to ₹25 Lakhs',
          image: 'assets/images/banners/personal_loan_banner.jpg',
          color: '#005DFF',
          action: 'Apply Now',
        ),
        BannerModel(
          id: 'banner2',
          title: 'Business Loans',
          subtitle: 'Grow your business with flexible financing',
          image: 'assets/images/banners/business_loan_banner.jpg',
          color: '#FF6B35',
          action: 'Learn More',
        ),
        BannerModel(
          id: 'banner3',
          title: 'Home Loans',
          subtitle: 'Make your dream home a reality',
          image: 'assets/images/banners/home_loan_banner.jpg',
          color: '#4CAF50',
          action: 'Calculate EMI',
        ),
        BannerModel(
          id: 'banner4',
          title: 'Car Loans',
          subtitle: 'Drive your dream car today',
          image: 'assets/images/banners/car_loan_banner.jpg',
          color: '#9C27B0',
          action: 'Get Quote',
        ),
      ]);
    }
  }
} 