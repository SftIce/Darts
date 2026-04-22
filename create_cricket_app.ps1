# darts_compilation_fix.ps1

$MainContent = @'
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

void main() => runApp(MaterialApp(
  theme: ThemeData.dark().copyWith(
    primaryColor: Colors.amber,
    scaffoldBackgroundColor: const Color(0xFF0D1117),
    cardTheme: CardThemeData(
      color: Colors.white.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
  ),
  debugShowCheckedModeBanner: false,
  home: const MenuScreen(),
));

class Player {
  String name; int wins;
  Player(this.name, {this.wins = 0});
  Map<String, dynamic> toJson() => {'name': name, 'wins': wins};
  factory Player.fromJson(Map<String, dynamic> j) => Player(j['name'], wins: j['wins']);
}

class DataStore {
  static const String path = r'E:\Darts\darts_data.json';
  static List<Player> players = [];
  static void save() { try { File(path).writeAsStringSync(jsonEncode(players.map((p) => p.toJson()).toList())); } catch (e) {} }
  static void load() { try { final f = File(path); if (f.existsSync()) { final List d = jsonDecode(f.readAsStringSync()); players = d.map((p) => Player.fromJson(p)).toList(); } } catch (e) {} }
}

abstract class GameLogic {
  int dartsThrown = 0; bool isP1Turn = true; String statusMessage = "";
  void handleHit(String target, int mult);
  bool isOver();
  String getWinner(String p1, String p2);
}

class CricketLogic extends GameLogic {
  Map<String, int> p1Marks = {}, p2Marks = {}, p1RowScore = {}, p2RowScore = {};
  int p1Total = 0, p2Total = 0;
  final List<String> targets = ['20','19','18','17','16','15','14','13','12','11','10','D','T','Bull'];
  CricketLogic() { for (var t in targets) { p1Marks[t] = 0; p2Marks[t] = 0; p1RowScore[t] = 0; p2RowScore[t] = 0; } }

  @override void handleHit(String target, int mult) {
    if (target == "Gary Player") { dartsThrown++; return; }
    var aM = isP1Turn ? p1Marks : p2Marks; var aS = isP1Turn ? p1RowScore : p2RowScore; var oM = isP1Turn ? p2Marks : p1Marks;
    for (int i = 0; i < mult; i++) {
      if ((aM[target] ?? 0) < 3) aM[target] = (aM[target] ?? 0) + 1;
      else if ((oM[target] ?? 0) < 3) {
        int v = (target == 'Bull' || target == 'D' || target == 'T') ? 25 : (int.tryParse(target) ?? 0);
        aS[target] = (aS[target] ?? 0) + v;
        if (isP1Turn) p1Total += v; else p2Total += v;
      }
    }
    dartsThrown++;
  }
  @override bool isOver() => (targets.every((t) => (p1Marks[t]??0) >= 3) && p1Total >= p2Total) || (targets.every((t) => (p2Marks[t]??0) >= 3) && p2Total >= p1Total);
  @override String getWinner(String p1, String p2) => p1Total >= p2Total ? p1 : p2;
}

class X01Logic extends GameLogic {
  int p1Score, p2Score; bool p1O = false, p2O = false, tripleMode = false;
  X01Logic(int s) : p1Score = s, p2Score = s;

  @override void handleHit(String target, int mult) {
    statusMessage = "";
    if (target == "Gary Player") { dartsThrown++; return; }
    if (target == "Split Legs") { if (isP1Turn) p1Score = 0; else p2Score = 0; dartsThrown++; return; }
    
    int hit = ((target == 'Bull') ? 25 : (int.tryParse(target) ?? 0)) * mult;
    bool activeO = isP1Turn ? p1O : p2O;

    if (!activeO && ((tripleMode && mult == 3) || (!tripleMode && mult == 2))) {
      if (isP1Turn) p1O = true; else p2O = true; activeO = true;
    }

    if (activeO) {
      int cur = isP1Turn ? p1Score : p2Score;
      if (cur - hit < 0) { statusMessage = "BUST !!!"; dartsThrown = 3; }
      else {
        if (isP1Turn) p1Score -= hit; else p2Score -= hit;
        dartsThrown++;
      }
    } else { dartsThrown++; }
  }

  String getHint() {
    if (statusMessage.isNotEmpty) return statusMessage;
    int s = isP1Turn ? p1Score : p2Score;
    if (s == 0) return "WINNER!";
    if (s == 1) return "YOU NEED TO SPLIT THE LEGS!";
    if (s > 110) return "Keep Scoring...";
    if (s <= 40 && s % 2 == 0) return "Double ${s ~/ 2} to win";
    for (int i = 20; i >= 1; i--) {
      for (int m in [3, 2, 1]) {
        int rem = s - (i * m);
        if (rem >= 2 && rem <= 40 && rem % 2 == 0) return "${m==3?'Triple':m==2?'Double':''} $i + Double ${rem~/2} to win";
      }
    }
    return "Aim for a Double";
  }
  @override bool isOver() => p1Score == 0 || p2Score == 0;
  @override String getWinner(String p1, String p2) => p1Score == 0 ? p1 : p2;
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final p1 = TextEditingController(text: "Werner"), p2 = TextEditingController(text: "Opponent"), reg = TextEditingController();
  @override void initState() { super.initState(); DataStore.load(); }
  @override Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(child: Image.file(File(r'E:\Darts\assets\pngwing.com.png'), fit: BoxFit.cover, opacity: const AlwaysStoppedAnimation(0.05))),
        Row(children: [
          Container(width: 300, color: Colors.black45, child: Column(children: [
            const SizedBox(height: 40), const Text("REGISTRY", style: TextStyle(color: Colors.amber)),
            Padding(padding: const EdgeInsets.all(10), child: TextField(controller: reg, decoration: InputDecoration(hintText: "New Player", suffixIcon: IconButton(icon: const Icon(Icons.add), onPressed: (){ setState(()=>DataStore.players.add(Player(reg.text))); DataStore.save(); reg.clear(); })))),
            Expanded(child: ListView.builder(itemCount: DataStore.players.length, itemBuilder: (c,i)=>ListTile(title: Text(DataStore.players[i].name), trailing: Text("${DataStore.players[i].wins}W"), onTap: ()=>setState(() { if(p1.text=="Werner") p1.text=DataStore.players[i].name; else p2.text=DataStore.players[i].name; })))),
          ])),
          Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("PRO DARTS", style: TextStyle(fontSize: 50, color: Colors.amber, fontWeight: FontWeight.bold)),
            _in(p1, "P1"), _in(p2, "P2"),
            const SizedBox(height: 20),
            _btn("CRICKET", Colors.green, () => _go(CricketLogic())),
            const SizedBox(height: 10),
            _btn("X01", Colors.blue, () => _go(X01Logic(301))),
          ])),
        ]),
      ]),
    );
  }
  Widget _in(c, l) => Container(width: 300, margin: const EdgeInsets.all(5), child: TextField(controller: c, decoration: InputDecoration(labelText: l, filled: true, fillColor: Colors.black54)));
  Widget _btn(t, c, f) => ElevatedButton(onPressed: f, style: ElevatedButton.styleFrom(backgroundColor: c, minimumSize: const Size(300, 50)), child: Text(t));
  void _go(l) => Navigator.push(context, MaterialPageRoute(builder: (c)=>GameScreen(logic: l, p1: p1.text, p2: p2.text)));
}

