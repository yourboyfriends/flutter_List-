import 'package:flutter/material.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends StatefulWidget {
  const SampleItemListView({super.key});
  static const routeName = '/';

  @override
  State<SampleItemListView> createState() => _SampleItemListView();
}

class _SampleItemListView extends State<SampleItemListView> {
  final viewModel = SampleItemViewModel();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Danh Sach'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 0, 7, 0),
              ),
              onPressed: () {
                showModalBottomSheet<SampleItem>(
                  context: context,
                  builder: (context) => const SampleItemUpdate(),
                ).then((value) {
                  if (value != null) {
                    viewModel.addItem(value.name, value.msp);
                  }
                });
              },
            ),
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
      ),
    );
  }
}
