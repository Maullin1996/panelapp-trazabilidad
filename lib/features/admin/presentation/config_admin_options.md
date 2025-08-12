  //   @override
  //   void initState() {
  //     super.initState();
  // debugClaims();
  //   }

  // Future<void> debugClaims() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     print('No logged in');
  //     return;
  //   }

  //   final t = await user.getIdTokenResult(true); // fuerza refresh
  //   print('claims => ${t.claims}'); // debería ver: {role: admin}
  // }

  // Future<void> _grantAdminTo(String uid) async {
  //   try {
  //     await FirebaseFunctions.instance.httpsCallable('setUserAsAdmin').call({
  //       'uid': uid,
  //     });

  //     // Si es el usuario actual, refresca su token para obtener {role: admin}
  //     await FirebaseAuth.instance.currentUser?.getIdToken(true);

  //     if (!mounted) return;
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('✅ Rol admin asignado')));
  //     // Opcional: recargar lista ahora que ya eres admin
  //     ref.read(adminUsersControllerProvider.notifier).refresh();
  //   } catch (e) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Error al asignar admin: $e')));
  //   }
  // }

  // Future<void> _showMakeAdminDialog() async {
  //   final ctrl = TextEditingController(
  //     text: FirebaseAuth.instance.currentUser?.uid ?? '',
  //   );
  //   final uid = await showDialog<String>(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text('Asignar rol admin'),
  //       content: TextField(
  //         controller: ctrl,
  //         decoration: const InputDecoration(
  //           labelText: 'UID del usuario',
  //           hintText: 'pega aquí el UID',
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(ctx),
  //           child: const Text('Cancelar'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
  //           child: const Text('Asignar'),
  //         ),
  //       ],
  //     ),
  //   );
  //   if (uid != null && uid.isNotEmpty) {
  //     await _grantAdminTo(uid);
  //     await debugClaims(); // vuelve a imprimir los claims
  //   }
  // }
          // IconButton(
          //   onPressed: _showMakeAdminDialog,
          //   icon: const Icon(Icons.admin_panel_settings_outlined),
          //   tooltip: 'Asignar rol admin (temporal)',
          // ),