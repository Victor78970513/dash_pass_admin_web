import 'package:dash_pass_web/features/users/presentation/cubits/filter_users/filter_users_cubit.dart';
import 'package:dash_pass_web/features/users/presentation/cubits/users/users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterUsersModal extends StatelessWidget {
  const FilterUsersModal({super.key});

  @override
  Widget build(BuildContext context) {
    final filtersCubit = context.watch<FilterUsersCubit>();
    return Dialog(
      child: IntrinsicHeight(
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Filtrar",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(),
                _buildSectionTitle("Estado"),
                BlocBuilder<FilterUsersCubit, FilterUsersState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        FilterOption(
                          title: "Todos",
                          onTap: () => filtersCubit.updateAccountState("Todos"),
                          isSelected: state.accountState == "Todos",
                        ),
                        FilterOption(
                          title: "Activos",
                          onTap: () =>
                              filtersCubit.updateAccountState("Activos"),
                          isSelected: state.accountState == "Activos",
                        ),
                        FilterOption(
                          title: "Inactivos",
                          onTap: () =>
                              filtersCubit.updateAccountState("Inactivos"),
                          isSelected: state.accountState == "Inactivos",
                        ),
                      ],
                    );
                  },
                ),
                const Divider(),
                _buildSectionTitle("Rol"),
                BlocBuilder<FilterUsersCubit, FilterUsersState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        FilterOption(
                          title: "Todos",
                          onTap: () => filtersCubit.updateRole(0),
                          isSelected: state.roleId == 0,
                        ),
                        FilterOption(
                          title: "Conductor",
                          onTap: () => filtersCubit.updateRole(4),
                          isSelected: state.roleId == 4,
                        ),
                        FilterOption(
                          title: "Administrador",
                          onTap: () => filtersCubit.updateRole(2),
                          isSelected: state.roleId == 2,
                        ),
                        FilterOption(
                          title: "Super Administrador",
                          onTap: () => filtersCubit.updateRole(1),
                          isSelected: state.roleId == 1,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    context.read<UsersCubit>().fetchUsersWithFilters(
                          filtersCubit.state.accountState == "Todos"
                              ? null
                              : filtersCubit.state.accountState == "Activos"
                                  ? true
                                  : false,
                          filtersCubit.state.roleId == 0
                              ? null
                              : filtersCubit.state.roleId,
                        );
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(42, 63, 129, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Aplicar",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class FilterOption extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final bool isSelected;
  const FilterOption(
      {super.key, required this.title, this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color.fromRGBO(42, 63, 129, 1)
                      : Colors.transparent,
                  border: Border.all(color: Colors.black),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                      ),
                    ),
                  ],
                )),
          ),
          const SizedBox(width: 20),
          Text(title)
        ],
      ),
    );
  }
}
