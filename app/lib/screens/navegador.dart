import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hello/values/custom_colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';




class Navegador extends StatefulWidget {
  @override
  _Navegador createState() => _Navegador();
}
class _Navegador extends State<Navegador>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Navegador"),
        shape: const Border(
          bottom: BorderSide(
            color:custom_colors.secundary_color,
            width: 2
          )
        ),
      ),
      body: Navegador_widgets(),
      );
  }
} 
class Navegador_widgets extends StatefulWidget{
  @override
  _Navegador_widgets createState() => _Navegador_widgets();
}
class _Navegador_widgets extends State<Navegador_widgets>{
  var _link = '';
  var _resposta = '';
  Map<String, String> _fav_temp = Map<String, String>();
  List<Widget> _fav = [Center()];
  bool _request_state = true;
  Widget _fav_container = Center();
  Widget _stack =  Center();
  
 
  
  
  @override
  
  Widget build(BuildContext context) {  
    _get_fav();
    return Column(
          children: <Widget> [
            Center(
              heightFactor: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Container(margin:const EdgeInsets.only(right: 15),child:const Icon(Icons.language, color: Colors.white, size: 60)),
                const Text('Navegar', style: TextStyle(fontSize: 30),)])
            ),
            Container(
            margin: const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 20),
            child: TextField(
              onChanged: (text){_link = text;},
              style: const TextStyle(color: Colors.white),
              decoration:  const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color:custom_colors.secundary_color, width: 0.0)
              ),
              enabledBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: custom_colors.secundary_color, width: 0.0)
              ),
              border: OutlineInputBorder(),
              labelText: 'Digite o link',
              labelStyle: TextStyle(color: custom_colors.secundary_color)
              ),
            )
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child:FloatingActionButton(
              heroTag: 'btn_search',
              onPressed: ()=>server(_link),
              child: const Icon(Icons.search),
            )),
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
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(custom_colors.secundary_color),
          ),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text('Favoritos', style: TextStyle(color:Colors.white, fontSize: 20),),
              Icon(Icons.add, color:Colors.white),
            ]
          ),
        ),
      ),]
    ),
    ]
    );}
  
  void server(link) async {
      var url = Uri.http('192.168.10.50:5000');
      Map<String, dynamic> obj = {'navegador': link};
      final response = await http.post(url, body:jsonEncode(obj));
      setState(() {_resposta = response.body;});
  }
  void _set_fav(){
            {
     Scaffold.of(context).showBottomSheet<void>(
            (BuildContext context) {
              
              return Center(child:Container(
          decoration: BoxDecoration(
            color: custom_colors.primary_color,
            borderRadius: BorderRadius.circular(10)
          ),
          width: 300,
          height: 350,
          child: Column(
            children: [Container(
                height: 50,
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: custom_colors.secundary_color, width: 2.0))),
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
            Center(child:Container(
              margin: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child:TextField(
                    onChanged: (text){_fav_temp['nome'] = text;},
                    style: const TextStyle(color: Colors.white),
              decoration:  const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color:custom_colors.secundary_color, width: 0.0)
              ),
              enabledBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: custom_colors.secundary_color, width: 0.0)
              ),
              border: OutlineInputBorder(),
              labelText: 'Nome do Site',
              labelStyle: TextStyle(color: custom_colors.secundary_color)
              ),
                  )),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child:TextField(
                    onChanged: (text){_fav_temp['link'] = text;},
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:custom_colors.secundary_color, width: 0.0)
                    ),
                    enabledBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color: custom_colors.secundary_color, width: 0.0)
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Url do site (link)',
                    labelStyle: TextStyle(color: custom_colors.secundary_color)
                    ),
                    )
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: TextButton(
                      onPressed: (){save_fav(jsonEncode(_fav_temp)); Navigator.pop(context);},
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(custom_colors.secundary_color),
                      ),
                      child: const Text('Salvar')
                      ),
                  )
                ],
              ),
            ))
          ]
          ),
        ),
      );;
              });}
          }
  void _cancel_fav(){
    Navigator.pop(context);                  
  }
  void save_fav(save) async{
    final prefs = await SharedPreferences.getInstance();
    List<String>? info = prefs.getStringList("favoritos");
    if (info == null) info = [];
    info.add(save);
    prefs.setStringList('favoritos', info);
    state(info);
  }
  void state(info){
  _fav = <Widget>[];
  setState(() {
    
  for(var site in info) {
      var s = jsonDecode(site);
       _fav.add(
        Container(
        margin: const EdgeInsets.all(20),
        width: 200.0,
        height: 50.0,
        child: TextButton(
          onPressed: ()=>server(s['link']),
          onLongPress: ()=>_remove_fav_container(s),
          style:  TextButton.styleFrom(
            side: BorderSide(width: 2.0, color: custom_colors.secundary_color)
          ),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(s['nome'], style: TextStyle(color: custom_colors.secundary_color, fontSize: 20),)
            ]
          ),
        ),
      )
      ); 
  };});
}
  void _get_fav() async{
    if (_request_state){
    final pref = await SharedPreferences.getInstance();
    final List<String>? info = pref.getStringList('favoritos');
    if (_fav.length <2 ){
    state(info!);
  }}}
  void _remove_fav_container(s){
    String name = s['nome'];
    var widget =
        FractionallySizedBox(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child:Container(
          color: const Color.fromARGB(122, 0, 0, 0),
          child: Center(
            child:Container(
              width: 300,
              height: 150,
              decoration: BoxDecoration(
                color: custom_colors.primary_color,
                borderRadius: BorderRadius.circular(20),
              ),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Text(
                    'Deseja remover $name dos favoritos?',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [Container(
                      margin: EdgeInsets.all(10),
                      child:TextButton(
                      onPressed: ()=>_dell_fav(s),
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(custom_colors.secundary_color),
                      ),
                      child: const Text('Sim'),
                    )),
                    Container(
                      margin: EdgeInsets.all(10),
                      child:TextButton(
                      onPressed: _cancel_fav,
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(custom_colors.secundary_color),
                      ),
                      child: const Text('Não')))
                  ],)
                ],
              ), 
            )
          )
        )
        );
      Scaffold.of(context).showBottomSheet<void>(
            (BuildContext context) {
              
              return widget;});
  }
  void _dell_fav(s) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? info = prefs.getStringList("favoritos");
    info?.remove(jsonEncode(s));
    await prefs.setStringList('favoritos', info!);
    _cancel_fav();
    state(info);
  }
}
