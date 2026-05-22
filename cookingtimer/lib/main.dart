import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const Base());
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CookingTimer(),
    );
  }
}

class CookingTimer extends StatefulWidget {
  const CookingTimer({super.key});

  @override
  State<CookingTimer> createState() => _CookingTimerState();
}

class _CookingTimerState extends State<CookingTimer> {

  //カウント用
  late int _counter;
  int _setCount = 180;
  bool _countFlg = false;

  //タイマー内容変更
  String _timerMode = "Ramen";

  //タイマーの名前変更
  String _timerTitle = "カップ麵タイマー";

  bool _comp=false;

  Timer? _timer;

  //初期化
  @override
  void initState(){
    super.initState();

    _counter = 180;


  }

  String _formatTime(){

    String minutes = (_counter ~/ 60).toString().padLeft(2,'0');
    String seconds = (_counter % 60).toString().padLeft(2,'0');
    
    return '$minutes:$seconds';
  }

  //タイマー開始
  void startTimer(){
    if(_countFlg)return;

    _countFlg = true;
    
    _timer = Timer.periodic(
      Duration(seconds: 1), 
      (Timer timer){
        if(_counter >0){
          setState(() {
            _counter--;
          });
        }else{
          _comp = true;
          stopTimer();
        }
      }
    );
  }

  //タイマー停止
  void stopTimer(){
    _timer?.cancel();

    setState(() {
      _countFlg = false;
    });
  }

  //タイマーリセット
  void resetTimer(){
    stopTimer();

    setState(() {
      _comp=false;
      _counter = _setCount;
    });
  }

  @override
  void dispose(){
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_timerTitle),
        shape: Border(bottom: BorderSide(width: 1.0)),
      ),

      //サイドメニュー
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  Icon(Icons.schedule),
                  Center(
                    child: Text("タイマー切り替え"),
                  )
                ],
                
              )
            ),

            ListTile (
              title: Text("カップ麵用タイマー"),
              subtitle: Text("他のインスタント食品にも使えます"),
              onTap: (){
                setState(() {
                  _comp=false;
                  _timerMode = "Ramen";
                  _timerTitle = "カップ麵タイマー";
                  _setCount = 180;
                  resetTimer();
                  Navigator.pop(context);
                });
              },
            ),

            ListTile(
              title: Text("ゆで卵用タイマー"),
              subtitle: Text("沸騰したお湯から茹でた場合の時間"),
              onTap: (){
                setState(() {
                  _comp=false;
                  _timerMode = "boilEgg";     
                  _timerTitle = "ゆで卵タイマー";
                   _setCount = 360;
                  resetTimer();
                  Navigator.pop(context);
                });
              },
            ),

            ListTile(
              title: Text("茹で野菜用タイマー"),
              onTap: (){
                setState(() {
                  _comp=false;
                  _timerMode = "boilvegetable"; 
                  _timerTitle = "茹で野菜タイマー";
                  _setCount = 90;
                  resetTimer();
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
      

      //タイマーの中身
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //画像
            if(_timerMode=="Ramen" && _comp == false)...{
              Image.asset(
                "assets/food_cup_noodle_close_transparent.png",
                width: 100,
                height: 100,
              ),
            }else if(_timerMode == "Ramen" && _comp == true)...{
              Image.asset(
                "assets/food_cup_noodle_open_transparent.png",
                width: 100,
                height: 100,
              ),
            }else if(_timerMode == "boilEgg")...{
              Image.asset(
                "assets/egg_white_transparent.png",
                width: 100,
                height: 100,
              ),
            },
            
            
            //ボタン(動作)
            Text(_formatTime(),style: TextStyle(fontSize: 36),),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    startTimer();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)
                    )
                  ),
                  child: Text("スタート")
                ),
                SizedBox(width: 16,),
                ElevatedButton(
                  onPressed: (){
                    stopTimer();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)
                    )
                  ),
                  child: Text("ストップ"),
                ),
                SizedBox(width: 16,),
                ElevatedButton(
                  onPressed: (){
                    resetTimer();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)
                    )
                  ),
                  child: Text("リセット")
                ),
              ],
            ),

            //ボタン(時間設定)
            SizedBox(height: 16,),
            if(_timerMode == 'Ramen')...{
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //時間変更
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        _comp=false;
                        _counter = 180;
                        _setCount = 180;
                        stopTimer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)
                      )
                    ),
                    child: Text("03:00")
                  ),
                  SizedBox(width: 16,),
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        _comp=false;
                        _counter = 240;
                        _setCount = 240;
                        stopTimer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)
                      )
                    ),
                    child: Text("04:00")
                  ),
                  SizedBox(width: 16,),
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        _comp=false;
                        _counter = 300;
                        _setCount = 300;
                        stopTimer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)
                      )
                    ),
                    child: Text("05:00")
                  ),
                ],
              ),
            }else if(_timerMode == "boilEgg")...{
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //時間変更
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        _counter = 360;
                        _setCount = 360;
                        stopTimer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)
                      )
                    ),
                   child: Text("半生")
                  ),
                  SizedBox(width: 16,),
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        _counter = 480;
                        _setCount = 480;
                        stopTimer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)
                      )
                    ),
                    child: Text("半熟")
                  ),
                  SizedBox(width: 16,),
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        _counter = 720;
                        _setCount = 720;
                        stopTimer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)
                      )
                    ),
                    child: Text("固ゆで")
                  ),
                ],
              ),
            }else if(_timerMode == "boilvegetable")...{
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //時間変更
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        _counter = 90;
                        _setCount = 90;
                        stopTimer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)
                      )
                    ),
                   child: Text("葉野菜")
                  ),
                  SizedBox(width: 16,),
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        _counter = 900;
                        _setCount = 900;
                        stopTimer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)
                      )
                    ),
                    child: Text("根菜類")
                  ),
                  SizedBox(width: 16,),
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        _counter = 1500;
                        _setCount = 1500;
                        stopTimer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)
                      )
                    ),
                    child: Text("イモ類")
                  ),
                ],
              ),
            },
            
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      _counter = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)
                    )
                  ),
                  child: Text("デバッグ用")
                ),
              ]
            )
          ],
        ),
      ),
    );
  }
}

