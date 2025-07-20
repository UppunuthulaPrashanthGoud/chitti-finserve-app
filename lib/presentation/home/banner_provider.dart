import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/banner_repository.dart';
import '../../data/model/banner_model.dart';

final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  return BannerRepository();
});
 
final bannerListProvider = FutureProvider<BannerListModel>((ref) async {
  return await BannerRepository.loadBanners();
}); 