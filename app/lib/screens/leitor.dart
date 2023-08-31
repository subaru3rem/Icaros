import 'dart:io' show File;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icaros/main.dart';
import 'package:icaros/values/values.dart';
import 'package:file_picker/file_picker.dart';

class LeitorState extends StatefulWidget {
  const LeitorState({super.key});
  @override
  LeitorBase createState() => LeitorBase();
}

class LeitorBase extends State<LeitorState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leitor")),
      body: const LeitorWidgetState(),
      floatingActionButton: const PressButton(),
    );
  }
}

class PressButton extends StatelessWidget {
  const PressButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          Scaffold.of(context).showBottomSheet((BuildContext context) {
            return const AddNovel();
          },
              backgroundColor: const Color.fromARGB(120, 0, 0, 0),
              enableDrag: true);
        },
        child: const Icon(Icons.add));
  }
}

class AddNovel extends StatefulWidget {
  final String name;
  final String link;
  final String image;
  const AddNovel({super.key, this.name = "", this.link = "", this.image = ""});
  @override
  AddNovelWidgets createState() => AddNovelWidgets();
}

class AddNovelWidgets extends State<AddNovel> {
  // ignore: non_constant_identifier_names
  TextEditingController nome_novel = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController link_novel = TextEditingController();
  // ignore: non_constant_identifier_names
  String file_name = '';
  File? file;
  Widget? image;
  CheckboxWidget checkbox = CheckboxWidget();

  @override
  void initState() {
    super.initState();
    if (widget.name.isNotEmpty && widget.link.isNotEmpty) {
      nome_novel.text = widget.name;
      link_novel.text = widget.link;
    }
    if (widget.image.isNotEmpty) {
      image = Image.memory(base64.decode(widget.image));
      return;
    }
    setDefaultImage();
  }

  void setDefaultImage() {
    Widget button = TextButton(
        onPressed: getImg,
        child: const Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.no_photography, color: Colors.white),
            Text("No image")
          ]),
        ));
    image = button;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        color: CustomColors.primary_color,
        child: Column(
          children: [
            Container(
              height: 65,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              margin: const EdgeInsets.only(bottom: 30),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: CustomColors.secundary_color))),
              child: const Text(
                "Adicionar novel",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextField(
                  controller: nome_novel,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.secundary_color, width: 0.0)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.secundary_color, width: 0.0)),
                      border: OutlineInputBorder(),
                      labelText: 'Nome da Novel',
                      labelStyle: TextStyle(color: Colors.white)),
                )),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextField(
                  controller: link_novel,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.secundary_color, width: 0.0)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.secundary_color, width: 0.0)),
                      border: OutlineInputBorder(),
                      labelText: 'Link da novel',
                      labelStyle: TextStyle(color: Colors.white)),
                )),
            Center(
                child: Row(
              children: [checkbox, const Text("Traduzido")],
            )),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: CustomColors.secundary_color, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: image))),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: CustomColors.secundary_color),
                    color: CustomColors.primary_color),
                child: TextButton(
                  onPressed: saveNovel,
                  child: const Center(child: Text("Salvar")),
                ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    nome_novel.dispose();
    link_novel.dispose();
  }

  void getImg() async {
    FilePickerResult? filepick = await FilePicker.platform.pickFiles();
    if (filepick != null) {
      file = File(filepick.files.single.path.toString());
      setState(() {
        file_name = filepick.files.single.name.toString();
        image = TextButton(onPressed: getImg, child: Image.file(file!));
      });
    }
  }

  void saveNovel() async {
    Uri postUri = Uri.http(Ips.ip, "/api/novel");
    http.MultipartRequest request = http.MultipartRequest("POST", postUri);
    if (file != null) {
      http.MultipartFile postFile =
          await http.MultipartFile.fromPath('ImgNovel', file!.path);
      request.files.add(postFile);
    }
    request.fields["nome"] = nome_novel.text;
    request.fields["link"] = link_novel.text;
    request.fields["traduzido"] = checkbox.check!.checked.toString();
    var response = await request.send();
    if (response.statusCode != 200) {
      // ignore: use_build_context_synchronously
      Scaffold.of(context).showBottomSheet((BuildContext context) {
        return Center(
            child: Container(
          width: 300,
          height: 300,
          color: CustomColors.primary_color,
          child: const Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 100),
                  Text(
                    "Erro ao salvar a novel",
                    style: TextStyle(fontSize: 20),
                  ),
                ]),
          ),
        ));
      }, backgroundColor: const Color.fromARGB(120, 0, 0, 0), enableDrag: true);
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}

class LeitorWidgetState extends StatefulWidget {
  const LeitorWidgetState({super.key});
  @override
  LeitorWidget createState() => LeitorWidget();
}

class LeitorWidget extends State<LeitorWidgetState> {
  // ignore: non_constant_identifier_names
  List<Widget> list_novels = <Widget>[];
  @override
  void initState() {
    super.initState();
    getNovels();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: list_novels,
    );
  }

  void getNovels() async {
    Uri uri = Uri.http(Ips.ip, "/api/novel");
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      addNovel(response.body);
    }
  }

  // ignore: non_constant_identifier_names
  void addNovel(get_novels) {
    List<dynamic> novels = jsonDecode(get_novels);
    list_novels = <Widget>[];
    for (var element in novels) {
      Widget widget = TextButton(
          onPressed: () => openNovel(element),
          child: Column(children: [
            Expanded(child: Image.memory(base64.decode(element["img"]!))),
            Text(element["nome"])
          ]));
      list_novels.add(widget);
    }
    setState(() {});
  }

  void openNovel(data) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CapsNovelState(data: data)));
  }
}

