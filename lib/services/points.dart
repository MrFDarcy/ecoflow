import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Points {
  Future<int> getPoints() async {
    final user = FirebaseAuth.instance.currentUser!;

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userDocRef = firestore.collection('users').doc(user.uid);

    int points = 0;
    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    Map<String, dynamic> data = userDocSnapshot.data() as Map<String, dynamic>;
    List<dynamic> actions = data['actions'] ?? [];
    int actionsLength = actions.length;

    List<dynamic> resources = data['resources'] ?? [];

    int resourcesLength = resources.length;

    points = actionsLength * 40 + resourcesLength * 15;

    return points;
  }
}
