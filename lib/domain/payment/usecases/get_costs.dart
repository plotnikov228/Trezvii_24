import '../models/tariff.dart';
import '../repository/repostitory.dart';

class GetCosts {
  final PaymentRepository repository;

  GetCosts(this.repository);

  Future<double> call(Tariff tariff, {bool getHourPrice = false, getKmPrice = false, bool getStartPrice = false, bool getPriceOfFirstHours = false}) async {
    return repository.getCosts(tariff,
        getHourPrice: getHourPrice,
        getKmPrice: getKmPrice,
        getStartPrice: getStartPrice,
    getPriceOfFirstHours: getPriceOfFirstHours);
  }
}
