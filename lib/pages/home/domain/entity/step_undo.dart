enum StepType {
  add, clear
}
class StepUndo {
  List<String>? steps;

  StepUndo({this.steps});

  Map<String, dynamic> toJson() => {
    "steps": steps,
  };

  void setValue({List<int>? blockIjArr}){
    if(blockIjArr != null && blockIjArr.length == 4){
      steps = ['${blockIjArr[0]},${blockIjArr[1]},${blockIjArr[2]},${blockIjArr[3]}'];
    }
  }

  void addValue({List<List<int>>? blockIjArrs}){
    if(blockIjArrs != null){
      for(var arr in blockIjArrs){
        if(arr.length == 4){
          var value = '${arr[0]},${arr[1]},${arr[2]},${arr[3]}';
          if(steps != null){
            steps!.add(value);
          } else {
            steps = [value];
          }
        }
      }
    }
  }


  List<List<int>> iJBlockIdSteps(){
    if(steps == null) {
      return [];
    }
    List<List<int>> arr = [];
    for (var element in steps!) {
      var split = element.split(',');
      if(split.length == 4){
        var items = [int.parse(split[0]), int.parse(split[1]), int.parse(split[2]), int.parse(split[3])];
        arr.add(items);
      }
    }
    return arr;
  }

}