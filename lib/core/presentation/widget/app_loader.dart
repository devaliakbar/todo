import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/presentation/bloc/app_loader/app_loader_bloc.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLoaderBloc, AppLoaderState>(
      builder: (_, AppLoaderState state) => state is LoaderVisible
          ? Container(
              alignment: Alignment.center,
              color: Colors.blueAccent.withOpacity(0.2),
              child: const CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
