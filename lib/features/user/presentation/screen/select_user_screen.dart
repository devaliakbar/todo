import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/presentation/widget/cached_image.dart';
import 'package:todo/core/presentation/widget/common_app_bar.dart';
import 'package:todo/core/presentation/widget/custom_value_notifier.dart';
import 'package:todo/core/res/app_theme/app_theme.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';
import 'package:todo/features/user/presentation/bloc/get_users/get_users_bloc.dart';
import 'package:todo/injection_container.dart' as di;

typedef OnUsersSelect = Function(List<UserInfo> selectedUsers);

class SelectUserScreen extends StatefulWidget {
  final List<UserInfo> selectedUsers;
  final OnUsersSelect onUsersSelect;

  const SelectUserScreen(
      {super.key, this.selectedUsers = const [], required this.onUsersSelect});

  @override
  State<SelectUserScreen> createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  final CustomValueNotifier<List<UserInfo>> _users = CustomValueNotifier([]);

  final List<UserInfo> selectedUsers = [];

  @override
  void initState() {
    selectedUsers.addAll(widget.selectedUsers);

    super.initState();
  }

  @override
  void dispose() {
    _users.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CommonAppBar(
            title: "Select user",
            actions: [
              Tapped(
                onTap: () {
                  Navigator.pop(context);
                  widget.onUsersSelect(selectedUsers);
                },
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    Icons.check,
                    size: 24,
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: BlocProvider<GetUsersBloc>(
              create: (context) =>
                  di.sl<GetUsersBloc>()..add(GetAllUsersEvent()),
              child: BlocConsumer<GetUsersBloc, GetUsersState>(
                listenWhen: (previous, GetUsersState current) =>
                    current is GetUsersLoaded,
                listener: (context, GetUsersState state) {
                  if (state is GetUsersLoaded) {
                    _users.value = [...state.users];
                  }
                },
                builder: (_, GetUsersState state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state is GetUsersLoaded)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 15, bottom: 10),
                          child: TextField(
                            onChanged: (String value) {
                              if (value.trim().isEmpty) {
                                _users.value = [...state.users];
                              } else {
                                _users.value = state.users
                                    .where((element) => element.fullName
                                        .toLowerCase()
                                        .contains(value.trim().toLowerCase()))
                                    .toList();
                              }
                            },
                            decoration: InputDecoration(
                                label: const Text("Search"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                filled: true,
                                hintStyle:
                                    TextStyle(color: AppTheme.color.greyLight),
                                fillColor: Colors.white),
                          ),
                        ),
                      if (state is GetUsersFailed)
                        const Center(
                          child: Text("Failed to load users"),
                        )
                      else if (state is GetUsersLoaded)
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: _users,
                            builder: (_, List<UserInfo> users, __) =>
                                ListView.builder(
                              itemCount: users.length,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 30),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Tapped(
                                  onTap: () {
                                    if (selectedUsers.contains(users[index])) {
                                      selectedUsers.remove(users[index]);
                                    } else {
                                      selectedUsers.add(users[index]);
                                    }

                                    _users.notifyListeners();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 24,
                                              width: 24,
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              child: ClipOval(
                                                child: CachedImage(
                                                    imageUrl: users[index]
                                                        .profilePic),
                                              ),
                                            ),
                                            if (selectedUsers
                                                .contains(users[index]))
                                              Container(
                                                height: 24,
                                                width: 24,
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white
                                                      .withOpacity(0.6),
                                                ),
                                                child: Icon(
                                                  Icons.check,
                                                  size: 18,
                                                  color: AppTheme.color.black,
                                                ),
                                              )
                                          ],
                                        ),
                                        Expanded(
                                          child: Text(users[index].fullName),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        const Center(
                          child: Text("Loading..."),
                        )
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
