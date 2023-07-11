import 'package:flutter/material.dart';
import 'my_drawer.dart';
class Mydreawer extends StatelessWidget {
  final void Function()? goToFavorite;
  final void Function()? gotToProfile;
  final void Function()? signOut;
  const Mydreawer({super.key,
    required this.goToFavorite,
    required this.gotToProfile,
    required this.signOut
  
  });

  @override
  Widget build(BuildContext context) {
   

    return Drawer(
      child: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // drawer header
                const DrawerHeader(
                  child: Icon(
                    Icons.message,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
                // favourite
                MyDrawer(
                  title: 'Favourite',
                  icons: Icons.favorite,
                  onTap:goToFavorite,
                ),

                // settings
                MyDrawer(
                  title: 'Profile',
                  icons: Icons.settings,
                  onTap: gotToProfile,
                ),
              ],
            ),

            // logout
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: MyDrawer(
                title: 'Logout',
                icons: Icons.logout,
                onTap: signOut,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
