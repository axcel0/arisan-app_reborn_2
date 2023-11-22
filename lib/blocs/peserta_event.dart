part of 'peserta_bloc.dart';

abstract class PesertaEvent {}

class AddNewPeserta extends PesertaEvent {
  final String newIdPeserta;
  final String newNamaPeserta;
  AddNewPeserta(this.newIdPeserta, this.newNamaPeserta);
}

class ChangeTheme extends PesertaEvent {
  final bool isDark;
  ChangeTheme(this.isDark);
}

class AddNewPemenang extends PesertaEvent {}

class LoadPeserta extends PesertaEvent {
  final String newIdPeserta;
  final String newNamaPeserta;
  LoadPeserta(this.newIdPeserta, this.newNamaPeserta);
}

class LoadPemenang extends PesertaEvent {
  final String idPeserta;
  final String namaPeserta;
  LoadPemenang(this.idPeserta, this.namaPeserta);
}

class DeleteAllPeserta extends PesertaEvent {}

class DeletePeserta extends PesertaEvent {
  final String idPeserta;
  DeletePeserta(this.idPeserta);
}

class DeletePemenang extends PesertaEvent {
  final String idPeserta;
  DeletePemenang(this.idPeserta);
}

class EditPeserta extends PesertaEvent {
  final String idPeserta;
  final String namaPeserta;
  final String oldIdPeserta;
  final String oldNamaPeserta;

  EditPeserta(this.idPeserta, this.namaPeserta, this.oldIdPeserta, this.oldNamaPeserta);
}

class EditPemenang extends PesertaEvent {
  final String idPeserta;
  final String namaPeserta;
  final String oldIdPeserta;
  final String oldNamaPeserta;

  EditPemenang(this.idPeserta, this.namaPeserta, this.oldIdPeserta, this.oldNamaPeserta);
}

class DeleteAllPemenang extends PesertaEvent {}

class ShowPeserta extends PesertaEvent {}

class ShowPemenang extends PesertaEvent {}