import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';
import '../models/videojuego_model.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  CollectionReference get _col => _db.collection(AppConstants.juegosCollection);

  Future<List<Videojuego>> getAll() async {
    final snap = await _col.orderBy('creado', descending: true).get();
    return snap.docs.map(Videojuego.fromDoc).toList();
    }

  Future<void> add(Videojuego v) => _col.add(v.toMap());
  Future<void> update(Videojuego v) => _col.doc(v.id).update(v.toMap());
  Future<void> delete(String id) => _col.doc(id).delete();

  Future<List<Videojuego>> filter({
    GameType? tipo,
    AgeRating? edad,
    bool? soloAdultos,
    bool? soloMenores18,
  }) async {
    // Para mantenerlo simple, descargamos todo y filtramos en cliente.
    final all = await getAll();
    return all.where((g) {
      var ok = true;
      if (tipo != null) ok &= g.tipo == tipo;
      if (edad != null) ok &= g.edad == edad;
      if (soloAdultos == true) ok &= g.edad.isAdultOnly;
      if (soloMenores18 == true) ok &= g.edad.isUnder18;
      return ok;
    }).toList(growable: false);
  }
}
