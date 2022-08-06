class Photos {
  final int kind;
  final String imageUrl;

  const Photos({
    required this.kind,
    required this.imageUrl,
  });

  factory Photos.fromJson(Map<String, dynamic> json) {
    return Photos(
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
