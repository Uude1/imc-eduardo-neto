import 'package:calculo_imc_EduardoNeto/main.dart';
import 'package:calculo_imc_EduardoNeto/tile_pesagens.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("historico_de_calculadora")
            .orderBy('data', descending: true)
            .snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            return ListView(
              children: snapshot.data!.docs.map((doc) => PesagemTile(doc)).toList(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp()));
        },
        child: Icon(Icons.queue_play_next),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
