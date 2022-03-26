import 'package:flutter/material.dart';
import 'web_view_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialPage extends StatelessWidget {
  final _instagram = ['https://www.instagram.com/cchs165/?hl=en'];
  final _twitter = ['https://twitter.com/cchs165'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _twitter
                    .map((link) => _twitterButton(context, link))
                    .toList(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _instagram
                    .map((link) => _instagramButton(context, link))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

// widget for the instagram button
  Widget _instagramButton(BuildContext context, String url) {
    int index = 0;
    return Center(
      heightFactor: 2,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: const Color(0xff333333),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          leading: GradientIcon(
            FontAwesomeIcons.instagram,
            40.0,
            const LinearGradient(
              colors: <Color>[
                Color(0xffF58529),
                Color(0xffDD2A7B),
                Color(0xff8134AF),
                Color(0xff515BD4),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          title: const Text.rich(
            TextSpan(
              style: TextStyle(
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text: 'View the CCHS Instagram',
                ),
              ],
            ),
          ),
          onTap: () => _handleURLButtonPress(context, url, index),
        ),
      ),
    );
  }

// widget for the twitter button
  Widget _twitterButton(BuildContext context, String url) {
    int index = 1;
    return Center(
      heightFactor: 2,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: const Color(0xff333333),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          leading: const FaIcon(
            FontAwesomeIcons.twitter,
            color: Colors.blue,
          ),
          title: const Text.rich(
            TextSpan(
              style: TextStyle(
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text: 'View the CCHS Twitter',
                ),
              ],
            ),
          ),
          onTap: () => _handleURLButtonPress(context, url, index),
        ),
      ),
    );
  }

  //onPressed: () => _handleURLButtonPress(context, url),
  void _handleURLButtonPress(BuildContext context, String url, int index) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url, index)));
  }
}

// This is for mapping gradients to icons
// this is only used on the instagram icon for now
class GradientIcon extends StatelessWidget {
  const GradientIcon(
    this.icon,
    this.size,
    this.gradient,
  );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: FaIcon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}
