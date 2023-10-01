import 'package:sober_driver_analog/domain/firebase/localities/repository.dart';
class GetAvailableLocalities {
  final LocalitiesRepository repo;

  GetAvailableLocalities(this.repo);

  Future<List<String>> call () => repo.getAvailableLocalities();
}