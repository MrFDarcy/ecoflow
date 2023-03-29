import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoflow_v3/models/badges.dart';
import '../services/points.dart';

class UserBadges extends StatefulWidget {
  const UserBadges({Key? key}) : super(key: key);

  @override
  _UserBadgesState createState() => _UserBadgesState();
}

class _UserBadgesState extends State<UserBadges> {
  late int _points = 0;

  @override
  void initState() {
    super.initState();
    _getPoints();
  }

  Future<void> _getPoints() async {
    final points = await Points().getPoints();
    setState(() {
      _points = points;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Badges'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('badges')
            .orderBy(FieldPath.documentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final badges = snapshot.data!.docs
              .map((doc) => Badges.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          if (_points < 100) {
            return noBadges();
          } else {
            return badgeList(badges, _points);
          }
        },
      ),
    );
  }
}

Widget badgeList(List<Badges> badges, int _points) {
  return badges.isEmpty
      ? Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Text(
            'No badges yet!',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      : ListView.builder(
          itemCount: badges.length,
          itemBuilder: (context, index) {
            final badge = badges[index];

            return _points >= badge.range
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Image.network(
                        badge.imageUrl,
                        width: 60.0,
                        height: 60.0,
                      ),
                      title: Text(
                        badge.title ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(badge.description ?? ''),
                    ),
                  )
                : const SizedBox.shrink();
          },
        );
}

Widget noBadges() {
  return Container(
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.emoji_events_outlined,
          size: 80,
          color: Colors.grey,
        ),
        const SizedBox(height: 16),
        Text(
          'No badges yet',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Keep exploring and earn badges!',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}