class GameScreen extends StatefulWidget {
  final GameLogic logic; final String p1, p2;
  const GameScreen({super.key, required this.logic, required this.p1, required this.p2});
  @override State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  void _onHit(String v, int m) {
    setState(() {
      widget.logic.handleHit(v, m);
      if (widget.logic.isOver() || widget.logic.dartsThrown >= 3) Future.delayed(const Duration(milliseconds: 300), () => _nextTurn());
    });
  }
  void _nextTurn() {
    if (widget.logic.isOver()) {
      String w = widget.logic.getWinner(widget.p1, widget.p2);
      for (var p in DataStore.players) { if (p.name == w) p.wins++; }
      DataStore.save();
      showDialog(context: context, builder: (c) => AlertDialog(title: Text("Winner: $w"), actions: [TextButton(onPressed: () => Navigator.popUntil(context, (r)=>r.isFirst), child: const Text("EXIT"))]));
    } else { setState(() { widget.logic.isP1Turn = !widget.logic.isP1Turn; widget.logic.dartsThrown = 0; }); }
  }

  @override Widget build(BuildContext context) {
    bool isC = widget.logic is CricketLogic;
    int score = widget.logic is X01Logic ? (widget.logic.isP1Turn ? (widget.logic as X01Logic).p1Score : (widget.logic as X01Logic).p2Score) : 0;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: Text(isC ? "CRICKET" : "X01")),
      body: Stack(children: [
        Positioned.fill(child: Image.file(File(r'E:\Darts\assets\pngwing.com.png'), fit: BoxFit.cover, opacity: const AlwaysStoppedAnimation(0.08))),
        Column(children: [
          _header(),
          Expanded(child: Row(children: [
            Container(width: isC ? 320 : 450, color: Colors.black54, child: isC ? _cPad() : _xPad(score == 1)),
            Expanded(child: _Scoreboard(logic: widget.logic, p1: widget.p1, p2: widget.p2)),
          ])),
        ]),
      ]),
    );
  }

  Widget _header() {
    String msg = (widget.logic is X01Logic) ? (widget.logic as X01Logic).getHint() : "Cricket Match";
    return Container(padding: const EdgeInsets.all(10), color: Colors.black87, child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _pBox(widget.p1, widget.logic.isP1Turn),
        Text("Darts: ${widget.logic.dartsThrown}/3", style: const TextStyle(color: Colors.amber)),
        _pBox(widget.p2, !widget.logic.isP1Turn),
      ]),
      Text(msg, style: TextStyle(color: msg.contains("LEGS") ? Colors.orangeAccent : Colors.cyanAccent, fontSize: 20, fontWeight: FontWeight.bold)),
    ]));
  }
  Widget _pBox(n, a) => Text(n, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: a ? Colors.amber : Colors.white24));

  Widget _cPad() => ListView(padding: EdgeInsets.zero, children: [
    ...List.generate(11, (i)=>(20-i).toString()).map((t)=>_row(t)).toList(),
    _key("DOUBLE", "D", 1, Colors.orange[900]!, wide: true),
    _key("TRIPLE", "T", 1, Colors.blue[900]!, wide: true),
    _row("Bull", hasT: false),
    _key("GARY PLAYER", "Gary Player", 1, Colors.red[900]!, wide: true),
  ]);

  Widget _xPad(bool showSplit) => Column(children: [
    if (showSplit) _key("SPLIT THE LEGS (11)", "Split Legs", 1, Colors.orange[800]!, wide: true),
    Expanded(child: Row(children: [
      Expanded(child: ListView(padding: EdgeInsets.zero, children: List.generate(10, (i)=>(20-i).toString()).map((t)=>_row(t)).toList())),
      Expanded(child: ListView(padding: EdgeInsets.zero, children: [...List.generate(10, (i)=>(10-i).toString()).map((t)=>_row(t)).toList(), _row("Bull", hasT:false), _key("GARY PLAYER", "Gary Player", 1, Colors.red[900]!, wide:true)]))
    ])),
  ]);

  Widget _row(l, {hasT = true}) => Row(children: [
    Expanded(flex: 2, child: _key(l, l, 1, Colors.green[900]!)),
    Expanded(child: _key("D", l, 2, Colors.red[900]!)),
    if(hasT) Expanded(child: _key("T", l, 3, Colors.blue[900]!)),
  ]);
  Widget _key(l, v, m, c, {wide = false}) => InkWell(onTap: () => _onHit(v, m), child: Container(height: wide ? 45 : 38, margin: const EdgeInsets.all(0.5), color: c, child: Center(child: Text(l, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))));
}