class CapsNovelState extends StatefulWidget {
  const CapsNovelState({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  // ignore: no_logic_in_create_state
  CapsNovel createState() => CapsNovel(data: data);
}

class CapsNovel extends State<CapsNovelState> {
  CapsNovel({required this.data});
  List<CapState> caps = <CapState>[];
  final Map<String, dynamic> data;
  List<Map<String, dynamic>>? jsonData;
  bool filterLido = false;

  @override
  void initState() {
    super.initState();
    getNovelCaps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(data["nome"])),
      body: widgetsCaps(),
    );
  }

  Widget widgetsCaps() {
    return Center(
        child: ListView(
      children: [
        Padding(
            padding: const EdgeInsets.all(60),
            child: Image.memory(base64.decode(data["img"]))),
        Center(
          child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(data["nome"], style: const TextStyle(fontSize: 30))),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: filterCaps,
                child: Icon(
                  Icons.filter_alt,
                  color:
                      filterLido ? CustomColors.secundary_color : Colors.white,
                )),
            TextButton(
                onPressed: reOrderCaps, child: const Icon(Icons.swap_vert))
          ],
        ),
        ...caps
      ],
    ));
  }

  void getNovelCaps() async {
    caps.clear();
    Uri uri = Uri.http(
        Ips.ip, "/api/novel/caps", {"id_novel": data["id"].toString()});
    var response = await http.get(uri);
    if (response.statusCode != 200) {
      return;
    }
    jsonData = jsonDecode(response.body);
    for (Map<String, dynamic> i in jsonData!) {
      i["position"] = (caps.length + 1).toString();
      i["id_novel"] = data["id"];
      CapState widget = CapState(data: i);
      caps.add(widget);
    }
    setState(() {});
  }

  void reOrderCaps() {
    Iterable<CapState> tempList = caps.reversed;
    setState(() {
      caps = tempList.toList();
    });
  }

  void filterCaps() {
    filterLido = !filterLido;
    for (CapState cap in caps) {
      cap.widget.filterCap(filterLido);
    }
    setState(() {});
  }
}

class CapState extends StatefulWidget {
  CapState({super.key, required this.data});
  final dynamic data;
  final CapWidget widget = CapWidget();
  @override
  // ignore: no_logic_in_create_state
  CapWidget createState() => widget;
}

class CapWidget extends State<CapState> {
  Color? colorLido;
  Widget? returnWidget;
  @override
  void initState() {
    super.initState();
    colorLido = widget.data["lido"] ? Colors.grey : Colors.white;
    returnWidget = createButton();
  }

  @override
  Widget build(BuildContext context) {
    return returnWidget!;
  }

  void openCap(id) async {
    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OpenCap(id: id, name: widget.data["name"])));
  }

  void changeCap(id) async {
    Uri uri = Uri.http(Ips.ip, "/api/novel/caps", {"tipo": 0});
    var response = await http.put(uri, body: {"id": id.toString()});
    if (response.statusCode != 200) {
      changeCap(id);
    }
    widget.data['lido'] = true;
    setState(() {});
  }

  void changeCaps(String position, String idNovel) async {
    Uri uri = Uri.http(Ips.ip, "/api/novel/caps", {"tipo": 1});
    var response =
        await http.put(uri, body: {"position": position, "id_novel": idNovel});
    if (response.statusCode != 200) {
      changeCaps(position, idNovel);
    }
    widget.data['lido'] = true;
    setState(() {});
  }

  Widget createButton() {
    return Container(
      decoration: const BoxDecoration(
          border: Border.symmetric(
              horizontal:
                  BorderSide(color: CustomColors.secundary_color, width: 1))),
      height: 100,
      child: TextButton(
          onLongPress: () {
            changeCap(widget.data["id"]);
            setState(() {
              if (colorLido == Colors.white) {
                colorLido = Colors.grey;
                return;
              }
              colorLido = Colors.white;
            });
          },
          onPressed: () => openCap(widget.data["id"]),
          child: Text(
              widget.data["name"].replaceAll("\n\n", "").replaceAll("\n", " "),
              textAlign: TextAlign.start,
              style: TextStyle(color: colorLido))),
    );
  }

  void filterCap(filterLido) {
    if (widget.data["lido"] && filterLido) {
      setState(() {
        returnWidget = const Center();
      });
      return;
    }
    setState(() {
      returnWidget = createButton();
    });
  }
}

class OpenCap extends StatelessWidget {
  const OpenCap({super.key, required this.id, required this.name});
  final int id;
  final String name;

  BuildContext? get context => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder<String>(
          future: getText(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Exibe uma indicação de carregamento enquanto aguarda a resposta do Future
              return const CircularProgressIndicator(
                color: CustomColors.secundary_color,
              );
            } else if (snapshot.hasError) {
              // Exibe uma mensagem de erro se ocorrer um erro durante a chamada do Future
              return Text('Erro: ${snapshot.error}');
            } else {
              // Exibe o resultado do Future
              return Text(snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Future<String> getText() async {
    Uri uri = Uri.http(Ips.ip, "/api/novel/cap", {"id_cap": id.toString()});
    var response = await http.get(uri);
    if (response.statusCode != 200) {
      Navigator.pop(context!);
    }
    return response.body;
  }
}
