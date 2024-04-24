import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'sample_item.dart';

class SampleItemDetailsView extends StatefulWidget {
  final SampleItem item;
  static const routeName = '/sample_item';

  const SampleItemDetailsView({super.key, required this.item});
  @override
  State<SampleItemDetailsView> createState() => _SampleItemDetailsViewState();
}

class _SampleItemDetailsViewState extends State<SampleItemDetailsView> {
  final viewModel = SampleItemViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('data'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showModalBottomSheet<SampleItem?>(
                  context: context,
                  builder: (context) => SampleItemUpdate(item: widget.item),
                ).then((value) {
                  if (value != null) {
                    viewModel.updateItem(widget.item.id, value.name, value.msv);
                    setState(() {});
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("xac nhan xoa"),
                      content: const Text("ban co chac chan muon xoa muc nay?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("bo qua"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("xoa"),
                        ),
                      ],
                    );
                  },
                ).then((confirmed) {
                  if (confirmed) {
                    Navigator.of(context).pop(true);
                  }
                });
              },
            ),
          ],
        ),
        body: ValueListenableBuilder<String>(
          valueListenable: ValueNotifier(widget.item.name),
          builder: (_, name, __) {
            return Center(child: Text(name));
          },
        ));
  }
}

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({super.key});
  static const routeName = '/';

  @override
  State<SampleItemListView> createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  final viewModel = SampleItemViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('danh sach'),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet<SampleItem?>(
                  context: context,
                  builder: (context) => const SampleItemUpdate(),
                ).then((value) {
                  if (value != null) {
                    viewModel.addItem(value.name, value.msv);
                  }
                });
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return ListView.builder(
            itemCount: viewModel.items.length,
            itemBuilder: (context, index) {
              final item = viewModel.items[index];
              return SampleItemWidget(
                key: ValueKey(item.id),
                item: item,
                onTap: () {
                  Navigator.of(context)
                      .push<bool>(
                    MaterialPageRoute(
                      builder: (context) => SampleItemDetailsView(item: item),
                    ),
                  )
                      .then((deleted) {
                    if (deleted ?? false) {
                      viewModel.removeItem(item.id);
                    }
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
