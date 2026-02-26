import 'package:bodmas_wealth/core/colors.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  final String headerImage =
      'https://www.bodmaswealth.com/assets/AboutUs-Banner-DTOEM2oG.jpg'; // image URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(title: const Text("About Us"),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header image with overlay text
            Stack(
              children: [
                SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: Image.network(
                    headerImage,
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.darken,
                    color: Colors.black.withAlpha(20), // 128 is ~50% opacity
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Us',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black54,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white70,
                            size: 18,
                          ),
                          Text(
                            'About Us',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'HOUSING FINANCING',
                    style: TextStyle(
                      color: Color(0xFFB974FF),
                      letterSpacing: 2,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: 'Financial ',
                          style: TextStyle(
                            color: Color(0xFFA684FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: 'Products and Service Provider Company',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 10),

            // Info box with description
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bodmas Wealth founded in 2024 , is committed to offering tailored financial solutions designed to meet the diverse needs of '
                        'individuals. Led by Ashok Kumar, who brings 18 years of extensive experience in banking and finance, Bodmas Wealth provides a '
                        'comprehensive range of services aimed at facilitating financial growth and long-term security.Our core offerings include educational loans, '
                        'enabling students to pursue higher education without financial constraints, personal loans designed to address individual financial requirements, '
                        'and housing loans that make homeownership achievable through flexible and reliable property financing solutions. Bodmas Wealth focuses '
                        'on fostering long-term wealth creation by offering strategic guidance in stock market investments, mutual funds, and equity. Our '
                        'objective is to assist clients in making informed investment decisions, ensuring the growth and protection of their wealth over time.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'At Bodmas Wealth, we pride ourselves on providing expert-driven financial solutions that are customized to align with each '
                        'client’s goals. Our commitment is to deliver excellence, reliability,'
                        ' and strategic advice that will support the financial aspirations of our clients and contribute to their continued success.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}