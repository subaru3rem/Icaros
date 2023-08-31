import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icaros/values/values.dart';
import 'package:icaros/botomappbarwidgets.dart';

class MultimidiaState extends StatefulWidget{
  const MultimidiaState({super.key});
  @override 
  Multimidia createState() => Multimidia();
}
class Multimidia extends State<MultimidiaState>{
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multmidia"),
        shape:  const Border(
          bottom: BorderSide(
            color:CustomColors.secundary_color,
            width: 2
          )
        ),
      ),
      body: const  MultimidiaWidgetsState(),
      bottomNavigationBar: const BottomAppBarWidgets(),
     );
  }
}
class MultimidiaWidgetsState extends StatefulWidget{
  const MultimidiaWidgetsState({super.key});
  @override
  MultimidiaWidgets createState()=> MultimidiaWidgets();
}
class MultimidiaWidgets extends State<MultimidiaWidgetsState>{
  // ignore: non_constant_identifier_names
  bool _resume_control = false;
  // ignore: non_constant_identifier_names
  void midia_command (command)async{
    var url = Uri.http(Ips.ip,"/music");
      Map<String, dynamic> obj = {'tecla': command};
      await http.post(url, body:obj);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 300,
              height: 200,
              padding: const EdgeInsets.all(3),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 60),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: CustomColors.primary_color,
                boxShadow: const [BoxShadow(
                    color: CustomColors.secundary_color,
                    spreadRadius: 1,
                    blurRadius: 20,
                  )],
              ),
              child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder:(context) => const YouTubeState()));
                },
                child: const Text(
                  'Youtube',
                  style: TextStyle(
                    fontSize: 70,
                    color: Colors.white
                  ),),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            height: 80,
            width: 80,
            child:FloatingActionButton(
            heroTag: 'prevtrack',
            onPressed: () => midia_command('prevtrack'),
            child: const Icon(Icons.skip_previous)
          )),
          Container(
            margin: const EdgeInsets.all(10),
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
            margin: const EdgeInsets.all(10),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            height: 80,
            width: 80,
            child:FloatingActionButton(
            heroTag: 'volumedown',
            onPressed: ()=> midia_command('volumedown'),
            child: const Icon(Icons.volume_down),
          )),
          Container(
            margin: const EdgeInsets.all(10),
            height: 80,
            width: 80,
            child:FloatingActionButton(
            heroTag: 'volumemute',
            onPressed: ()=> midia_command('volumemute'),
            child: const Icon(Icons.volume_off),
          )),
          Container(
            margin: const EdgeInsets.all(10),
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
class YouTubeState extends StatefulWidget{
  const YouTubeState({super.key});
  @override 
  YouTube createState() => YouTube();
}
class YouTube extends State<YouTubeState>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Youtube"),
        shape:  const Border(
          bottom: BorderSide(
            color:CustomColors.secundary_color,
            width: 2
          )
        ),
      ),
      body: const YoutubeWidgetsState(),
      bottomNavigationBar: const BottomAppBarWidgets(),
      );
  }
}
class YoutubeWidgetsState extends StatefulWidget{
  const YoutubeWidgetsState({super.key});
  @override
  YoutubeWidgets createState() => YoutubeWidgets();
}
class YoutubeWidgets extends State<YoutubeWidgetsState>{
  List<Map<String, dynamic>> items = [];
  String pesquisa = '';
  List<Widget> videosWidgets = <Widget>[const Center()];
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
              suffixIcon: IconButton(onPressed:()=>search(pesquisa), icon: const Icon(Icons.done), color: CustomColors.secundary_color),
              focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color:CustomColors.secundary_color, width: 0.0)
              ),
              enabledBorder:  const OutlineInputBorder(
                borderSide: BorderSide(color: CustomColors.secundary_color, width: 0.0)
              ),
              labelText: 'Search:',
              labelStyle: const TextStyle(color: CustomColors.secundary_color,),
              ),
          )),
          Expanded(
            child:ListView(
              children: !_loading
              ?videosWidgets
              :[Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 130),
                child:const CircularProgressIndicator(color: CustomColors.secundary_color,)
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
    addVideos(items);
    }
  }
  void addVideos(items){
    List<Widget> videos = [];
    for(var video in items){
    var id = video['id']['videoId'];
    var info = video['snippet'];
    videos.add(
      SizedBox(
        height: 100,
        child:TextButton(
          style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(CustomColors.primary_color)),
          onPressed: ()=>openVideo(id),
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
    }
    setState((){
      videosWidgets = videos;
      _loading = false;
    });
  }
  void openVideo(id) async{
    Scaffold.of(context).showBottomSheet((BuildContext context){
      return const Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            color: CustomColors.secundary_color,
          )
        ),
      );
    });
    var url = Uri.http(Ips.ip, "/navegador");
    Map<String, dynamic> obj = {'link': 'https://music.youtube.com/watch?v=$id'};
    await http.post(url, body:obj);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}