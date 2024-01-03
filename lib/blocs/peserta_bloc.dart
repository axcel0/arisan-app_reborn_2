import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../nama_peserta.dart';

part 'peserta_event.dart';
part 'peserta_state.dart';

class PesertaBloc extends Bloc<PesertaEvent, PesertaState> {
  List<NamaPeserta> daftarPeserta = [];
  List<NamaPeserta> daftarPemenang = [];

  PesertaBloc() : super(PesertaInitial()) {
    on<AddNewPeserta>(_addNewPeserta);
    on<AddNewPemenang>(_addNewPemenang);
    on<LoadPeserta>(_loadPeserta);
    on<LoadPemenang>(_loadPemenang);
    on<DeleteAllPeserta>(_deleteAllPeserta);
    on<DeletePeserta>(_deletePeserta);
    on<DeletePemenang>(_deletePemenang);
    on<EditPeserta>(_editPeserta);
    on<EditPemenang>(_editPemenang);
    on<DeleteAllPemenang>(_deleteAllPemenang);
    on<ShowPeserta>(_showPeserta);
    on<ShowPemenang>(_showPemenang);
    on<ChangeTheme>(_changeTheme);
  }

  Future<void> _showPemenang(ShowPemenang event, Emitter<PesertaState> emit) async {
    emit(ListPemenangInitial(daftarPemenang));
  }

  Future<void> _showPeserta(ShowPeserta event, Emitter<PesertaState> emit) async {
    emit(ListPesertaInitial(daftarPeserta));
  }

  Future<void> _addNewPeserta(AddNewPeserta event, Emitter<PesertaState> emit) async {
    daftarPeserta.addAll([NamaPeserta(idPeserta: event.newIdPeserta, namaPeserta: event.newNamaPeserta)]);
    emit(ListPesertaInitial(daftarPeserta));
  }

  Future<void> _loadPeserta(LoadPeserta event, Emitter<PesertaState> emit) async {
    daftarPeserta.add(NamaPeserta(idPeserta: event.newIdPeserta, namaPeserta: event.newNamaPeserta));
  }

  Future<void> _loadPemenang(LoadPemenang event, Emitter<PesertaState> emit) async {
    daftarPemenang.add(NamaPeserta(idPeserta: event.idPeserta, namaPeserta: event.namaPeserta));
  }

  Future<void> _deleteAllPeserta(DeleteAllPeserta event, Emitter<PesertaState> emit) async {
    daftarPeserta.clear();
    emit(ListPesertaInitial(daftarPeserta));
  }

  Future<void> _deleteAllPemenang(DeleteAllPemenang event, Emitter<PesertaState> emit) async {
    daftarPemenang.clear();
    emit(ListPemenangInitial(daftarPemenang));
  }

  Future<void> _addNewPemenang(AddNewPemenang event, Emitter<PesertaState> emit) async {

    // Filtering daftar peserta
    for (var j in daftarPemenang) {
      daftarPeserta.removeWhere(((element) => element.idPeserta == j.idPeserta));
    }

    //randomize index
    Random random = Random();
    int randomNumber = random.nextInt(daftarPeserta.length);

    daftarPemenang.add(NamaPeserta(idPeserta: daftarPeserta[randomNumber].idPeserta, namaPeserta: daftarPeserta[randomNumber].namaPeserta));
    emit(ListPemenangInitial(daftarPemenang));
    emit(ShowPemenangInitial(daftarPeserta[randomNumber].idPeserta, daftarPeserta[randomNumber].namaPeserta));
  }

  Future<void> _deletePeserta(DeletePeserta event, Emitter<PesertaState> emit) async {
    daftarPeserta.removeWhere((element) => element.idPeserta == event.idPeserta);
    emit(ListPesertaInitial(daftarPeserta));
  }

  Future<void> _deletePemenang(DeletePemenang event, Emitter<PesertaState> emit) async {
    daftarPemenang.removeWhere((element) => element.idPeserta == event.idPeserta);
    emit(ListPemenangInitial(daftarPemenang));
  }

  Future<void> _editPeserta(EditPeserta event, Emitter<PesertaState> emit) async {
    var index = daftarPeserta.indexWhere((element) => element.idPeserta == event.oldIdPeserta && element.namaPeserta == event.oldNamaPeserta);
    if (index != -1) {
      daftarPeserta[index] = NamaPeserta(idPeserta: event.idPeserta, namaPeserta: event.namaPeserta);
    }
    emit(ListPesertaInitial(daftarPeserta));
  }

  Future<void> _editPemenang(EditPemenang event, Emitter<PesertaState> emit) async {
    var index = daftarPemenang.indexWhere((element) => element.idPeserta == event.oldIdPeserta && element.namaPeserta == event.oldNamaPeserta);
    if (index != -1) {
      daftarPemenang[index] = NamaPeserta(idPeserta: event.idPeserta, namaPeserta: event.namaPeserta);
    }
    emit(ListPemenangInitial(daftarPemenang));
  }

  //future change theme light or dark
  Future<void> _changeTheme(ChangeTheme event, Emitter<PesertaState> emit) async {
    emit(ChangeThemeState(event.isDark));
  }
  //future time stamp
  String getTimeStamp() {
    var now = DateTime.now();
    var time = '${now.hour}:${now.minute}';
    return time;
  }


}