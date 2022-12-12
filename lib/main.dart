import 'package:calculo_imc_EduardoNeto/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCtOUeMj_34u91YiHxScjETgn5i8ryotS8",
      appId: "1:174430226592:android:6d13cc44c822529942a1c5",
      messagingSenderId: "174430226592",
      projectId: "calculdadoraeduardoneto",
    ),
  );
  runApp(MaterialApp(
    home: HomeScreen(),
    theme: ThemeData.light(),
  ));
}

String _result = "";

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Cadastre seus dados para gerar seu IMC';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
          backgroundColor: Colors.deepPurple,
        ),
        body: const MyCustomForm(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: Icon(Icons.arrow_back_ios_sharp),
          backgroundColor: Colors.deepPurple,
        ),
      ),
    );
  }
}

TextEditingController controllerweight = TextEditingController();
TextEditingController controllerheight = TextEditingController();
TextEditingController controllername = TextEditingController();

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  int? status;

  void sendData(double calculation, double weight, double height, String name, result) {
    final docImc = FirebaseFirestore.instance.collection('historico_de_calculadora').doc();
    docImc.set(
      {
        "altura": height,
        "peso": weight,
        "imc": calculation,
        "nome": name,
        "result": result,
        "id": docImc.id,
        "data": Timestamp.now()
      }
    );
  }

  void generatecalculation() {
    double weight = double.parse(controllerweight.text);
    double height = double.parse(controllerheight.text) / 100.0;
    double calculation = weight / (height * height);
    String name = controllername.text.toString();
    String result = calculation.toStringAsPrecision(2);

    setState(() {

      if (calculation < 18.6)
        result += " está Abaixo do peso";
      else if (calculation <= 25.0)
        result += " está no Peso ideal";
      else if (calculation <= 30.0)
        result += " está Levemente acima do peso";
      else if (calculation <= 35.0)
        result += " está com Obesidade";
      else
        result += " está com Obesidade +";
    });

    sendData(calculation, weight, height, name, result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: controllername,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.deepPurple, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.deepPurple),
              ),
              border: OutlineInputBorder(),
              labelText: 'Nome',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: controllerweight,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.deepPurple, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.deepPurple),
              ),
              border: OutlineInputBorder(),
              labelText: 'Peso',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: controllerheight,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.deepPurple, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.deepPurple),
              ),
              border: OutlineInputBorder(),
              labelText: 'Altura',
            ),
          ),
        ),
        Center(
          child: TextButton(
            style: TextButton.styleFrom(
              alignment: Alignment.center,
                backgroundColor: Colors.deepPurple,
                elevation: 0,
                shadowColor: Colors.green),
            child: Text(
              'Gerar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),

            onPressed: () {
              generatecalculation();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
              controllerweight.clear();
              controllerheight.clear();
              controllername.clear();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 36.0),
          child: Text(
            _result,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}


