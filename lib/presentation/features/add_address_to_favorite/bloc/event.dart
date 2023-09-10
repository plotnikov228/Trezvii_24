abstract class AddAddressToFavoriteEvent {}

class OpenBottomSheetEvent extends AddAddressToFavoriteEvent {

}

class SearchAddressByTextEvent extends AddAddressToFavoriteEvent {
  final String text;

  SearchAddressByTextEvent(this.text);
}

class ConfirmAddAddressEvent extends AddAddressToFavoriteEvent {
  final String name;
  final String addressName;
  final String entrance;
  final String comment;

  ConfirmAddAddressEvent({required this.name, required this.addressName, required this.entrance, required this.comment});

}


