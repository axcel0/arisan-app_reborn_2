import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arisan_app_reborn/nama_peserta.dart';
import 'cubit/theme_mode_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/peserta_bloc.dart';

class DataPeserta extends StatefulWidget {
  const DataPeserta({Key? key}) : super(key: key);

  @override
  State<DataPeserta> createState() => _DataPesertaState();
}

class _DataPesertaState extends State<DataPeserta> {

  late PesertaBloc pesertaBloc;
  List<NamaPeserta> pesertaList = [];
  List<NamaPeserta> pemenangList = [];

  @override
  void initState(){
    super.initState();
    pesertaBloc = BlocProvider.of<PesertaBloc>(context);
    pesertaBloc.add(DeleteAllPeserta());
    pesertaBloc.add(DeleteAllPemenang());
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<ThemeModeCubit>().toggleBrightness();
            },
            icon: BlocBuilder<ThemeModeCubit, ThemeMode>(
              builder: (context, state) {
                return state == ThemeMode.light ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode);
              },
            ),
          ),
        ],
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Participant List',),
      ),
      body: BlocBuilder<PesertaBloc, PesertaState>(
        builder: (context, state) {
          if (state is ListPesertaInitial && state.listPeserta.isNotEmpty) {
            return ListView.builder(
              itemCount: state.listPeserta.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                        //set border radius more than 50% of height and width to make circle
                      ),
                    title: Text(state.listPeserta[index].namaPeserta,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).primaryTextTheme.titleMedium!.color,
                    )),
                    subtitle: Text(state.listPeserta[index].idPeserta,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryTextTheme.titleMedium!.color,
                        )
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(context: context, builder: (context) => showEditDialog(state.listPeserta[index].idPeserta, state.listPeserta[index].namaPeserta));
                          },
                          icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              //add dialog to confirm delete
                              showDialog(context: context, builder: (context) => AlertDialog(
                                backgroundColor: Theme.of(context).colorScheme.brightness == Brightness.light ? Theme.of(context).cardColor : Theme.of(context).cardColor,
                                title: Text("Konfirmasi", textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.brightness == Brightness.light ? Theme.of(context).primaryTextTheme.titleMedium!.color : Theme.of(context).primaryTextTheme.titleMedium!.color),),
                                content: Text("Apakah anda yakin ingin menghapus data ini?", textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.brightness == Brightness.light ? Theme.of(context).primaryTextTheme.titleMedium!.color : Theme.of(context).primaryTextTheme.titleMedium!.color,)),
                                actions: [
                                  ElevatedButton(onPressed: () {
                                    Navigator.of(context).pop();
                                  }, child: Text("Batal", style: TextStyle(color: Theme.of(context).colorScheme.brightness == Brightness.light ? Theme.of(context).primaryColor : Colors.lightBlue,))),

                                  ElevatedButton(onPressed: () {
                                    Colors.white.withOpacity(0.8);
                                    setState(() {
                                      pesertaBloc.add(DeletePeserta(state.listPeserta[index].idPeserta));
                                      pesertaList.removeWhere((element) => element.idPeserta == state.listPeserta[index].idPeserta);
                                      updateSharedPreferences(pesertaList);
                                      Navigator.of(context).pop();
                                      Flushbar(
                                        backgroundColor: Colors.green,
                                        icon: const Icon(
                                          Icons.info_outline,
                                          color: Colors.white,
                                        ),
                                        title: "Success!",
                                        message: "Data berhasil dihapus",
                                        duration: const Duration(seconds: 2),
                                      ).show(context);
                                    });
                                  }, child: const Text("Hapus", style: TextStyle(color: Colors.red))),
                                   ],
                              ));
                        }, icon: const Icon(Icons.delete)),
                      ],
                    ),
                  ),
                );
              }
            );
          }else{
            return Center(
              child: Text("Data Peserta masih kosong",

                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).primaryTextTheme.titleMedium!.color),
              ),
            );
          }
        },
      ),
      //add floatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => showAddDialog());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  StatefulBuilder showEditDialog(String editId, String editNama) {
    var namaController = TextEditingController();
    var nikController = TextEditingController();

    var oldId = editId;
    var oldNama = editNama;

    nikController.text = editId;
    namaController.text = editNama;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.white : Theme.of(context).cardColor,
          title: SizedBox(
            height: 25,
            child: Text("Edit Data", textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.brightness == Brightness.light ? Theme.of(context).primaryTextTheme.titleMedium!.color : Theme.of(context).primaryTextTheme.titleMedium!.color,)),
          ),
          content: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("Nama", style: TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium!.color)),
                ),
                TextField(
                  style: TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium!.color),
                  controller: namaController,
                  decoration: InputDecoration(
                    hintText: "Masukkan Nama",
                    hintStyle: TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium!.color),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("NIK", style: TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium!.color)),
                ),
                TextField(
                  style: TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium!.color),
                  controller: nikController,
                  decoration: InputDecoration(
                    hintText: "Masukkan NIK",
                    hintStyle: TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium!.color),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: (namaController.text == oldNama && nikController.text == oldId)
                  ? null
                  : () {
                if (namaController.text.isEmpty || nikController.text.isEmpty) {
                  Navigator.of(context).pop();
                  Flushbar(
                    backgroundColor: Colors.red,
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    title: "Warning!",
                    message: "Data tidak boleh ada yang kosong",
                    duration: const Duration(seconds: 2),
                  ).show(context);
                } else if(pesertaList.any((element) => element.idPeserta == nikController.text && element.idPeserta != oldId)){
                  Navigator.of(context).pop();
                  Flushbar(
                    backgroundColor: Colors.red,
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    title: "Warning!",
                    message: "NIK sudah ada",
                    duration: const Duration(seconds: 2),
                  ).show(context);
                } else if(nikController.text.contains(RegExp(r'[a-zA-Z]'))){
                  Navigator.of(context).pop();
                  Flushbar(
                    backgroundColor: Colors.red,
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    title: "Warning!",
                    message: "NIK harus berupa angka",
                    duration: const Duration(seconds: 2),
                  ).show(context);
                } else {
                  pesertaBloc.add(EditPeserta(nikController.text, namaController.text, oldId, oldNama));
                  pesertaBloc.add(EditPemenang(nikController.text, namaController.text, oldId, oldNama));

                  var index = pesertaList.indexWhere((element) => element.idPeserta == oldId && element.namaPeserta == oldNama);
                  if (index != -1) {
                    pesertaList[index] = NamaPeserta(idPeserta: nikController.text, namaPeserta: namaController.text);
                  }

                  updateSharedPreferences(pesertaList);

                  if(pemenangList.any((element) => element.idPeserta == oldId)){
                    var indexPemenang = pemenangList.indexWhere((element) => element.idPeserta == oldId && element.namaPeserta == oldNama);
                    if (indexPemenang != -1) {
                      pemenangList[indexPemenang] = NamaPeserta(idPeserta: nikController.text, namaPeserta: namaController.text);
                    }
                  }

                  Navigator.of(context).pop();
                  Flushbar(
                    backgroundColor: Colors.green,
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    title: "Success!",
                    message: "Data berhasil diubah",
                    duration: const Duration(seconds: 2),
                  ).show(context);
                }
              },
              child: Text("Save", style: TextStyle(color: Theme.of(context).colorScheme.brightness == Brightness.light ? Theme.of(context).colorScheme.primary : Colors.lightBlue,)),
            ),
          ],
        );
      },
    );
  }

  AlertDialog showAddDialog() {
    var namaController = TextEditingController();
    var nikController = TextEditingController();

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.white : Theme.of(context).cardColor,
      title: SizedBox(
        height: 25,
        child: Text("Tambah Data", textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.brightness == Brightness.light ? Theme.of(context).primaryTextTheme.titleMedium!.color : Theme.of(context).primaryTextTheme.titleMedium!.color,)),
      ),
      content: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text("Nama", style: TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium!.color)),
            ),
             TextField(
               style: TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium!.color),
              controller: namaController,
              decoration: InputDecoration(
                hintText: "Masukkan Nama",
                hintStyle: TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium!.color),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text("NIK", style: TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium!.color)),
            ),
             TextField(
                style: TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium!.color),
              controller: nikController,
              decoration: InputDecoration(
                hintText: "Masukkan NIK",
                hintStyle: TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium!.color),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(onPressed: () {
          //check if the textfield is empty or not
        setState(() {
        if (namaController.text.isEmpty || nikController.text.isEmpty) {
          Navigator.of(context).pop();
          Flushbar(
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            title: "Warning!",
            message: "Data tidak boleh ada yang kosong",
            duration: const Duration(seconds: 2),
          ).show(context);
        }
        else {
          //if data already exist, notify user using snackbar from flushbar
          if(pesertaList.any((element) => element.idPeserta == nikController.text)){
            Navigator.of(context).pop();
            Flushbar(
              backgroundColor: Colors.red,
              icon: const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              title: "Warning!",
              message: "NIK sudah ada",
              duration: const Duration(seconds: 2),
            ).show(context);
          }
          //NIK must be numeric
          else if(nikController.text.contains(RegExp(r'[a-zA-Z]'))){
            Navigator.of(context).pop();
            Flushbar(
              backgroundColor: Colors.red,
              icon: const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              title: "Warning!",
              message: "NIK harus berupa angka",
              duration: const Duration(seconds: 2),
            ).show(context);
          }
          else{
            //if data not exist, add data to list and save it to shared preferences
            pesertaBloc.add(AddNewPeserta(nikController.text, namaController.text));
            saveSharedPreferences([NamaPeserta(idPeserta: nikController.text, namaPeserta: namaController.text)]);
            Navigator.of(context).pop();
            Flushbar(
              backgroundColor: Colors.green,
              icon: const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              title: "Success!",
              message: "Data berhasil ditambahkan",
              duration: const Duration(seconds: 2),
            ).show(context);
          }
        }
      });
    },
        child: Text("Save", style: TextStyle(color: Theme.of(context).colorScheme.brightness == Brightness.light ? Theme.of(context).colorScheme.primary : Colors.lightBlue,))),
      ],
    );
  }
  
  Future<void> saveSharedPreferences(List<NamaPeserta> listPeserta) async {
    pesertaList.addAll(listPeserta);
    List<Map<String, dynamic>> jsonList = pesertaList.map((obj) => obj.toJson()).toList();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("PesertaList", jsonList.map((e) => jsonEncode(e)).toList());
  }

  Future<void> updateSharedPreferences(List<NamaPeserta> listPeserta) async {
    pesertaList = listPeserta;
    List<Map<String, dynamic>> jsonList = pesertaList.map((obj) => obj.toJson()).toList();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("PesertaList", jsonList.map((e) => jsonEncode(e)).toList());

    // Dispatch an event to update the state
    pesertaBloc.add(UpdatePesertaList(pesertaList));
  }

  Future<void> updatePemenangSharedPreferences(List<NamaPeserta> listPeserta) async {
    pemenangList = listPeserta;
    List<Map<String, dynamic>> jsonList = pemenangList.map((obj) => obj.toJson()).toList();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("PemenangList", jsonList.map((e) => jsonEncode(e)).toList());
  }

  void loadData() async {
    pesertaList = await loadSharedPreferences();
    pemenangList = await loadPemenangSharedPreferences();
    for (var element in pesertaList) {
      pesertaBloc.add(LoadPeserta(element.idPeserta, element.namaPeserta));
    }

    for (var element in pemenangList) {
      pesertaBloc.add(LoadPemenang(element.idPeserta, element.namaPeserta));
    }
    pesertaBloc.add(ShowPemenang());
    pesertaBloc.add(ShowPeserta());
  }

  Future<List<NamaPeserta>> loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList("PesertaList") ?? [];
    return jsonList.map((e) => NamaPeserta.fromJson(jsonDecode(e))).toList();
  }

  Future<List<NamaPeserta>> loadPemenangSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList("PemenangList") ?? [];
    return jsonList.map((e) => NamaPeserta.fromJson(jsonDecode(e))).toList();
  }


}

