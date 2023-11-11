import 'package:get/get.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/block_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:tool_eat_all_game/widgets/block_type_widget.dart';
import 'package:tool_eat_all_game/widgets/text_padding.dart';

class IntroBlocksView extends StatelessWidget {
  const IntroBlocksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.9,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          itemCard(BlockType.start),
                          itemCard(BlockType.normal),
                          itemCard(BlockType.one),
                          itemCard(BlockType.magnet),
                          itemCard(BlockType.pushTop),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          itemCard(BlockType.pushRight),
                          itemCard(BlockType.pushBottom),
                          itemCard(BlockType.pushLeft),
                          itemCard(BlockType.edgeTopLeft),
                          itemCard(BlockType.edgeTopRight),

                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          itemCard(BlockType.edgeBottomLeft),
                          itemCard(BlockType.edgeBottomRight),
                          itemCard(BlockType.telepot),
                          itemCard(BlockType.bomb),
                          itemCard(BlockType.tank),
                        ],
                      ),
                    ),
                  ],
                )),
                Container(
                  width: double.maxFinite,
                  height: 4,
                  color: Colors.black12,
                ),
                const SizedBox(
                  height: 32,
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 12.0,
                      backgroundColor: Colors.red,
                      textStyle: const TextStyle(color: Colors.white)),
                  child: const TextPadding(
                    'ĐÓNG',
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemCard(BlockType type) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              BlockTypeWidget(blockType: type),
              const SizedBox(
                width: 24,
              ),
              Flexible(
                  child: Text(
                type.intro,
                style: const TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.bold),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
