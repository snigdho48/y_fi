import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class AdBanner extends StatelessWidget {
  final double width;
  final double height;
  final String content; // <-- Default iframe URL
  final String adUrl;
  final String? adheight;
  final String? adwidth;

  AdBanner({
    required this.width,
    required this.height,
    required this.content , // <-- Pass the iframe URL dynamically
    required this.adUrl,
    this.adheight,
    this.adwidth,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri.uri(
          Uri.parse(content),
        )),
        initialSettings: InAppWebViewSettings(
          useWideViewPort: false,
          loadWithOverviewMode: false,
          supportZoom: false,
          displayZoomControls: false,
          builtInZoomControls: false,
          transparentBackground: true,
          allowsInlineMediaPlayback: true,
          allowUniversalAccessFromFileURLs: true,
          mediaPlaybackRequiresUserGesture: false, // Disable for autoplay
          allowContentAccess: true,
          allowFileAccess: true,
          javaScriptCanOpenWindowsAutomatically: true,
          javaScriptEnabled: true,
          mixedContentMode:MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW, 
          
           // Enable mixed content
        ),
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
            return ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED);

        },
      

        initialData: InAppWebViewInitialData(
          data: """
          <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
            <style>
              * { margin: 0; padding: 0; border: 0; box-sizing: border-box; }
              html, body { width: 100%; height: 100%; overflow: hidden; cursor: pointer; background: transparent; }
              .ad-container { width: ${width}px; height: ${height}px; position: relative; display:flex; justify-content: center; align-items: center; }
              .ad-overlay {
                position: absolute; top: 0; left: 0; width: 100%; height: 100%;
                background: rgba(0, 0, 0, 0); z-index: 2; cursor: pointer;
              }
              iframe {width: ${adwidth ?? width}px; height: ${adheight?? height}px;  border: none; position: relative; z-index: 1; }
            </style>
            <script>
              function openAd() {
                window.flutter_inappwebview.callHandler('openAd', '$adUrl');
              }
            </script>
          </head>
          <body>
            <div class="ad-container">
              <iframe src="$content"></iframe> 
              <div class="ad-overlay" onclick="openAd()"></div>
            </div>
          </body>
          </html>
          """,
        ),
        onWebViewCreated: (controller) {
          controller.addJavaScriptHandler(
            handlerName: 'openAd',
            callback: (args) {
              _openAd(args[0]);
            },
          );
        },
      ),
    );
  }

  void _openAd(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}

