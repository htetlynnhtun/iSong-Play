import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:music_app/blocs/network_connection_bloc.dart';

class NetworkAwareWidget extends StatelessWidget {
  final Widget child;
  const NetworkAwareWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ConnectionStatus>(
      valueListenable: context.read<NetworkConnectionBloc>().status,
      builder: (_, status, child) {
        if (status == ConnectionStatus.connected) {
          return child!;
        } else {
          return GestureDetector(
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text("No internet connection"),
                    content: const Text("Please check your internet connection."),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            },
            child: AbsorbPointer(child: child!),
          );
        }
      },
      child: child,
    );
  }
}