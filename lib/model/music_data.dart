class MusicData {
  final int musicId;
  final String musicName;
  final String musicNameKana;
  final String artistName;
  final String artistNameKana;
  final double average;
  final double max;
  final double min;
  final double latest;
  final double lastTime;
  final double twoTimesBefore;
  final String createDate;
  final String updateDate;

  const MusicData(
    this.musicId,
    this.musicName,
    this.musicNameKana,
    this.artistName,
    this.artistNameKana,
    this.average,
    this.max,
    this.min,
    this.latest,
    this.lastTime,
    this.twoTimesBefore,
    this.createDate,
    this.updateDate,
  );
}
