import '../repository/repository.dart';

class GetLocally {
  final MapRepository repository;

  GetLocally(this.repository);

  Future<String?> call () {
    return repository.getLocally();
  }
}