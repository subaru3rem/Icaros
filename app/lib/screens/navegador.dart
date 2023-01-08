import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hello/values/custom_colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';




class Navegador extends StatefulWidget {
  @override
  _Navegador createState() => _Navegador();
}
class _Navegador extends State<Navegador>{
  var _link = '';
  var _resposta = '';
  Map<String, String> _fav_temp = Map<String, String>();
  List<Widget> _fav = [Center()];
  var _request_state = true;
  Widget _fav_container = Center();
  Widget _stack =  Center();
  
 
  
  
  @override
  
  Widget build(BuildContext context) {  
    _get_fav();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Navegador"),
        shape: Border(
          bottom: BorderSide(
            color:custom_colors().secundary_color(),
            width: 2
          )
        ),
      ),
      body:  _stack = Stack(
          children: [Column(
          children: <Widget> [Container(
            margin: const EdgeInsets.all(40),
            child: TextField(
              onChanged: (text){_link = text;},
              style: const TextStyle(color: Colors.white),
              decoration:  InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color:custom_colors().secundary_color(), width: 0.0)
              ),
              enabledBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: custom_colors().secundary_color(), width: 0.0)
              ),
              border: const OutlineInputBorder(),
              labelText: 'Digite o link',
              labelStyle: TextStyle(color: custom_colors().secundary_color())
              ),
            )
            ),
            FloatingActionButton(
              heroTag: 'btn_search',
              onPressed: ()=>server(_link),
              child: const Icon(Icons.search),
            ),
            Center(
              heightFactor: 3,
              child: Text(
                _resposta,
                style: const TextStyle(fontSize: 30),)
            ),
            Expanded(
              child: ListView(
              padding: const EdgeInsets.all(8),
              children: _fav,
            )
            ),
            Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[Container(
        margin: const EdgeInsets.all(20),
        width: 300.0,
        height: 50.0,
        child: TextButton(
          onPressed: _set_fav,
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(custom_colors().secundary_color()),
          ),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text('Favoritos'),
              Icon(Icons.add),
            ]
          ),
        ),
      ),]
    ),
    ]
    ),
    _fav_container,]
    )
    );}
  
  void server(link) async {
      var url = Uri.http('192.168.10.50:5000');
      Map<String, dynamic> obj = {'navegador': link};
      final response = await http.post(url, body:jsonEncode(obj));
      setState(() {_resposta = response.body;});
  }
  void _set_fav(){
      var widget =
        FractionallySizedBox(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child:Container(
        color: const Color.fromARGB(122, 0, 0, 0),
        child: Center(child:Container(
          width: 300,
          height: 350,
          color: custom_colors().primary_color(),
          child: Column(
            children: [Container(
                height: 50,
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: custom_colors().secundary_color(), width: 2.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Adicionar Favorito',
                      style: TextStyle(
                        fontSize: 20
                      ),
                    )),
                    TextButton(
                      onPressed: _cancel_fav,
                      child: const Icon(Icons.close, color: Colors.white,),
                    )
            ])
            ),
            Container(
              margin: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child:TextField(
                    onChanged: (text){_fav_temp['nome'] = text;},
                    style: const TextStyle(color: Colors.white),
              decoration:  InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color:custom_colors().secundary_color(), width: 0.0)
              ),
              enabledBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: custom_colors().secundary_color(), width: 0.0)
              ),
              border: const OutlineInputBorder(),
              labelText: 'Nome do Site',
              labelStyle: TextStyle(color: custom_colors().secundary_color())
              ),
                  )),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child:TextField(
                    onChanged: (text){_fav_temp['link'] = text;},
                    style: const TextStyle(color: Colors.white),
                    decoration:  InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:custom_colors().secundary_color(), width: 0.0)
                    ),
                    enabledBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color: custom_colors().secundary_color(), width: 0.0)
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Url do site (link)',
                    labelStyle: TextStyle(color: custom_colors().secundary_color())
                    ),
                    )
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: TextButton(
                      onPressed: ()=>_save_fav(jsonEncode(_fav_temp)),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(custom_colors().secundary_color()),
                      ),
                      child: const Text('Salvar')
                      ),
                  )
                ],
              ),
            )
          ]
          ),
        )),
      )
      );
      setState(() {  
        _fav_container = Center(child:widget);});
  }
  void _cancel_fav(){
    setState(() {
      _fav_container = Center();
    });
  }
  void _save_fav(save) async{
    final prefs = await SharedPreferences.getInstance();
    List<String>? info = prefs.getStringList("favoritos");
    if (info == null) info = [];
    info.add(save);
    await prefs.setStringList('favoritos', info);
    _cancel_fav();
  }
  void state(info){
  _fav = <Widget>[];
  for(var site in info) {
      setState(() {
      var s = jsonDecode(site);
       _fav.add(
        Container(
        margin: const EdgeInsets.all(20),
        width: 200.0,
        height: 50.0,
        child: TextButton(
          onPressed: ()=>server(s['link']),
          onLongPress: _remove_fav_container,
          style:  TextButton.styleFrom(
            side: BorderSide(width: 2.0, color: custom_colors().secundary_color())
          ),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(s['nome'], style: TextStyle(color: custom_colors().secundary_color(), fontSize: 20),)
            ]
          ),
        ),
      )
      ); 
      });
    };;
}
  void _get_fav() async{
    if (_request_state){
    final pref = await SharedPreferences.getInstance();
    final List<String>? info = pref.getStringList('favoritos');
    if (_fav.length <2 ){
    state(info!);
  }}}
  void _remove_fav_container(){
    print('foi');
  }
}
