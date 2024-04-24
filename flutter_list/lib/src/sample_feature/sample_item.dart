import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A placeholder class that represents an entity or model.
class SampleItem {
  String id;
  String name;
  String msp;

  SampleItem({String? id, required String name, required String msp})
      : id = id ?? generateUuid(),
        msp = msp,
        name = name;
  static String generateUuid() {
    return int.parse(
            '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(100000)}')
        .toRadixString(35)
        .substring(0, 9);
  }
}

class SampleItemViewModel extends ChangeNotifier {
  static final _instance = SampleItemViewModel._();
  factory SampleItemViewModel() => _instance;
  SampleItemViewModel._();
  final List<SampleItem> items = [];

  void addItem(String name, String msp) {
    items.add(SampleItem(name: name, msp: msp));
    notifyListeners();
  }

  void removeItem(String id) {
    items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateItem(String id, String newName, String msp) {
    try {
      final item = items.firstWhere((item) => item.id == id);
      item.name = newName;
      item.msp = msp;
      notifyListeners();
    } catch (e) {
      debugPrint("khong tim thay muc voi Id $id");
    }
  }
}

class SampleItemUpdate extends StatefulWidget {
  final SampleItem? item;
  const SampleItemUpdate({super.key, this.item});
  @override
  State<SampleItemUpdate> createState() => _SampleItemUpdateState();
}

class _SampleItemUpdateState extends State<SampleItemUpdate> {
  late TextEditingController textEditingController;
  late TextEditingController msvEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.item?.name);
    msvEditingController = TextEditingController(text: widget.item?.msp);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.item?.name != null ? 'chinh sua' : 'them moi'),
          actions: [
            IconButton(
              onPressed: () {
                final newItem = SampleItem(
                    name: textEditingController.text,
                    msp: msvEditingController.text);
                Navigator.of(context).pop(newItem);
              },
              icon: const Icon(Icons.save),
            )
          ],
        ),
        body: Column(
          children: [
            TextFormField(
              controller: textEditingController,
            ),
            TextFormField(
              controller: msvEditingController,
            )
          ],
        ));
  }
}

class SampleItemWidget extends StatelessWidget {
  final SampleItem item;
  final VoidCallback? onTap;

  const SampleItemWidget({super.key, required this.item, this.onTap});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: ValueNotifier(item.name),
      builder: (context, name, child) {
        debugPrint(item.id);
        return ListTile(
          title: Text(name!),
          subtitle: Text(item.id),
          leading: const CircleAvatar(
            foregroundImage: AssetImage(''),
          ),
          onTap: onTap,
          trailing: const Icon(Icons.keyboard_arrow_right),
        );
      },
    );
  }
}
