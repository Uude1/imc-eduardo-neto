import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PesagemTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  PesagemTile(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: 4.0,
          vertical: 4.0
      ),
      child: Column(
        children: [
          SizedBox(
            height: 2.0,
          ),
          Text(
            "Nome Cadastrado: ${snapshot.get('nome')} || Peso Cadastrado: ${snapshot.get("peso")} || Altura Cadastrada: ${snapshot.get("altura")}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 17.0
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "IMC = ${snapshot.get('result')} ",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      alignment: Alignment.bottomLeft,
                      backgroundColor: Colors.deepPurple,
                      elevation: 0,
                      shadowColor: Colors.green),
                  child: Text(
                    'Excluir',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),

                  onPressed: () {
                    deleteUser(snapshot.get('id'));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  static Future<void> deleteUser(String id) async {
    final calc = FirebaseFirestore.instance.collection(
        'historico_de_calculadora').doc(id);
    await calc.delete();
  }
}
