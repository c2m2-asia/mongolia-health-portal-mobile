import 'package:c2m2_mongolia/mapfeature/detail_feature.dart';
import 'package:hive/hive.dart';
part '../hive/bookmark_model.g.dart';
@HiveType(typeId: 0)
class BookmarkItem {
  @HiveField(0)
  TitleDetail titleDetail;
  @HiveField(1)
  InfoDetail infoDetail;
  @HiveField(2)
  String serviceId;
  @HiveField(3)
  List<FeaturePair> list = [];

  BookmarkItem({this.titleDetail, this.infoDetail, this.serviceId, this.list});
}
