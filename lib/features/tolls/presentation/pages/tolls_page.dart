import 'package:dash_pass_web/config/shared_preferences/preferences.dart';
import 'package:dash_pass_web/features/tolls/presentation/cubits/tolls/tolls_cubit.dart';
import 'package:dash_pass_web/features/tolls/presentation/pages/create_toll_page.dart';
import 'package:dash_pass_web/features/tolls/presentation/widgets/toll_card_widget.dart';
import 'package:dash_pass_web/features/tolls/presentation/widgets/tolls_loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TollsPage extends StatelessWidget {
  static const name = "/tolls-page";
  const TollsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rolId = Preferences().userRolId;
    return rolId == 1 ? const SuperAdminTollsPage() : const AdminTollsPage();
  }
}

class SuperAdminTollsPage extends StatefulWidget {
  const SuperAdminTollsPage({super.key});

  @override
  State<SuperAdminTollsPage> createState() => _SuperAdminTollsPageState();
}

class _SuperAdminTollsPageState extends State<SuperAdminTollsPage> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  @override
  void initState() {
    context.read<TollsCubit>().fetchTolls();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final tollsCubit = context.watch<TollsCubit>().tollsQuantity;
    return Container(
      color: const Color(0xffF4F4F4),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Puntos de peajes",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                  ),
                ),
                const Spacer(),
                Text(
                  "$tollsCubit ${tollsCubit > 1 ? 'peajes' : 'peaje'}",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 20),
                Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 60,
                    width: size.width * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.black54),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            style: GoogleFonts.poppins(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: "Buscar peaje por nombre",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(15),
                  child: GestureDetector(
                    onTap: () => context.goNamed(CreateTollPage.name),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C3C63),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.road,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              "Agregar peaje",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: BlocBuilder<TollsCubit, TollsState>(
                builder: (context, state) {
                  switch (state) {
                    case TollsInitial():
                    case TollsLoading():
                      return const TollsLoadingShimmer();
                    case TollsError(message: final message):
                      return Center(
                        child: Text(message),
                      );
                    case TollsLoaded():
                      final tolls = state.tolls.where((toll) {
                        return toll.name.toLowerCase().contains(searchQuery);
                      }).toList();
                      final screenWidth = MediaQuery.of(context).size.width;
                      final availableWidth = screenWidth - 300;
                      final cardWidth = (availableWidth / 2) - 100;

                      return Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.start,
                        children: tolls.map((toll) {
                          return TollCardWidget(
                            toll: toll,
                            width: cardWidth,
                          );
                        }).toList(),
                      );
                    case TollAddedState():
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminTollsPage extends StatefulWidget {
  const AdminTollsPage({super.key});

  @override
  State<AdminTollsPage> createState() => _AdminTollsPageState();
}

class _AdminTollsPageState extends State<AdminTollsPage> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  @override
  void initState() {
    context.read<TollsCubit>().fetchTollsWithAdmin();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tollsCubit = context.watch<TollsCubit>().tollsQuantity;
    final size = MediaQuery.of(context).size;
    return Container(
      color: const Color(0xffF4F4F4),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Puntos de peajes",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                  ),
                ),
                const Spacer(),
                Text(
                  "$tollsCubit ${tollsCubit > 1 ? 'peajes' : 'peaje'}",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 20),
                Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 60,
                    width: size.width * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.black54),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            style: GoogleFonts.poppins(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: "Buscar peaje por nombre",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(15),
                  child: GestureDetector(
                    onTap: () => context.goNamed(CreateTollPage.name),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C3C63),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.road,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              "Agregar peaje",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: BlocBuilder<TollsCubit, TollsState>(
                builder: (context, state) {
                  switch (state) {
                    case TollsInitial():
                    case TollsLoading():
                      return const TollsLoadingShimmer();
                    case TollsError(message: final message):
                      return Center(
                        child: Text(message),
                      );
                    case TollsLoaded():
                      final tolls = state.tolls.where((toll) {
                        return toll.name.toLowerCase().contains(searchQuery);
                      }).toList();
                      final screenWidth = MediaQuery.of(context).size.width;
                      final availableWidth = screenWidth - 300;
                      final cardWidth = (availableWidth / 2) - 100;

                      return Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.start,
                        children: tolls.map((toll) {
                          return TollCardWidget(
                            toll: toll,
                            width: cardWidth,
                          );
                        }).toList(),
                      );
                    case TollAddedState():
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
