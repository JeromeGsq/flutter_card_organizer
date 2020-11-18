import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_card_organizer/core/widgets/event_listener.dart';
import 'package:flutter_card_organizer/data/sources/app_ml_kit.dart';
import 'package:flutter_card_organizer/data/sources/file_picker.dart';
import 'package:flutter_card_organizer/modules/home/view_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<AppMLKit, HomeViewModel>(
      create: (_) => HomeViewModel(),
      update: (_, appMLKit, vm) => vm
        ..appMLKit = appMLKit
        ..load(),
      child: EventListener<HomeViewModel>(
        listener: (context, event) {},
        child: const View(),
      ),
    );
  }
}

class View extends StatefulWidget {
  const View({
    Key key,
  }) : super(key: key);

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final filePicker = Provider.of<AppFilePicker>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          FlatButton(
            highlightColor: Colors.white30,
            splashColor: Colors.white30,
            child: const Icon(
              Icons.wifi_protected_setup_sharp,
              color: Colors.white,
            ),
            onPressed: () async {
              await viewModel.processImage();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.photo),
        tooltip: 'Select a picture to scan',
        onPressed: () async {
          viewModel.picture = await filePicker.pickPhoto();
          if (viewModel.picture != null) {
            Fluttertoast.showToast(
              msg: 'You can zoom & pan your picture',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
          }
        },
      ),
      body: Center(
        child: viewModel.picture == null
            ? const Text('Select a picture')
            : InteractiveViewer(
                child: Image(image: FileImage(viewModel.picture)),
              ),
      ),
    );
  }
}
