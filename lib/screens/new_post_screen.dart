import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  int _selectedDomaine = 0;
  List<String> _domaines = <String>[
    'Music',
    'Photography',
    'Choreography',
    'Painting',
    'Design',
    'Video Editing',
    'Magic ',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: GestureDetector(
                    child: Center(child: Text("Upload Media")))),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: Colors.white),
              controller: _title,
              decoration: InputDecoration(
                hintText: 'Title...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                expands: true,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                controller: _description,
                decoration: InputDecoration(
                  hintText: 'Description...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Domaine : ",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                GestureDetector(
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return _buildBottomPicker(CupertinoPicker(
                              scrollController: FixedExtentScrollController(
                                  initialItem: _selectedDomaine),
                              diameterRatio: 1.1,
                              itemExtent: 30,
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  _selectedDomaine = index;
                                });
                              },
                              children:
                                  _domaines.map((e) => Text(e)).toList()));
                        });
                  },
                  child: Text(
                    _domaines.elementAt(_selectedDomaine),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(children: [
              Text(
                "Contests : ",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.add))
            ]),
            Expanded(flex: 1, child: Container())
          ],
        ));
  }

  double _kPickerSheetHeight = 200.0;
  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }
}
