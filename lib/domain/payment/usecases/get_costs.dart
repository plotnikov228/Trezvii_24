import '../repository/repostitory.dart';

class GetCosts {
  final PaymentRepository repository;

  GetCosts(this.repository);

  Future<double> call({bool inCity = true, bool outCity = false}) async {
    return repository.getCosts(inCity: inCity, outCity: outCity);
  }
}