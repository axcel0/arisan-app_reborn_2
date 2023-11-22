import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:arisan_app_reborn/blocs/peserta_bloc.dart';
import 'cubit/theme_mode_cubit.dart';
import 'data_kocok.dart';
import 'data_pemenang.dart';
import 'data_peserta.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory()
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeData _lightTheme;
  late ThemeData _darkTheme;

  @override
  void initState() {
    super.initState();
    _lightTheme = _buildLightTheme();
    _darkTheme = _buildDarkTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PesertaBloc>(
          create: (context) => PesertaBloc(),
        ),
        BlocProvider(
          create: (context) => ThemeModeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeModeCubit, ThemeMode>(
        builder: (context, state) {
          return AnimatedTheme(
            data: state == ThemeMode.light ? _lightTheme : _darkTheme,
            duration: const Duration(milliseconds: 200),
            child: MaterialApp(
              theme: _lightTheme,
              darkTheme: _darkTheme,
              themeMode: state,
              title: 'Arisan Software',
              home: const MyHomePage(title: 'Arisan Software'),
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme,
      ),
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white38,
        accentColor: Colors.white12,
        cardColor: Colors.blueGrey.shade50,
        errorColor: Colors.red,
      ),
      primaryTextTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        bodyLarge: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black87),
        titleSmall: TextStyle(color: Colors.black),
        bodySmall: TextStyle(color: Colors.black),
        labelLarge: TextStyle(color: Colors.black),
        labelSmall: TextStyle(color: Colors.black),
      ),
      useMaterial3: true,
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme,
      ),
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        backgroundColor: Colors.black87,
        accentColor: Colors.white12,
        cardColor: Colors.blueGrey.shade900,
        errorColor: Colors.red,
      ),
      primaryTextTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white70),
        titleSmall: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white),
        labelLarge: TextStyle(color: Colors.white),
        labelSmall: TextStyle(color: Colors.white),
      ),
      useMaterial3: true,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _buildIconButton(context),
        ],
        title: Text(widget.title),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (MediaQuery.of(context).orientation == Orientation.portrait) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _buildButtons(context),
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _buildButtons(context),
              );
            }
          },
        ),
      ),
    );
  }

  IconButton _buildIconButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<ThemeModeCubit>().toggleBrightness();
      },
      icon: BlocBuilder<ThemeModeCubit, ThemeMode>(
        builder: (context, state) {
          return state == ThemeMode.light ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode);
        },
      ),
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    return [
      _buildButton(
        context,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const DataPeserta()));
        },
        icon: Icons.people_alt_rounded,
        color: Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.blueAccent : Colors.indigo,
        text: "Participant",
      ),
      const SizedBox(
        width: 10,
        height: 10,
      ),
      _buildButton(
        context,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const DataPemenang()));
        },
        icon: Icons.workspace_premium_rounded,
        color: Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.amber : Colors.orange,
        text: "Winner",
      ),
      const SizedBox(
        width: 10,
        height: 10,
      ),
      _buildButton(
        context,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DataKocok()));
        },
        icon: Icons.shuffle_rounded,
        color: Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.blue : Colors.teal,
        text: "Shuffle",
      ),
    ];
  }

  Widget _buildButton(BuildContext context, {required VoidCallback onPressed, required IconData icon, required Color color, required String text}) {
    return SizedBox(
      width: 150,
      height: 180,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(icon, size: 75, color: color),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).primaryTextTheme.titleMedium!.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}