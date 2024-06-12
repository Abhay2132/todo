import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

List<TaskData> _tasks = [
  TaskData(id: 1, name: "Cleaning"),
  TaskData(id: 2, name: "Shopping"),
  TaskData(id: 3, name: "Study")
];

class AppState extends ChangeNotifier {
  List<TaskData> tasks = _tasks;
  double sidePanelWidth = 250.0;

  void setTasks(List<TaskData> newTasks) {
    tasks = [...newTasks];
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MaterialApp(
        home: App(),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [TopBar(), Expanded(child: Body())],
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var tasks = appState.tasks;

    return Row(
      children: [
        SidePanel(tasklist: [...tasks],),
        Expanded(
          child: Main(),
        )
      ],
    );
  }
}

class TaskData {
  String name;
  int id;

  TaskData({required this.name, required this.id});
}

class SidePanel extends StatefulWidget {
  List<TaskData> tasklist;
  SidePanel({
    super.key,
    required this.tasklist
  });

  @override
  State<SidePanel> createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel> {

  late List<TaskData> currTasks;

  void onSearch(String text) {
    print(text);
    setState(() {
      currTasks = widget.tasklist.where((task) => task.name.toLowerCase().contains(text.toLowerCase())).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currTasks = widget.tasklist;
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>(); 
    double width = appState.sidePanelWidth; // todo : add this width into the state from parent in `initState`
    // var currTasks = appState.tasks;

    return Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(230, 230, 230, 1),
          border: Border(
            right: BorderSide(
              color: Color.fromRGBO(200, 200, 200, 1),
              width: 1.0,
            ),
          ),
        ),
        width: width,
        // color: Colors.amber,
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(top: 6.0, left: 10.0, bottom: 5.0),
                width: width,
                color: Colors.transparent,
                child: const Text(
                  "Tasks",
                  style: TextStyle(fontSize: 16),
                )),
            // TaskList(tasklist: [...appState.tasks]),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: CurvedSearchBar(hintText: "Search Task", onChange: onSearch),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: currTasks.length,
                itemBuilder: (BuildContext context, int index){
                return TaskItem(data: currTasks[index], width: width);
              })
            ),
            NewTaskBtn(width: width),
          ],
        ));
  }
}

class NewTaskBtn extends StatelessWidget {
  const NewTaskBtn({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          height: 40,
          width: width,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: const Text(
              "New Task",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade500,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8.0), // Set desired radius
              ),
            ),
          )),
    );
  }
}

/*
class TaskList extends StatefulWidget {
  final List<TaskData> tasklist;
  const TaskList({super.key, required this.tasklist});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late List<TaskData> currTasks; // = List<TaskData>.empty();

  @override
  void initState() {
    super.initState();
    currTasks = [...widget.tasklist];
    // for(TaskData task in widget.tasklist){
    //   currTasks.add(task);
    // }
  }

  void onChange(String text) {
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    double width = appState.sidePanelWidth;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 14, right: 8.0),
          child: CurvedSearchBar(
              hintText: "Search",
              // controller: TextEditingController(text: "ABhay"),
              onChange: onChange),
        ),
        const SizedBox(
          height: 20,
        ),
        // Expanded(
        //     child: ListView.builder(
        //         itemCount: 3,
        //         itemBuilder: (BuildContext context, int index) {
        //           // return TaskItem(data: currTasks[index], width: width);
        //           return Text(index.toString());
        //         })),

        Expanded(
          child: Text("HELLO")
        ),
        Text("HEHE")
      ],
    );
  }
}
*/

class TaskItem extends StatelessWidget {
  final TaskData data;
  const TaskItem({
    super.key,
    required this.data,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
      child: Container(
        height: 40,
        width: width,
        // alignment: ,1
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(width: 1, color: Colors.grey),
            color: Colors.white),
        child: Text(data.name),
      ),
    );
  }
}

class CurvedSearchBar extends StatelessWidget {
  final String hintText;
  // final TextEditingController controller;
  final Function(String) onChange;

  const CurvedSearchBar({
    super.key,
    required this.hintText,
    // required this.controller,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 16.0, left: 5),
      height: 40,
      decoration: BoxDecoration(
        // color: Colors.white,
        border: Border.all(color: Colors.grey),
        color: Colors.white,
        borderRadius: BorderRadius.circular(7.0),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.3),
        //     blurRadius: 6.0,
        //     offset: Offset(0, 2),
        //   ),
        // ],
      ),
      child: TextField(
          // controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(top: 4.5, bottom: 0.0),
            prefixIcon: const Icon(Icons.search),
          ),
          onChanged: onChange
          // onSubmitted: onSubmitted,
          ),
    );
  }
}

class Main extends StatelessWidget {
  const Main({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: const Color.fromRGBO(20, 210, 140, 1),
        child: const Center(child: Text("Main")));
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: const Color.fromRGBO(200, 100, 140, 1),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(100, 100, 100, 1),
              width: 1.0,
            ),
          ),
        ),
        height: 50,
        child: const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text("ToDo App",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
            ),
            Spacer(),
            // Text("Mode"),
            // Text("Profile")
          ],
        ));
  }
}
