import 'package:crud_sqlite/model/User.dart';
import 'package:crud_sqlite/screens/EditUser.dart';
import 'package:crud_sqlite/screens/viewUser.dart';
import 'package:crud_sqlite/services/userService.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final _controller = TextEditingController();

  late List<User>? _searchList = null;
  final _userService = UserService();

  getSearchedUserDetails() async {
    var users = await _userService.searchContact(_controller.text);
    _searchList = <User>[];
    users.forEach((user) {
      setState(() {
        var userModel = User();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.email = user['email'];
        userModel.contact = user['contact'];
        userModel.photo = user['photo'];
        _searchList!.add(userModel);
      });
    });
  }

  @override
  void initState() {
    getSearchedUserDetails();
    super.initState();
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _deleteFormDialog(BuildContext context, userId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are You Sure to Delete',
              style: TextStyle(color: Colors.teal, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.teal),
                  onPressed: () async {
                    var result = await _userService.deleteUser(userId);
                    if (result != null) {
                      Navigator.pop(context);
                      getSearchedUserDetails();
                      _showSuccessSnackBar('User Data Deleted Success');
                    }
                  },
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.teal),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              autofocus: true,
              controller: _controller,
              onSubmitted: (value) async {
                if (value.isNotEmpty) {
                  var result = await  _userService.searchContact(value);
                  setState(() {
                    getSearchedUserDetails();
                  });
                }
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body:
            _searchList != null
                ?
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _searchList!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewUser(
                                  user: _searchList![index],
                                )));
                      },
                      leading: const Icon(Icons.person),
                      title: Text(_searchList![index].name ?? ''),
                      subtitle: Text(_searchList![index].contact ?? ''),
                    ),
                  );
                }) : const SizedBox.shrink(),
    );
  }
}
