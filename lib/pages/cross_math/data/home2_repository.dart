import 'package:tool_eat_all_game/pages/home/domain/entity/block_type_enum.dart';


class Home2Repository implements IHome2Repository {
  Home2Repository({required this.provider});
  final IHome2Provider provider;

  @override
  Future<List<BlockType>> getCases() async {
    throw Exception();
  }
}