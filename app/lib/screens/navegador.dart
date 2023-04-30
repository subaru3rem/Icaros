import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Icaros/values/values.dart';
import 'package:Icaros/botomappbarwidgets.dart';
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
      bottomNavigationBar: const BottomAppBarWidgets(),
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
  List<Widget> _fav = [Center()];
  Map<String, String> _fav_temp = Map<String, String>();
  bool _request_state = true;
  Widget _fav_container = Center();
  Widget _stack =  Center();
  
  @override
  Widget build(BuildContext context) {  
    return Column(
          children: <Widget> [
            Container(
              margin: const EdgeInsets.only(top:50,bottom:50,right:20,left:20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: custom_colors.primary_color,
                boxShadow: const [BoxShadow(
                    color: custom_colors.secundary_color,
                    spreadRadius: 1,
                    blurRadius: 20,
                  )],
              ),
              child:Center(
              heightFactor: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Container(margin:const EdgeInsets.only(right: 15),child:const Icon(Icons.language, color: Colors.white, size: 60)),
                const Text('Navegar', style: TextStyle(fontSize: 30),)])
            )
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
              labelStyle: TextStyle(color: Colors.white)
              ),
            )
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top:20,bottom: 20),
                  child:FloatingActionButton(
                    heroTag: 'btn_search',
                    onPressed: ()=>serve(_link),
                    child: const Icon(Icons.search),
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(top:20,bottom: 20),
                  child:FloatingActionButton(
                    heroTag: 'bnt_fav',
                    onPressed: fav,
                    child: const Icon(Icons.star),
                  )
                ),
              ],
            )
    ]
    );}
  void fav(){
    get_fav();
    Scaffold.of(context).showBottomSheet(
      (BuildContext context){
        return Column(
          children:[
            const Expanded(child: Center()),
            Container(
              height: 400,
              decoration: const BoxDecoration(color: custom_colors.primary_color, borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
              child:Expanded(child:Column(
                children: [
                  Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(vertical:15, horizontal: 25),
                    width: double.infinity,
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 5, color: custom_colors.secundary_color))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                      'Favoritos',
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(
                      height: 30,
                      width: 100,
                      child: TextButton(
                        onPressed: set_fav, 
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(custom_colors.secundary_color)),
                        child: Text('Add', style:TextStyle(color:Colors.white))
                      ) 
                    )
                      ],
                    )
                  ),
                  Expanded(
                    child: ListView(
                      children: _fav,
                    ),
                  )
                ],
              )
              )
              )
          ]
        );
      }
      );
  }
  void get_fav() async{
    if (_request_state){
    final pref = await SharedPreferences.getInstance();
    final List<String>? info = pref.getStringList('favoritos');
    if (info != null){
    state(info);
  }}}
  void set_fav(){
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
                      onPressed: fav,
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
              labelStyle: TextStyle(color: Colors.white)
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
                    labelStyle: TextStyle(color: Colors.white)
                    ),
                    )
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: TextButton(
                      onPressed: (){save_fav(jsonEncode(_fav_temp)); fav();},
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(custom_colors.secundary_color),
                      ),
                      child: const Text('Salvar', style: TextStyle(color:Colors.white),)
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
  void save_fav(save) async{
    final prefs = await SharedPreferences.getInstance();
    List<String>? info = prefs.getStringList("favoritos");
    if (info == null) info = [];
    info.add(save);
    prefs.setStringList('favoritos', info);
    state(info);
  }
  void state(info){
  _fav = [];
  setState(() {
    
  for(var site in info) {
      var s = jsonDecode(site);
       _fav.add(
        Container(
        height: 50.0,
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border.symmetric(horizontal: BorderSide(width: .5, color: custom_colors.secundary_color))
        ),
        child: TextButton(
          onPressed: ()=>serve(s['link']),
          onLongPress: ()=>remove_fav_container(s),
          child:Center(
            child:Text(s['nome'], style:const TextStyle(color:Colors.white, fontSize: 20),)
          ),
        ),
      )
      ); 
  };});
} 
  void remove_fav_container(s){
    String name = s['nome'];
    var widget =Center(
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
                      margin: const EdgeInsets.all(10),
                      child:TextButton(
                      onPressed: ()=>dell_fav(s),
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(custom_colors.secundary_color),
                      ),
                      child: const Text('Sim', style: TextStyle(color: Colors.white)),
                    )),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child:TextButton(
                      onPressed: fav,
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(custom_colors.secundary_color),
                      ),
                      child: const Text('Não', style: TextStyle(color: Colors.white),)))
                  ],)
                ],
              ), 
            )
          );
      Scaffold.of(context).showBottomSheet<void>(
            (BuildContext context) { 
              return widget;});
  }
  void dell_fav(s) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? info = prefs.getStringList("favoritos");
    info?.remove(jsonEncode(s));
    await prefs.setStringList('favoritos', info!);
    // ignore: use_build_context_synchronously
    fav();
  }
  void serve(link) async {
    Scaffold.of(context).showBottomSheet((BuildContext context){
      return const Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            color: custom_colors.secundary_color,
          )
        ),
      );
    });
    var url = Uri.http(Ips.ip,"/navegador");
    Map<String, dynamic> obj = {'link': "http://${link}"};
    http.post(url, body:obj);
    
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}
