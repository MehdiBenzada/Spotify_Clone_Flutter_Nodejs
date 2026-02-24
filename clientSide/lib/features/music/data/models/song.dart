class Song {
  final String name;
  final String artist;
  final String image;
  final String url;

  Song({required this.name, required this.artist, required this.image,required this.url});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      name: json['SongTitle'],
      artist: json['Artist'],
      image: json['Photo'],
      url: json['url']
    );
  }
}
