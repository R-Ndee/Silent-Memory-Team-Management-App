import 'package:flutter/material.dart';
import '../../widgets/error_state.dart';

/// 404 / Not Found Screen.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: ErrorState(
          title: 'Halaman Tidak Ditemukan',
          message: 'Halaman yang Anda cari tidak tersedia atau Anda tidak memiliki akses.',
        ),
      ),
    );
  }
}