class _Scoreboard extends StatelessWidget {
  final GameLogic logic; final String p1, p2;
  const _Scoreboard({required this.logic, required this.p1, required this.p2});
  @override Widget build(BuildContext context) {
    if (logic is CricketLogic) {
      var l = logic as CricketLogic;
      return Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [ _t(p1, l.p1Total), _t(p2, l.p2Total) ]),
        Expanded(child: ListView(children: l.targets.map((t) => _grid(t, 'X'* (l.p1Marks[t]??0), 'X'*(l.p2Marks[t]??0))).toList())),
      ]);
    }
    var xl = logic as X01Logic;
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      _xS(p1, xl.p1Score, xl.p1O),
      const Divider(color: Colors.white12),
      _xS(p2, xl.p2Score, xl.p2O),
    ]));
  }
  Widget _t(n, s) => Column(children: [Text(n), Text("$s", style: const TextStyle(fontSize: 30, color: Colors.amber))]);
  Widget _grid(t, m1, m2) => Container(
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10))),
    child: Row(children: [ Expanded(child: Center(child: Text(m1, style: const TextStyle(color: Colors.cyanAccent)))), Expanded(child: Center(child: Text(t, style: const TextStyle(color: Colors.amber)))), Expanded(child: Center(child: Text(m2, style: const TextStyle(color: Colors.cyanAccent)))) ]),
  );
  Widget _xS(n, s, o) => Column(children: [Text(n, style: TextStyle(color: o?Colors.green:Colors.red)), Text("$s", style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: o?Colors.blue:Colors.white10))]);
}
'@

[System.IO.File]::WriteAllText("E:\Darts\lib\main.dart", $MainContent)
Write-Host "Opacity animation fix applied. You're ready to run!" -ForegroundColor Green