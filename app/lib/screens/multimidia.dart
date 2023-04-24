import 'package:flutter/material.dart';
import 'package:Icaros/values/values.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Multimidia extends StatefulWidget{
  @override 
  _Multimidia createState() => _Multimidia();
}
class _Multimidia extends State<Multimidia>{
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multmidia"),
        shape:  const Border(
          bottom: BorderSide(
            color:custom_colors.secundary_color,
            width: 2
          )
        ),
      ),
     body: Multimidia_widgets()
     );
  }
}
class Multimidia_widgets extends StatefulWidget{
  @override
  _Multimidia_widgets createState()=> _Multimidia_widgets();
}
class _Multimidia_widgets extends State<Multimidia_widgets>{
  bool _resume_control = false;
  void midia_command (command)async{
    var url = Uri.http(Ips.ip,"/music");
      Map<String, dynamic> obj = {'tecla': command};
      final response = await http.post(url, body:obj);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child:Container(
              width: double.infinity,
              padding: const EdgeInsets.all(3),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: custom_colors.primary_color,
                boxShadow: const [BoxShadow(
                    color: custom_colors.secundary_color,
                    spreadRadius: 1,
                    blurRadius: 20,
                  )],
              ),
              child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder:(context) => youtube()));
                },
                child: const Text(
                  'Youtube',
                  style: TextStyle(
                    fontSize: 70,
                    color: Colors.white
                  ),),
              ),
            ),
          ),
          Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(20),
            height: 80,
            width: 80,
            child:FloatingActionButton(
            heroTag: 'prevtrack',
            onPressed: () => midia_command('prevtrack'),
            child: const Icon(Icons.skip_previous)
          )),
          Container(
            margin: const EdgeInsets.all(20),
            height: 80,
            width: 80,
            child:FloatingActionButton(
            heroTag: 'playpause',
            onPressed: (){
              setState(() {
                if(_resume_control){
                  _resume_control = false;
                }
                else{_resume_control=true;}
              });
              midia_command('playpause');
            },
            child: !_resume_control
            ?const Icon(Icons.pause)
            :const Icon(Icons.play_arrow)
          )),
          Container(
            margin: const EdgeInsets.all(20),
            height: 80,
            width: 80,
            child:FloatingActionButton(
            heroTag: 'nexttrack',
            onPressed: () => midia_command('nexttrack'),
            child: const Icon(Icons.skip_next),
          )),
        ],
      ),
      Row(
        
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            height: 80,
            width: 80,
            child:FloatingActionButton(
            heroTag: 'volumedown',
            onPressed: ()=> midia_command('volumedown'),
            child: const Icon(Icons.volume_down),
          )),
          Container(
            margin: const EdgeInsets.all(20),
            height: 80,
            width: 80,
            child:FloatingActionButton(
            heroTag: 'volumemute',
            onPressed: ()=> midia_command('volumemute'),
            child: const Icon(Icons.volume_off),
          )),
          Container(
            margin: const EdgeInsets.all(20),
            height: 80,
            width: 80,
            child:FloatingActionButton(
            heroTag: 'volumeup',
            onPressed: ()=> midia_command('volumeup'),
            child: const Icon(Icons.volume_up),
          )),
        ],
      )
      ]
      );
  }
}
class youtube extends StatefulWidget{
  @override 
  _youtube createState() => _youtube();
}
class _youtube extends State<youtube>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Youtube"),
        shape:  const Border(
          bottom: BorderSide(
            color:custom_colors.secundary_color,
            width: 2
          )
        ),
      ),
      body: youtube_widgets());
  }
}
class youtube_widgets extends StatefulWidget{
  @override
  _youtube_widgets createState() => _youtube_widgets();
}
class _youtube_widgets extends State<youtube_widgets>{
  List<Map<String, dynamic>> items = [];
  String pesquisa = '';
  List<Widget> videos = [Center()];
  bool _loading = false;
  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        children: [
          Image.asset('assets/images/youtube_logo.png',
            height: 250,

          ),
          SizedBox(
            height: 80,
            width: 250,
            child:TextField(
            onChanged: (text){pesquisa = text;},
            decoration: InputDecoration(
              suffixIcon: IconButton(onPressed:()=>search(pesquisa), icon: const Icon(Icons.done), color: custom_colors.secundary_color),
              focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color:custom_colors.secundary_color, width: 0.0)
              ),
              enabledBorder:  const OutlineInputBorder(
                borderSide: BorderSide(color: custom_colors.secundary_color, width: 0.0)
              ),
              labelText: 'Search:',
              labelStyle: const TextStyle(color: custom_colors.secundary_color,),
              ),
          )),
          Expanded(
            child:ListView(
              children: !_loading
              ?videos
              :[Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 130),
                child:const CircularProgressIndicator(color: custom_colors.secundary_color,)
                )],
            )
          )
            ],
          )
    );
  }
  void search(q) async{
    setState(() { _loading = true;});
    String key = 'AIzaSyAgoawOdtelKk4pwCEbm-n_5iLa7B-Russ';
    var url = Uri.https('www.googleapis.com','/youtube/v3/search',{'part':'snippet','q':q,'key':key, 'maxResults':'10', 'type':'video'});
    final response = await http.get(url);
     if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    List<dynamic> items = data['items'];
    add_videos(items);
    }
  }
  void add_videos(items){
    List<Widget> _videos = [];
    for(var video in items){
    var id = video['id']['videoId'];
    var info = video['snippet'];
    _videos.add(
      Container(
        height: 100,
        child:TextButton(
          style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(custom_colors.primary_color)),
          onPressed: ()=>open_video(id),
          child:Row(
          children:[
            Image.network(info['thumbnails']['default']['url']),
            Expanded(child:Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child:Text(info['title'],softWrap: true,style: const TextStyle(color: Colors.white),)
            ))
          ]
        )
        )
      )
    );
    };
    setState((){
      videos = _videos;
      _loading = false;
    });
  }
  void open_video(id) async{
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
    var url = Uri.http(Ips.ip, "/navegador");
    Map<String, dynamic> obj = {'link': 'https://music.youtube.com/watch?v=$id'};
    final response = await http.post(url, body:obj);
    Navigator.pop(context);
  }
}