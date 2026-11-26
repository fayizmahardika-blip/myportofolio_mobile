import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key, this.onEducationAdded});

  final Future<void> Function()? onEducationAdded;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Portfolio',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Explore personal projects and experiences!',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('View Projects'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              navigator.push(
                MaterialPageRoute(builder: (_) => const ProjectListScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            onTap: () async {
              final pageContext = Scaffold.of(context).context;
              Navigator.of(context).pop();
              if (!await ensureLoggedIn(pageContext) || !pageContext.mounted) {
                return;
              }
              Navigator.of(pageContext).push(
                MaterialPageRoute(builder: (_) => const ProjectFormPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('View Education'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              if (onEducationAdded != null) return;
              navigator.push(
                MaterialPageRoute(builder: (_) => const EducationListScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('Add Education'),
            onTap: () async {
              final pageContext = Scaffold.of(context).context;
              Navigator.of(context).pop();
              if (!await openEducationForm(pageContext) ||
                  !pageContext.mounted) {
                return;
              }
              final refresh = onEducationAdded;
              if (refresh != null) {
                await refresh();
              } else {
                Navigator.of(pageContext).push(
                  MaterialPageRoute(
                    builder: (_) => const EducationListScreen(),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(isLoggedIn ? Icons.logout : Icons.login),
            title: Text(isLoggedIn ? 'Logout' : 'Login'),
            onTap: () async {
              final pageContext = Scaffold.of(context).context;
              Navigator.of(context).pop();
              if (isLoggedIn) {
                await signOut(pageContext);
              } else {
                await ensureLoggedIn(pageContext);
              }
            },
          ),
        ],
      ),
    );
  }
}
