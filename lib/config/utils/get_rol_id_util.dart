int getRolIdUtil(String value) {
  switch (value) {
    case "Super Administrador":
      return 1;
    case "Administrador":
      return 2;

    case "Conductor":
      return 4;

    default:
      return 4;
  }
}

String getRolNameById(int value) {
  switch (value) {
    case 1:
      return "Super Administrador";
    case 2:
      return "Administrador";
    case 4:
      return "Conductor";
    default:
      return "Conductor";
  }
}
