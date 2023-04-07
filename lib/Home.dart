import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/helper/AnotacaoHelper.dart';
import 'package:minhas_anotacoes/model/Anotacao.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _idController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  var _db = AnotacaoHelper();
  List<Note> _Notes = <Note>[];

  _displayRegistrationScreen() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Adicionar Anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Title", hintText: "type title..."),
                ),
                TextField(
                  controller: _descriptionController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Description",
                      hintText: "type Description..."),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  //salvar
                  _saveNote();
                  Navigator.pop(context);
                },
                child: Text("Save"),
              )
            ],
          );
        });
  }

  recoverNote() async {
    List recoveredNotes = await _db.recoverNote();
    List<Note> temporaryList = <Note>[];
    for (var item in recoveredNotes) {
      Note note = Note.fromMap(item, item);
      temporaryList.add(note);
    }

    setState(() {
      _Notes = temporaryList;
    });
    temporaryList;

    print("Lista anotacoes: " + recoveredNotes.toString());
  }

  _saveNote() async {
    String id = _idController.text;
    String title = _titleController.text;
    String description = _descriptionController.text;

    // print("atual date: " + DateTime.now().toString());
    Note note =
        Note(int.parse(id), title, description, DateTime.now().toString());
    int results = await _db.saveNote(note);
    print("save Notes: " + results.toString());

    _titleController.clear();
    _descriptionController.clear();

    recoverNote();
  }

  @override
  void initState() {
    super.initState();
    recoverNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _Notes.length,
              itemBuilder: (context, index) {
                final Note = _Notes[index];

                return Card(
                  child: ListTile(
                    title: Text(Note.title),
                    subtitle: Text("${Note.data} - ${Note.description}"),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          _displayRegistrationScreen();
        },
      ),
    );
  }
}
