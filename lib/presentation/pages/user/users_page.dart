import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user.dart';
import '../../bloc/user/user_bloc.dart';
import '../../widgets/custom_error_widget.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return state.when(
            initial: () {
              print("Event received: initial state");
              context.read<UserBloc>().add(const UserEvent.getUsers(page: 1));
              return const Center(child: CircularProgressIndicator());
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (users, hasReachedMax) =>
                _buildUserList(context, users, hasReachedMax),
            error: (message) => CustomErrorWidget(errorMessage: message),
          );
        },
      ),
    );
  }

  Widget _buildUserList(
      BuildContext context, List<User> users, bool hasReachedMax) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollEndNotification &&
            scrollInfo.metrics.extentAfter == 0 &&
            !hasReachedMax) {
          context.read<UserBloc>().add(const UserEvent.loadMoreUsers());
        }
        return false;
      },
      child: ListView.builder(
        itemCount: users.length + (hasReachedMax ? 0 : 1),
        itemBuilder: (BuildContext context, int index) {
          if (index >= users.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildUserCard(context, users[index]);
        },
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, User user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(user.firstName[0]),
        ),
        title: Text('${user.firstName} ${user.lastName}'),
        subtitle: Text(user.email),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to user details page
        },
      ),
    );
  }
}
