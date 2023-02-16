import 'package:flutter/material.dart';
import 'package:wejeo_smart/pages/manage_account_page.dart';

class MenuPopupButton extends StatefulWidget {
  const MenuPopupButton({
    Key? key,
  }) : super(key: key);

  @override
  State<MenuPopupButton> createState() => _MenuPopupButtonState();
}

class _MenuPopupButtonState extends State<MenuPopupButton> {
  // Future<void> _logout() async {
  //   showMyDialog(context, 'Signing out?', message: 'Do you want to sign out?', confirmText: 'Sign out', infoDialog: false, myOnPressed: () async {
  //     showMyLoadingDialog(context);
  //     await context.read<AuthAppState>().logOutUser(() {
  //       if (mounted) {
  //         Navigator.popUntil(context, (route) => route.isFirst);
  //       }
  //     }, (message) {
  //       if (mounted) {
  //         Navigator.popUntil(context, (route) => route.isFirst);
  //         showMyDialog(context, 'Error', message: message);
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageAccountPage(), fullscreenDialog: true));
        // if (value == 'Manage Account') {
        // } else {
        //   _logout();
        // }
      },
      offset: const Offset(0, 60),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Manage Account',
          child: Text('Manage Account'),
        ),
        // const PopupMenuItem<String>(
        //   value: 'Sign out',
        //   child: Text('Sign out'),
        // ),
      ],
      icon: const Icon(Icons.more_vert),
    );
  }
}
