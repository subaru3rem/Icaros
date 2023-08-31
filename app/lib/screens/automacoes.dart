import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icaros/values/values.dart';
import 'package:icaros/botomappbarwidgets.dart';
import 'package:icaros/screens/leitor.dart';

class Automacoes extends StatefulWidget{
  const Automacoes({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _Automacoes createState() => _Automacoes();
}
class _Automacoes extends State<Automacoes>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Automações'),
        shape:  const Border(
          bottom: BorderSide(
            color:CustomColors.secundary_color,
            width: 2
          )
        ),
      ),
      body: const AutomacoesWidgets(),
      bottomNavigationBar: const BottomAppBarWidgets(),
    );
  }
}
class AutomacoesWidgets extends StatefulWidget{
  const AutomacoesWidgets({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _AutomacoesWidgets createState() => _AutomacoesWidgets();
}
class _AutomacoesWidgets extends State<AutomacoesWidgets>{
  Widget _energia = const Center();
  // ignore: non_constant_identifier_names
  bool _energia_check = true;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Container(
            margin: const EdgeInsets.all(20),
            width: 300.0,
            height: 50.0,
            decoration: BoxDecoration(border: Border.all(color: CustomColors.secundary_color)),
            child: TextButton(
              onPressed: energia,
              child:const Text(
                    'Energia',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  )
              ),
            ),
            _energia,
            Container(
              margin: const EdgeInsets.all(20),
              width: 300.0,
              height: 50.0,
              decoration: BoxDecoration(border: Border.all(color: CustomColors.secundary_color)),
              child: TextButton(
                onPressed: leitura,
                child:const Text(
                  'Leitura',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                )
              ),
            ),
          ],
        ),
    );
  }
  void leitura(){
    Navigator.push(
      context,
       MaterialPageRoute(builder: (context) => const LeitorState())
    );
  }
  void energia(){
    if (_energia_check){
    setState(() {    
    _energia = SizedBox(
    width: 300.0,
    height: 80.0,
    child:Row(
    children: [
      Expanded(
        flex: 3,
        child:Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(color: CustomColors.secundary_color)),
        child: TextButton(
          onPressed: () => server({'command':'shutdown','parameter':'/s', 'time':getShudownTimer()}),
          child: const Icon(Icons.power_settings_new, color: Colors.white),
        ),
      )),
      Expanded(
        flex: 3,
        child:Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(color: CustomColors.secundary_color)),
        child: TextButton(
          onPressed: () => server({'shutdown':'/r'}),
          child: const Icon(Icons.restart_alt,color: Colors.white),
        ),
      )
      ),
      Expanded(
        flex: 3,
        child:Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(color: CustomColors.secundary_color)),
        child: TextButton(
          onPressed: () => server({'shutdown':'/h'}),
          child: const Icon(Icons.nights_stay, color: Colors.white),
        ),
      )
      ),
    ],
  )
  );
  });
  _energia_check = false;}
  else{
    setState(() {
    _energia = const Center();
    _energia_check = true;
    });
  }
  }
  void server(obj) async {
      var url = Uri.http(Ips.ip, "/shutdown");
      await http.post(url, body:obj);
  }
  int getShudownTimer(){
    return 0;
  }
}
