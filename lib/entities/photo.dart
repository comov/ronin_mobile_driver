enum PhotoKind {
  before,
  after,
}

Map<int, String> photoKindMap = {
  PhotoKind.before.index: "До",
  PhotoKind.after.index: "После",
};

class Photo {
  final int kind;
  final String imageUrl;

  const Photo({
    required this.kind,
    required this.imageUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      kind: json["kind"],
      imageUrl: json["image_url"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "kind": kind,
      "image_url": imageUrl,
    };
  }

  @override
  String toString() {
    return "$imageUrl (#$kind)";
  }
}
