import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:nhac/nhac_logo.dart';
import 'package:nhac/botao_nhac.dart';

@NowaGenerated()
class BemVindo extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const BemVindo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          alignment: const Alignment(0.0, 0.0),
          children: [
            const Positioned(
              top: 47.0,
              left: 33.0,
              width: 132.0,
              height: 49.0,
              child: NhacLogo(),
            ),
            Positioned(
              top: 51.0,
              left: 205.0,
              height: 40.0,
              width: 172.0,
              child: GestureDetector(
                onTap: () {},
                child: ElevatedButton(
                  onPressed: () {},
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color?>(
                      Color(0xFFFFF5F5),
                    ),
                    foregroundColor: WidgetStatePropertyAll<Color?>(null),
                    shadowColor: WidgetStatePropertyAll<Color?>(
                      Color(0x00FFFFFF),
                    ),
                    elevation: WidgetStatePropertyAll<double?>(null),
                    side: WidgetStatePropertyAll<BorderSide?>(null),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder?>(
                      null,
                    ),
                  ),
                  child: const Text(
                    '       Para Entregadores',
                    style: TextStyle(
                      color: Color(0xFF7C6F6F),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ),
            const Positioned(
              top: 64.5,
              left: 336.0,
              width: 15.0,
              height: 15.0,
              child: Image(
                image: AssetImage('assets/Arrow right (3).png'),
                fit: BoxFit.cover,
              ),
            ),
            const Positioned(
              top: 157.0,
              left: -39.0,
              width: 432.0,
              height: 394.0,
              child: Image(
                image: AssetImage('assets/lanche-bem-vindo.png'),
                fit: BoxFit.cover,
              ),
            ),
            const Positioned(
              top: 528.0,
              left: 46.0,
              width: 323.0,
              height: 34.0,
              child: Text(
                'O Nhac que sua fome pedia',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Color(0xFF5D201C),
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Positioned(
              top: 562.0,
              left: 19.0,
              width: 355.0,
              height: 45.0,
              child: Text(
                'Encontre os melhores restaurantes locais e peça sua comida favorita com rapidez e facilidade.',
                style: TextStyle(
                  color: Color(0x995D201C),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Positioned(
              top: 660.0,
              left: 21.0,
              height: 49.0,
              width: 351.0,
              child: BotaoNhac(),
            ),
          ],
        ),
      ),
    );
  }
}
