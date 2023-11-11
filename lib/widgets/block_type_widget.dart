import 'package:flutter/material.dart';
import 'package:tool_eat_all_game/pages/home/domain/entity/block_type_enum.dart';
import 'package:tool_eat_all_game/utils/constants.dart';
import 'package:tool_eat_all_game/widgets/text_padding.dart';

class BlockTypeWidget extends StatelessWidget {
  final BlockType blockType;
  final double size;
  final bool isDisableBlock;
  final double opacity;
  final bool isDrew;
  final String? idCoupleTelepot;
  const BlockTypeWidget({
    Key? key,
    required this.blockType,
    this.size = sizeBlock,
    this.isDisableBlock = false,
    this.opacity = 1.0,
    this.isDrew = false,
    this.idCoupleTelepot,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (opacity < 0.99) {
      return Opacity(
        opacity: opacity,
        child: _blockView(),
      );
    }
    return _blockView();
  }

  Widget _blockView() {
    return Container(
      width: size,
      height: size,
      decoration: _decoration(),
      alignment: _alignment(),
      child: isDisableBlock ? const SizedBox() : _child(),
    );
  }

  Alignment _alignment() {
    if (blockType == BlockType.edgeTopLeft) {
      return Alignment.topLeft;
    }
    if (blockType == BlockType.edgeTopRight) {
      return Alignment.topRight;
    }
    if (blockType == BlockType.edgeBottomLeft) {
      return Alignment.bottomLeft;
    }
    if (blockType == BlockType.edgeBottomRight) {
      return Alignment.bottomRight;
    }
    return Alignment.center;
  }

  Widget _child() {
    if (blockType == BlockType.normal) {
      return const SizedBox();
    }
    if (blockType == BlockType.telepot) {
      if(idCoupleTelepot == null || idCoupleTelepot!.isEmpty){
        return Image.asset(
          'assets/black_hole.png',
          width: size * 0.6,
        );
      }
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/black_hole.png',
            width: size * 0.5,
          ),
          Align(
            alignment: Alignment.topRight,
            child: TextPadding(
              '$idCoupleTelepot',
              padding: const EdgeInsets.all(2),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.26),
            ),
          )
        ],
      );
    }
    var imageAssets = '';
    double _sizeImage = size * 0.5;
    if (blockType == BlockType.start) {
      _sizeImage = size * 0.95;
      imageAssets = 'start_point.png';
    } else if (blockType == BlockType.one) {
      _sizeImage = size * 0.5;
      imageAssets = 'location_2.png';
    } else if (blockType == BlockType.magnet) {
      _sizeImage = size * 0.6;
      imageAssets = 'magnet.png';
    } else if (blockType == BlockType.pushTop) {
      imageAssets = 'arrow_up.png';
    } else if (blockType == BlockType.pushRight) {
      imageAssets = 'arrow_right.png';
    } else if (blockType == BlockType.pushBottom) {
      imageAssets = 'arrow_down.png';
    } else if (blockType == BlockType.pushLeft) {
      imageAssets = 'arrow_left.png';
    } else if (blockType == BlockType.edgeTopLeft) {
      _sizeImage = size * 0.45;
      imageAssets = 'trial_tl.png';
    } else if (blockType == BlockType.edgeTopRight) {
      _sizeImage = size * 0.45;
      imageAssets = 'trial_tr.png';
    } else if (blockType == BlockType.edgeBottomLeft) {
      _sizeImage = size * 0.45;
      imageAssets = 'trial_bl.png';
    } else if (blockType == BlockType.edgeBottomRight) {
      _sizeImage = size * 0.45;
      imageAssets = 'trial_br.png';
    } else if (blockType == BlockType.bomb) {
      _sizeImage = size * 0.6;
      imageAssets = 'bomb2.png';
    } else if (blockType == BlockType.tank) {
      _sizeImage = size * 0.6;
      imageAssets = 'tank.png';
    }
    return Image.asset(
      'assets/$imageAssets',
      width: _sizeImage,
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      border: Border.all(
          width: 0.5, color: isDisableBlock ? Colors.white : Colors.red),
      color: colorBg(),
    );
  }

  Color colorBg() {
    if (isDrew && blockType != BlockType.start) {
      return Colors.blue;
    }
    return Colors.black;
  }
}
