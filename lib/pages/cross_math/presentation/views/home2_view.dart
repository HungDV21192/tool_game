import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tool_eat_all_game/pages/cross_math/presentation/controllers/home2_controller.dart';
import 'package:tool_eat_all_game/pages/cross_math/presentation/views/button_bottom_view.dart';
import 'package:tool_eat_all_game/pages/cross_math/presentation/views/map_number_view.dart';
import 'package:tool_eat_all_game/utils/constants.dart';
import 'package:tool_eat_all_game/utils/ui.dart';

class Home2View extends GetView<Home2Controller> {
  const Home2View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: TextField(
          controller: controller.textController,
          decoration: InputDecoration(
            labelText: 'Nhập data level',
            labelStyle: TextStyle(color: Colors.black54),
            fillColor: Colors.red,
          ),
        ),
        actions: [
          SizedBox(
            child: Center(
              child: ElevatedButton(
                child: Text(
                  'CLEAR',
                  style: TextStyle(fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                  elevation: 0,
                  minimumSize: Size(60, 40),
                ),
                onPressed: () {
                  controller.textController.clear();
                },
              ),
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          SizedBox(
            child: Center(
              child: ElevatedButton(
                child: Text(
                  'Parse Level',
                  style: TextStyle(fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                  elevation: 0,
                  minimumSize: Size(80, 40),
                ),
                onPressed: () {
                  controller.ParseLevelFromTextInput();
                },
              ),
            ),
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() => Text(
                        controller.messeageAction.value,
                        style: const TextStyle(
                            fontSize: 15, color: Colors.redAccent),
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                  Stack(
                    children: [
                      ColoredBox(
                        color: Colors.grey.withOpacity(0.1),
                        child: Container(
                          margin: EdgeInsets.all(16),
                          width: matrixMaxCol * sizeBlock,
                          height: matrixMaxRow * sizeBlock * 1.05,
                          color: Colors.white,
                          child: Obx(() => GridView.count(
                                crossAxisCount: matrixMaxCol,
                                shrinkWrap: true,
                                children: List.generate(
                                    controller.numberTopList.value.length,
                                    (index) {
                                  var text =
                                      controller.numberTopList.value[index];
                                  return InkWell(
                                    onTap: () {
                                      controller.playSoundButtonClick();
                                      if (controller
                                              .numberIndexTopSelect.value ==
                                          index) {
                                        controller.numberIndexTopSelect.value =
                                            -1;
                                      } else {
                                        controller.numberIndexTopSelect.value =
                                            index;
                                      }
                                      controller.numbersBoardInput.value = "";
                                      controller.numberIndexBottomSelect.value =
                                          -1;
                                      controller
                                          .CheckPhepCongTruNhanCHiaBangEmptyShowHide();
                                      controller.CheckSugressQuest();
                                    },
                                    child: NumberMapButton(
                                      text: text,
                                      numberFilled: controller
                                          .mapNumberCorrectFilled.value[index],
                                      type: controller.numberTypeByText(text),
                                      isSelected: controller
                                              .numberIndexTopSelect.value ==
                                          index,
                                    ),
                                  );
                                }),
                              )),
                        ),
                      ),
                      SizedBox(
                        width: matrixMaxCol * sizeBlock + 32,
                        height: 16,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(matrixMaxCol, (index) {
                            return SizedBox(
                              height: 16,
                              width: sizeBlock,
                              child: Center(
                                child: Text(
                                  '$index',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 16,
                        child: SizedBox(
                          width: 16,
                          height: matrixMaxRow * sizeBlock * 1.05 + 32,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(matrixMaxRow, (index) {
                              return SizedBox(
                                height: sizeBlock,
                                width: 16,
                                child: Center(
                                  child: Text(
                                    '$index',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      )
                    ],
                  ),
                  const Divider(),
                  Obx(() => Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 12 * 70,
                            height: 150,
                            alignment: Alignment.center,
                            child: GridView.count(
                                crossAxisCount: 14,
                                children: List.generate(
                                    controller.numberBottomList.value.length,
                                    (index) {
                                  return InkWell(
                                    onTap: () {
                                      controller.playSoundButtonClick();
                                      if (controller
                                              .numberIndexBottomSelect.value ==
                                          index) {
                                        controller
                                            .numberIndexBottomSelect.value = -1;
                                      } else {
                                        controller.numberIndexBottomSelect
                                            .value = index;
                                      }
                                      controller.numberIndexTopSelect.value =
                                          -1;
                                      controller.numbersBoardInput.value = "";
                                      controller.checkSaveNumberClickBottomChoosed();
                                    },
                                    child: NumberButton(
                                      width: 34,
                                      number:
                                          controller.numberBottomList.value[index],
                                      isSelected: controller
                                              .numberIndexBottomSelect.value ==
                                          index,
                                    ),
                                  );
                                })),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Next if number >= 100", style: TextStyle(color: Colors.purple),),
                              Obx(() =>  Checkbox(
                                checkColor: Colors.redAccent,
                                value: controller.autoNextCellBottomNumber100.value,
                                onChanged: (bool? value) {
                                  if(value != null){
                                    controller.autoNextCellBottomNumber100.value = value;
                                  }
                                },
                              )),
                              const SizedBox(height: 12,),
                              ElevatedButton(
                                child: Text(
                                  'XÓA SỐ BOTTOM',
                                  style: TextStyle(fontSize: 13),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.purple,
                                  elevation: 0,
                                  minimumSize: Size(64, 64),
                                ),
                                onPressed: () {
                                  if (controller.numberIndexBottomSelect.value >=
                                      0) {
                                    controller.inputNumber(none_number);
                                  }
                                },
                              )
                            ],
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      child: Text(
                        'XÓA CELL TOP',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                        elevation: 0,
                        minimumSize: Size(130, 54),
                      ),
                      onPressed: () {
                        if (controller.numberIndexTopSelect.value >= 0) {
                          controller.inputTopNumber(NumberType.None);
                        }
                        controller.playSoundButtonClick();
                      },
                    ),
                    Spacer(),
                    const Text("NOT_SUGGESS", style: TextStyle(color: Colors.black),),
                    Obx(() =>  Checkbox(
                      checkColor: Colors.redAccent,
                      value: controller.isNotSuggessCheck.value,
                      onChanged: (bool? value) {
                        if(value != null){
                          controller.isNotSuggessCheck.value = value;
                        }
                      },
                    )),
                    const SizedBox(
                      width: 24,
                    ),
                    const Text("SOUND", style: TextStyle(color: Colors.black),),
                    Obx(() =>  Checkbox(
                      checkColor: Colors.redAccent,
                      value: controller.isSoundEffectEnable.value,
                      onChanged: (bool? value) {
                        if(value != null){
                          controller.isSoundEffectEnable.value = value;
                        }
                      },
                    )),
                    const SizedBox(
                      width: 24,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.inputTopNumber(NumberType.Empty);
                        controller.showMessageToUserNow("đã chọn ô trống!");
                        if (controller.numberIndexTopSelect.value >= 0) {
                          int prevI = controller.numberIndexTopSelect.value - 1;
                          int nextI = controller.numberIndexTopSelect.value + 1;
                          if (prevI >= 0 &&
                              nextI < controller.numberTopList.value.length) {
                            if (controller.numberTopList.value[prevI] !=
                                    noneTileCellText &&
                                controller.numberTopList.value[nextI] ==
                                    noneTileCellText) {
                              controller.numberIndexTopSelect.value = nextI;
                            } else if (controller.numberTopList.value[prevI] ==
                                    noneTileCellText &&
                                controller.numberTopList.value[nextI] !=
                                    noneTileCellText) {
                              controller.numberIndexTopSelect.value = prevI;
                            }
                            controller
                                .CheckPhepCongTruNhanCHiaBangEmptyShowHide();
                          }
                        }
                      },
                      child: Obx(() => !controller.isShowEmptyCell.value
                          ? const SizedBox()
                          : NumberMapButton(
                              type: NumberType.Empty,
                            )),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Obx(
                      () => !controller.isCongTruNhanChiaBang.value
                          ? const SizedBox()
                          : _buttonCongTruNhanChiaBang(NumberType.Cong),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Obx(() => !controller.isCongTruNhanChiaBang.value
                        ? const SizedBox()
                        : _buttonCongTruNhanChiaBang(NumberType.Tru)),
                    const SizedBox(
                      width: 16,
                    ),
                    Obx(() => !controller.isCongTruNhanChiaBang.value
                        ? const SizedBox()
                        : _buttonCongTruNhanChiaBang(NumberType.Nhan)),
                    const SizedBox(
                      width: 16,
                    ),
                    Obx(() => !controller.isCongTruNhanChiaBang.value
                        ? const SizedBox()
                        : _buttonCongTruNhanChiaBang(NumberType.Chia)),
                    const SizedBox(
                      width: 16,
                    ),
                    Obx(() => !controller.isCongTruNhanChiaBang.value
                        ? const SizedBox()
                        : _buttonCongTruNhanChiaBang(NumberType.Bang)),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: number0T09PadWidget(),
                    ),
                    Expanded(
                      flex: 2,
                      child: topNextBottomPrevCellWidget(),
                    ),
                    const SizedBox(width: 12,),
                  ],
                ),
                ElevatedButton(
                  child: Text(
                    'RESET tất cả',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple,
                    elevation: 0,
                    minimumSize: Size(150, 60),
                  ),
                  onPressed: () {
                    controller.reset();
                  },
                ),
                const SizedBox(
                  height: 48,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                      child: Text(
                        'Giải LEVEL NÀY',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        elevation: 0,
                        minimumSize: Size(150, 60),
                      ),
                      onPressed: () {
                        controller.GiaiLevel();
                      },
                    ),
                    Spacer(),
                    ElevatedButton(
                      child: Text(
                        'BACK Lại',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo,
                        elevation: 0,
                        minimumSize: Size(100, 40),
                      ),
                      onPressed: () {
                        controller.BACKLai();
                      },
                    ),
                    const SizedBox(width: 16,),
                    ElevatedButton(
                      child: Text(
                        'Giải TIẾP',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo,
                        elevation: 0,
                        minimumSize: Size(100, 40),
                      ),
                      onPressed: () {
                        controller.GiaiTiep();
                      },
                    ),
                    const SizedBox(width: 16,)
                  ],
                ),
                const SizedBox(
                  height: 48,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 12),
                    Flexible(
                      child: Obx(() => Text(
                            controller.dataLevelOutPut.value,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          )),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.copy,
                        color: Colors.black,
                      ), // Thay 'example' bằng tên biểu tượng bạn muốn sử dụng
                      onPressed: () async {
                        if (controller.dataLevelOutPut.value.length > 10) {
                          controller.playSoundButtonClick();
                          controller.exportDataLevelBeforeCopy();
                          await Clipboard.setData(ClipboardData(
                              text: controller.dataLevelOutPut.value));
                          controller
                              .showMessageToUserNow("Copied successfully");

                        }
                      },
                    ),
                    const SizedBox(width: 24),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void PreviousCellClick() {
    if (controller.numberIndexBottomSelect.value > 0) {
      controller.playSoundButtonClick();
      controller.numberIndexBottomSelect.value--;
      controller.numbersBoardInput.value = "";
      controller.CheckPhepCongTruNhanCHiaBangEmptyShowHide();
      return;
    }
    if (controller.numberIndexTopSelect.value > 0) {
      controller.playSoundButtonClick();
      controller.numberIndexTopSelect.value--;
      controller.numbersBoardInput.value = "";
      controller.CheckPhepCongTruNhanCHiaBangEmptyShowHide();
      return;
    }
  }

  void TopCellTitleMapClick() {
    if (controller.numberIndexTopSelect.value >= 0) {
      controller.playSoundButtonClick();
      var topCellIndex = controller.numberIndexTopSelect.value - matrixMaxCol;
      if(topCellIndex >= 0){
        controller.numberIndexTopSelect.value = topCellIndex;
        controller.numbersBoardInput.value = "";
        controller.CheckPhepCongTruNhanCHiaBangEmptyShowHide();
      }
    }
  }
  void BottomCellTitleMapClick() {
    if (controller.numberIndexTopSelect.value >= 0) {
      controller.playSoundButtonClick();
      var BottomCellIndex = controller.numberIndexTopSelect.value + matrixMaxCol;
      if(BottomCellIndex < matrixMaxCol * matrixMaxRow){
        controller.numberIndexTopSelect.value = BottomCellIndex;
        controller.numbersBoardInput.value = "";
        controller.CheckPhepCongTruNhanCHiaBangEmptyShowHide();
      }
    }
  }
  void NextCellClick() {
    if (controller.numberIndexBottomSelect.value >= 0 &&
        controller.numberIndexBottomSelect.value <
            controller.numberBottomList.value.length - 1) {
      controller.playSoundButtonClick();
      controller.numberIndexBottomSelect.value++;
      controller.numbersBoardInput.value = "";
      controller.CheckPhepCongTruNhanCHiaBangEmptyShowHide();
      return;
    }
    if (controller.numberIndexTopSelect.value >= 0 &&
        controller.numberIndexTopSelect.value <
            controller.numberTopList.value.length - 1) {
      controller.playSoundButtonClick();
      controller.numberIndexTopSelect.value++;
      controller.numbersBoardInput.value = "";
      controller.CheckPhepCongTruNhanCHiaBangEmptyShowHide();
      return;
    }
  }

  Widget _buttonNumber(int number) {
    return ElevatedButton(
      child: Text(
        '$number',
        style: TextStyle(fontSize: 24),
      ),
      style: ElevatedButton.styleFrom(elevation: 0, minimumSize: Size(70, 70) //
          ),
      onPressed: () {
        controller.inputNumber(number);
      },
    );
  }

  Widget _buttonCongTruNhanChiaBang(NumberType numberType) {
    var text = "+";
    if (numberType == NumberType.Tru) {
      text = "-";
    } else if (numberType == NumberType.Nhan) {
      text = PhepNhanText;
    } else if (numberType == NumberType.Chia) {
      text = PhepChiaText;
    } else if (numberType == NumberType.Bang) {
      text = "=";
    }
    return ElevatedButton(
      child: Text(
        text,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
          primary: Colors.teal, elevation: 0, minimumSize: Size(56, 56) //
          ),
      onPressed: () {
        controller.inputTopNumber(numberType);
        if (controller.numberIndexTopSelect.value >= 0) {
          int prevI = controller.numberIndexTopSelect.value - 1;
          int nextI = controller.numberIndexTopSelect.value + 1;
          if (prevI >= 0 && nextI < controller.numberTopList.value.length) {
            if (controller.numberTopList.value[prevI] != noneTileCellText &&
                controller.numberTopList.value[nextI] == noneTileCellText) {
              controller.numberIndexTopSelect.value = nextI;
            } else if (controller.numberTopList.value[prevI] ==
                    noneTileCellText &&
                controller.numberTopList.value[nextI] != noneTileCellText) {
              controller.numberIndexTopSelect.value = prevI;
            }
            controller.CheckPhepCongTruNhanCHiaBangEmptyShowHide();
          }
        }
      },
    );
  }

  Widget number0T09PadWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buttonNumber(1),
            const SizedBox(
              width: 24,
            ),
            _buttonNumber(2),
            const SizedBox(
              width: 24,
            ),
            _buttonNumber(3),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buttonNumber(4),
            const SizedBox(
              width: 24,
            ),
            _buttonNumber(5),
            const SizedBox(
              width: 24,
            ),
            _buttonNumber(6),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buttonNumber(7),
            const SizedBox(
              width: 24,
            ),
            _buttonNumber(8),
            const SizedBox(
              width: 24,
            ),
            _buttonNumber(9),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buttonNumber(0),
          ],
        ),
        const SizedBox(
          height: 48,
        ),
      ],
    );
  }

  Widget topNextBottomPrevCellWidget() {
    return Container(
      width: 200,
      height: 200,
      margin: const EdgeInsets.only(bottom: 100),
      child: Stack(
        children: [
          Positioned(
            top: 60,
            left: 0,
            child: ElevatedButton(
              child: Text(
                'PREV',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.brown,
                  minimumSize: Size(64, 48) //
                  ),
              onPressed: () {
                PreviousCellClick();
              },
            ),
          ),
          Positioned(
            top: 60,
            right: 0,
            child: ElevatedButton(
              child: Text(
                'NEXT',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.deepOrangeAccent,
                  minimumSize: Size(64, 48) //
                  ),
              onPressed: () {
                NextCellClick();
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 64,
            child: ElevatedButton(
              child: Text(
                'TOP',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.indigo,
                  minimumSize: Size(64, 48) //
                  ),
              onPressed: () {
                TopCellTitleMapClick();
              },
            ),
          ),
          Positioned(
            top: 120,
            left: 48,
            child: ElevatedButton(
              child: Text(
                'BOTTOM',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.deepPurple,
                  minimumSize: Size(64, 48) //
                  ),
              onPressed: () {
                BottomCellTitleMapClick();
              },
            ),
          ),
        ],
      ),
    );
  }
}
