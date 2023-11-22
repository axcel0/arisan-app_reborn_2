import 'package:json_annotation/json_annotation.dart';

part 'nama_peserta.g.dart';

@JsonSerializable()
class NamaPeserta {
  final String idPeserta;
  final String namaPeserta;

  NamaPeserta({
    required this.idPeserta,
    required this.namaPeserta,
  });

  factory NamaPeserta.fromJson(Map<String, dynamic> json) => _$NamaPesertaFromJson(json);

  Map<String, dynamic> toJson() => _$NamaPesertaToJson(this);
}