import 'package:flutter/material.dart';

import '../../components/app_titles/app_bar_title.dart';
import '../../components/delivery_card.dart';
import '../../components/list_container.dart';
import '../../models/client/client.dart';
import '../../models/delivery/package.dart';
import '../../repository/client_repository.dart';
import '../../repository/package_repository.dart';
import 'form_package.dart';

class DeliveryList extends StatefulWidget {
  const DeliveryList({Key? key}) : super(key: key);

  @override
  State<DeliveryList> createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
  List<Package> packages = [];
  List<Client> clients = [];

  final clientRepository = ClientRepository();
  final packageRepository = PackageRepository();

  bool _loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await reloadData();
    });
    super.initState();
  }

  Future<void> reloadData() async {
    if (!_loading) {
      setState(() {
        _loading = true;
      });
    }

    clients = await clientRepository.fetchClients();
    packages = await packageRepository.fecthPackages();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBarTitle(firstTitle: 'Solicite uma', secondTitle: 'entrega'),
          ListContainer(
            title: 'Pacotes',
            child: !_loading
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: packages.length,
                    padding: const EdgeInsets.only(bottom: 20),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return DeliveryCard(
                        clientName:
                            packages[index].clienteForm?.nome ?? 'sem nome',
                        wheigthPackage: packages[index].peso.toString(),
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            action: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormPackage(),
                ),
              );
              reloadData();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.check),
      ),
    );
  }
}
