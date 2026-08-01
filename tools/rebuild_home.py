from pathlib import Path

app = Path("lib/app.dart")

app.write_text(r'''
import 'package:flutter/material.dart';

void main() => runApp(const EmanExperienceApp());

class EmanExperienceApp extends StatelessWidget {
  const EmanExperienceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EMAN',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xff0b5ed7),
        fontFamily: 'Arial',
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f9fc),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.symmetric(horizontal:40,vertical:22),
              color: Colors.white,
              child: Row(
                children: [
                  Image.asset(
                    "assets/logos/Eman logo.png",
                    height: 42,
                  ),
                  const Spacer(),
                  const Text("Products"),
                  const SizedBox(width:30),
                  const Text("Private Label"),
                  const SizedBox(width:30),
                  const Text("Export"),
                  const SizedBox(width:30),
                  FilledButton(
                    onPressed: (){},
                    child: const Text("Request Quote"),
                  )
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(70),
              child: Row(
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "GLOBAL FOOD MANUFACTURER",
                          style: TextStyle(
                            letterSpacing:2,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height:25),

                        const Text(
                          "Manufacturing\nfor the world.",
                          style: TextStyle(
                            fontSize:62,
                            fontWeight: FontWeight.w900,
                            height:1,
                          ),
                        ),

                        const SizedBox(height:25),

                        const Text(
                          "Premium beverage manufacturer supplying wholesalers, distributors and private label partners.",
                          style: TextStyle(fontSize:20),
                        ),

                        const SizedBox(height:40),

                        Row(
                          children:[
                            FilledButton(
                              onPressed:(){},
                              child:const Text("Explore Products"),
                            ),
                            const SizedBox(width:20),
                            OutlinedButton(
                              onPressed:(){},
                              child:const Text("Become Partner"),
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [

                        Container(
                          height:520,
                          decoration: BoxDecoration(
                            color: const Color(0xffeef6ff),
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),

                        Image.asset(
                          "assets/products/friocups/9g-orange-flavored-powder-drink-friocups.png",
                          height:340,
                        ),

                      ],
                    ),
                  )

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
''')

print("DONE")
