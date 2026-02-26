import 'package:bodmas_wealth/about_us.dart';
import 'package:bodmas_wealth/blog_articles.dart';
import 'package:bodmas_wealth/buy/flats_apartments.dart';
import 'package:bodmas_wealth/buy/houses_villas.dart';
import 'package:bodmas_wealth/home/home_screen.dart';
import 'package:bodmas_wealth/loan/housing_loan.dart';
import 'package:bodmas_wealth/loan/property_loans.dart';
import 'package:bodmas_wealth/projects/new_launch_projects.dart';
import 'package:bodmas_wealth/projects/ongoing_projects.dart';
import 'package:bodmas_wealth/property/property_browse_screen.dart';
import 'package:bodmas_wealth/property_management/add_property_screen.dart';
import 'package:bodmas_wealth/user/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ===========================
/// MAIN SCREEN
/// ===========================
/// Root screen with BottomNavigationBar
/// This is shown AFTER user is logged in
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  /// Currently selected bottom navigation index
  int _currentIndex = 0;

  /// menu select
  String? selectedMenu;

  /// menu items and submenus
  late final List<MenuItem> menuItems;

  @override
  void initState() {
    super.initState();

    menuItems = [
      MenuItem(
        title: "Loan",
        icon: Icons.circle,
        subMenu: [
          MenuItem(
            title: "Property Loans",
            icon: Icons.circle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PropertyLoanScreen()),
              );
            },
          ),
          MenuItem(
            title: "Housing Loans",
            icon: Icons.circle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HousingLoanScreen()),
              );
            },
          ),
        ],
      ),

      MenuItem(
        title: "Buy",
        icon: Icons.circle,
        subMenu: [
          MenuItem(
            title: "Flats/Apartments",
            icon: Icons.circle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FlatsApartmentsScreen()),
              );
            },
          ),
          MenuItem(
            title: "Houses/Villas",
            icon: Icons.circle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HousesVillasScreen()),
              );
            },
          ),
        ],
      ),

      MenuItem(
        title: "Project",
        icon: Icons.circle,
        subMenu: [
          MenuItem(
            title: "New Launch Projects",
            icon: Icons.circle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NewLaunchProjectsScreen()),
              );
            },
          ),
          MenuItem(
            title: "Ongoing Projects",
            icon: Icons.circle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OngoingProjectsScreen()),
              );
            },
          ),
        ],
      ),

      MenuItem(
        title: "Blog & Articles",
        icon: Icons.circle,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BlogArticlesScreen()),
          );
        },
      ),
      MenuItem(
        title: "About Us",
        icon: Icons.circle,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AboutUsScreen()),
          );
        },
      ),
      MenuItem(
        title: "Help",
        icon: Icons.circle,
        onTap: () {

        },
      ),
    ];
  }
  /// ===========================
  /// STYLES
  /// ===========================
  static const Color _selectedColor = Color(0xFF9144FF);
  static const Color _unSelectedColor = Color(0xFFA684FF);

  static const double _selectedIconSize = 24;
  static const double _unSelectedIconSize = 20;

  static const TextStyle _selectedLabelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle _unSelectedLabelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
  );

  /// ===========================
  /// SCREENS
  /// ===========================
  /// IndexedStack keeps each tab state alive
  final List<Widget> _screens = const [
    HomeScreen(),
    PropertyBrowseScreen(),
    AddPropertyScreen(),
    UserProfileScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // System back is handled manually
      canPop: false,

      // Android back button callback (Flutter 3.22+)
      onPopInvokedWithResult: (didPop, result) {

        // If not on Home tab → go to Home
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return;
        }

        // If already on Home tab → exit app
        SystemNavigator.pop();
      },

      child: Scaffold(
        /// ===========================
        /// BODY
        /// ===========================
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),


        /// RIGHT SIDE SLIDE MENU
        endDrawer: Drawer(
          backgroundColor: const Color(0xFF090210),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Header
              Container(
                width: 150,
                height: 110,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB974FF), Color(0xFFFFFFFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Image.asset(
                    'assets/images/logo.webp',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                height: 35,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF9144FF), Color(0xFFB974FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25)),
                ),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Bodmas Wealth",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 5),

              // Drawer Menu
              ...menuItems.map((item) => DrawerMenuTile(
                menuItem: item,
                selectedTitle: selectedMenu,
                onSelected: (title) {
                  setState(() {
                    selectedMenu = title;
                  });
                },
              )),
            ],
          ),
        ),

        /// ===========================
        /// BOTTOM NAVIGATION BAR
        /// ===========================
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },

          // Colors
          selectedItemColor: _selectedColor,
          unselectedItemColor: _unSelectedColor,

          // Label styles
          selectedLabelStyle: _selectedLabelStyle,
          unselectedLabelStyle: _unSelectedLabelStyle,

          // Icon sizes
          selectedIconTheme: const IconThemeData(size: _selectedIconSize),
          unselectedIconTheme: const IconThemeData(size: _unSelectedIconSize),

          type: BottomNavigationBarType.fixed,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.square),
              label: "Property",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Listing",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),

          ],
        ),
      ),
    );
  }
}



// 🔹 MenuItem Model
class MenuItem {
  final String title;
  final IconData icon;
  final List<MenuItem>? subMenu;
  final VoidCallback? onTap;

  MenuItem({
    required this.title,
    required this.icon,
    this.subMenu,
    this.onTap,
  });
}

// 🔹 Reusable Drawer Menu Tile
class DrawerMenuTile extends StatelessWidget {
  final MenuItem menuItem;
  final String? selectedTitle;
  final ValueChanged<String> onSelected;

  const DrawerMenuTile({
    super.key,
    required this.menuItem,
    required this.selectedTitle,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedTitle == menuItem.title;

    // Submenu handling
    if (menuItem.subMenu != null && menuItem.subMenu!.isNotEmpty) {
      return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          leading: Icon(menuItem.icon, color: const Color(0xFFB974FF), size: 16),
          title: Text(
            menuItem.title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          childrenPadding: const EdgeInsets.only(left: 40, right: 20),
          children: menuItem.subMenu!.map((subItem) {
            final bool isSubSelected = selectedTitle == subItem.title;
            return ListTile(
              title: Text(
                subItem.title,
                style: TextStyle(
                  color: isSubSelected ? Colors.white : const Color(0xFFFFFFFF),
                ),
              ),
              onTap: () {
                onSelected(subItem.title);
                Navigator.pop(context);
                if (subItem.onTap != null) subItem.onTap!();
              },
            );
          }).toList(),
        ),
      );
    }

    // Single menu item
    return ListTile(
      leading: Icon(menuItem.icon, color: const Color(0xFFB974FF), size: 16),
      title: Text(
        menuItem.title,
        style: TextStyle(
          fontSize: 14,
          color: isSelected ? Colors.white : Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: isSelected ? const Color(0xffb974ff).withAlpha(0) : null,
      onTap: () {
        onSelected(menuItem.title);
        Navigator.pop(context);
        if (menuItem.onTap != null) menuItem.onTap!();
      },
    );
  }
}