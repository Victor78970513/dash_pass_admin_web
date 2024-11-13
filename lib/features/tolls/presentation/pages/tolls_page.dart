import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_pass_web/config/shared_preferences/preferences.dart';
import 'package:dash_pass_web/features/tolls/presentation/widgets/toll_card_widget.dart';
import 'package:dash_pass_web/models/toll_model.dart';
import 'package:flutter/material.dart';

class TollsPage extends StatelessWidget {
  static const name = "/tolls-page";
  const TollsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rolId = Preferences().userRolId;
    return rolId == 1 ? const SuperAdminTollsPage() : const AdminTollsPage();
  }
}

class SuperAdminTollsPage extends StatelessWidget {
  const SuperAdminTollsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(244, 243, 253, 1),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('peajes').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No hay peajes disponibles.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              );
            }

            final tolls = snapshot.data!.docs;
            final peajesList = tolls.map((doc) {
              return TollModel.fromMap(doc.data() as Map<String, dynamic>);
            }).toList();

            return Wrap(
              alignment: WrapAlignment.spaceAround,
              children: List.generate(
                peajesList.length,
                (index) => TollCardWidget(
                  toll: peajesList[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AdminTollsPage extends StatelessWidget {
  const AdminTollsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Hello, World!'),
      ),
    );
  }
}
