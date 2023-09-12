abstract class SearchBottomSheetEvent {

}

class SearchAddressByTextEvent extends SearchBottomSheetEvent {
  final String text;

  SearchAddressByTextEvent(this.text);
}