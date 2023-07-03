class NoteModel {
  int? id;
  String? content;

  NoteModel({
    this.id,
    this.content,
  });

  NoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    return data;
  }
}
