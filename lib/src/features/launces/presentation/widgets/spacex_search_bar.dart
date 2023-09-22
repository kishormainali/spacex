import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/launches/launch_bloc.dart';

class SpaceXSearchBar extends StatelessWidget {
  const SpaceXSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    const outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: context.read<LaunchBloc>().searchController,
              onChanged: context.read<LaunchBloc>().search,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search',
                border: outlineInputBorder,
                disabledBorder: outlineInputBorder,
                enabledBorder: outlineInputBorder,
                focusedBorder: outlineInputBorder,
                errorBorder: outlineInputBorder,
                isDense: true,
              ),
            ),
          ),
          PopupMenuButton(
            initialValue: context.watch<LaunchBloc>().sortString,
            position: PopupMenuPosition.under,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white,
            icon: const Icon(
              Icons.sort_rounded,
              size: 28,
            ),
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 'asc',
                  child: Text('Ascending'),
                ),
                const PopupMenuItem(
                  value: 'desc',
                  child: Text('Descending'),
                ),
              ];
            },
            onSelected: (value) {
              context.read<LaunchBloc>().sort(value.toString());
            },
          ),
        ],
      ),
    );
  }
}
