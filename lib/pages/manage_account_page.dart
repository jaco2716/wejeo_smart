import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wejeo_smart/logic/auth_app_state.dart';
import 'package:wejeo_smart/logic/tuya_handler.dart';
import 'package:wejeo_smart/widgets/my_alert_dialog.dart';

class ManageAccountPage extends StatefulWidget {
  const ManageAccountPage({Key? key}) : super(key: key);

  @override
  State<ManageAccountPage> createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage> {
  String getDateString() {
    List months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    var date = DateTime.now().add(const Duration(days: 7));
    var currentMon = date.month;

    return '${date.day} ${months[currentMon - 1]}';
  }

  void _deleteAccount() {
    final authAppState = AuthAppState();

    Navigator.pop(context);
    showMyLoadingDialog(context);
    authAppState.cancelAccount(() {
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }, (message) {
      if (mounted) {
        Navigator.pop(context);
        showMyDialog(context, '', message: message);
      }
    });
  }

  Future<void> _logout() async {
    showMyDialog(context, 'Signing out?', message: 'Do you want to sign out?', confirmText: 'Sign out', infoDialog: false, myOnPressed: () async {
      showMyLoadingDialog(context);
      await context.read<AuthAppState>().logOutUser(() {
        if (mounted) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      }, (message) {
        if (mounted) {
          Navigator.popUntil(context, (route) => route.isFirst);
          showMyDialog(context, 'Error', message: message);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String dateString = getDateString();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Manage Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Text(
                  'By pressing "Delete Account" your account and all information will be deleted 1 week from now.\n\nIf you sign in to your account before $dateString your account will not be deleted.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.white70)),
              const SizedBox(height: 10),
              TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () {
                    showMyDialog(
                      context,
                      'Delete Account',
                      message: 'Are you sure you want to delete account?',
                      infoDialog: false,
                      myOnPressed: () => _deleteAccount(),
                    );
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Account')),
              const Divider(),
              const SizedBox(height: 20),
              const Text('Sign out of your account.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white70)),
              TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.amber),
                  onPressed: () {
                    showMyDialog(
                      context,
                      'Signing Out?',
                      message: 'Do you want to sign out?',
                      confirmText: 'Sign Out',
                      infoDialog: false,
                      myOnPressed: () => _logout(),
                    );
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Sign Out'))
            ],
          ),
        ),
      ),
    );
  }
}
