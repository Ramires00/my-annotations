import 'package:minhas_anotacoes/helper/AnotacaoHelper.dart';

 class Note{

  int id = 0;
  String title = "";
  String description = "";
  String data = "";


  Note(this.id, this.title, this.description, this.data);

    Note.fromMap(Map, map){

    id = map (AnotacaoHelper.columnId);
    title = map(AnotacaoHelper.columnTitle);
    description = map(AnotacaoHelper.columnDescription);
    data = map(AnotacaoHelper.columnData);

  }

  Map toMap(){

    Map<String, dynamic> map = {
      "title" : this.title,
      "description" : this.description,
      "data" : this.data,
    };

    return map;

  }

}