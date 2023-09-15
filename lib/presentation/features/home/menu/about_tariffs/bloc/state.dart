import '../../../../../../domain/payment/models/tariff.dart';
import '../../../../../utils/status_enum.dart';

class AboutTariffsState {
  final List<Tariff> tariffs;
  final Status status;
  AboutTariffsState( {this.status = Status.Success,this.tariffs = const[]});
}