import 'package:sober_driver_analog/domain/tutorial/models/tariff_model.dart';

abstract class TutorialRepository {

  Future<List<TariffModel>> getListTariff();
}