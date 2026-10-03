/// Model for menu items used in InboxCard
class MenuItem {
  final String name;
  final Function() onTap;

  MenuItem({
    required this.name,
    required this.onTap,
  });
}

