import 'package:sober_driver_analog/domain/tutorial/models/tariff_model.dart';
import 'package:sober_driver_analog/domain/tutorial/repository/repository.dart';

class GetListTariff {
  final TutorialRepository repository;

  GetListTariff(this.repository);

  Future<List<TariffModel>> call () async {
    return repository.getListTariff();
  }
}