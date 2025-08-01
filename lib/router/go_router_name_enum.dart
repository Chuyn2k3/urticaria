enum GoRouterName { login, register, home }

extension GoRouterNameX on GoRouterName {
  String get routeName => name;

  String get routePath {
    switch (this) {
      case GoRouterName.login:
        return "/login";
      case GoRouterName.register:
        return "/register";
      case GoRouterName.home:
        return "/home";
    }
  }
}
