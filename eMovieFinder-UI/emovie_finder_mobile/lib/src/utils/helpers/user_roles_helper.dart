class UserRoles {
  static final List<String> roles = ['User', 'Administrator', 'Customer'];

  static bool hasValidRole(dynamic userRole) {
    if (userRole is List) {
      return userRole.any((role) => roles.contains(role));
    } else if (userRole is String) {
      return roles.contains(userRole);
    }
    return false;
  }
}
