import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elesafe_app/features/alert/models/alert_data_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // reference to collection
  CollectionReference get alerts => _db.collection('Ele-safe');

  // add new alert
  Future<void> addAlert(AlertDataModel alert) async {
    await alerts.doc(alert.id).set(alert.toJson());
  }

  // stream alerts (live updates)
  Stream<List<AlertDataModel>> getAlerts() {
    return alerts.snapshots().map((snapshot) {
      return snapshot.docs.map(
            (doc) => AlertDataModel.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        ),
      ).toList();
    });
  }
}
