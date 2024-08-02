import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:larva/controllers/postController.dart';
import 'package:larva/util/SearchContest.dart';
import 'package:larva/widgets/Tag.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Add extends StatefulWidget {
  final String contestId;
  final bool fromContest;
  final String contestName;

  const Add({
    Key? key,
    this.fromContest = false,
    this.contestId = "",
    this.contestName = "",
  }) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final PostController _pc = PostController();
  final _title = TextEditingController();
  final _description = TextEditingController();
  int _selectedDomaine = 0;
  Timer? _timer;
  late List<String> _contests;
  late List<String> _contests_name;
  VideoPlayerController? _videoController;
  Uint8List? _videoThumbnail;

  @override
  void initState() {
    super.initState();
    _contests = widget.contestName != '' ? [widget.contestId] : [];
    _contests_name = widget.contestName != '' ? [widget.contestName] : [];

    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  List<String> _domaines = <String>[
    'Music',
    'Photography',
    'Choreography',
    'Painting',
    'Design',
    'Video Editing',
    'Magic ',
  ];

  late File _selectedMedia;
  bool _select = false;
  bool _isVideo = false;

  void getImage() async {
    try {
      List<Media>? res = await ImagesPicker.pick(
        count: 1,
        pickType: PickType.all,
        quality: 0.8,
        maxSize: 250,
      );

      print(res?.first.path);

      if (res != null && res.isNotEmpty) {
        setState(() {
          _selectedMedia = File(res.first.path);
          _select = true;
          _isVideo = res.first.path.endsWith("MOV") ||
              res.first.path.endsWith("mp4") ||
              res.first.path.endsWith("avi") ||
              res.first.path.endsWith("flv") ||
              res.first.path.endsWith("wmv");

          if (_isVideo) {
            _generateVideoThumbnail();
          }
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image. Please try again.')),
      );
    }
  }

  Future<void> _generateVideoThumbnail() async {
    try {
      final uint8List = await VideoThumbnail.thumbnailData(
        video: _selectedMedia.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128,
        quality: 25,
      );

      setState(() {
        _videoThumbnail = uint8List;
      });
    } catch (e) {
      print('Error generating thumbnail: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to generate thumbnail. Please try again.')),
      );
    }
  }

  Random random = Random();

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("New Post", style: Theme.of(context).textTheme.titleLarge),
        actions: [
          TextButton(
            onPressed: () async {
              EasyLoading.show(status: 'Uploading...');

              await _pc.uploadPost(
                context,
                _selectedMedia,
                _title.text,
                _description.text,
                _contests, // Pass contests as an array
                _domaines.elementAt(_selectedDomaine),
              );

              EasyLoading.dismiss();
            },
            child: Text(
              "Publier",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.amber),
            ),
          ),
        ],
        automaticallyImplyLeading: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: getImage,
              child: _select
                  ? _isVideo
                      ? _videoThumbnail != null
                          ? Image.memory(_videoThumbnail!)
                          : Center(child: CircularProgressIndicator())
                      : Image.file(_selectedMedia)
                  : Center(
                      child: Text(
                        "Upload Media",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
            ),
          ),
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
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
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
                style: Theme.of(context).textTheme.titleMedium,
              ),
              GestureDetector(
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return _buildBottomPicker(
                        CupertinoPicker(
                          scrollController: FixedExtentScrollController(
                            initialItem: _selectedDomaine,
                          ),
                          diameterRatio: 1.1,
                          itemExtent: 30,
                          onSelectedItemChanged: (index) {
                            setState(() {
                              _selectedDomaine = index;
                            });
                          },
                          children: _domaines.map((e) => Text(e)).toList(),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  _domaines.elementAt(_selectedDomaine),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Text(
                "Contests : ",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _contests_name
                        .map((e) => Tag(
                            key: Key(e), color: random.nextInt(8), string: e))
                        .toList(),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  var result = await showSearch(
                      context: context, delegate: SearchContest());
                  if (result != null) {
                    setState(() {
                      _contests.add(result);
                    });
                  }
                },
                icon: Icon(Icons.add),
              )
            ],
          ),
          Expanded(flex: 1, child: Container())
        ],
      ),
    );
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
