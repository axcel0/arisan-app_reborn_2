part of 'peserta_bloc.dart';

abstract class PesertaState {}

class PesertaInitial extends PesertaState {}

class ListPesertaInitial extends PesertaState {
  final List<NamaPeserta> listPeserta;

  ListPesertaInitial(this.listPeserta);
}

class ListPemenangInitial extends PesertaState {
  final List<NamaPeserta> listPemenang;

  ListPemenangInitial(this.listPemenang);
}

class ShowPemenangInitial extends PesertaState {
  final String newIdPeserta;
  final String newNamaPeserta;

  ShowPemenangInitial(this.newIdPeserta, this.newNamaPeserta);
}

class ChangeThemeState extends PesertaState {
  final bool isDark;
  ChangeThemeState(this.isDark);
}