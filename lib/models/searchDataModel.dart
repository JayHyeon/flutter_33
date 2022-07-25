class SearchData {
  int? id;
  String? docUrl;
  String? imageUrl;
  String? displaySitename;
  String? thumbnailUrl;
  String? collection;
  int? width;
  int? height;
  String? datetime;
  bool? wish;

  SearchData(
      {this.id,
      this.docUrl,
      this.imageUrl,
      this.displaySitename,
      this.thumbnailUrl,
      this.collection,
      this.width,
      this.height,
      this.datetime,
      this.wish});

  SearchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    docUrl = json['doc_url'];
    imageUrl = json['image_url'];
    displaySitename = json['display_sitename'];
    thumbnailUrl = json['thumbnail_url'];
    collection = json['collection'];
    width = json['width'];
    height = json['height'];
    datetime = json['datetime'];
    wish = json['wish'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doc_url'] = this.docUrl;
    data['image_url'] = this.imageUrl;
    data['display_sitename'] = this.displaySitename;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['collection'] = this.collection;
    data['width'] = this.width;
    data['height'] = this.height;
    data['datetime'] = this.datetime;
    data['wish'] = this.wish;
    return data;
  }

  Map<String, dynamic> toJsonFromInsert() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doc_url'] = this.docUrl;
    data['image_url'] = this.imageUrl;
    data['display_sitename'] = this.displaySitename;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['collection'] = this.collection;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}
