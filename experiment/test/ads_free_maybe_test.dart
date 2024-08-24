import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ad Blocker WebView',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AdBlockerWebView(),
    );
  }
}

class AdBlockerWebView extends StatefulWidget {
  @override
  _AdBlockerWebViewState createState() => _AdBlockerWebViewState();
}

class _AdBlockerWebViewState extends State<AdBlockerWebView> {
  late WebViewController _controller;
  final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ad Blocker WebView')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: InputDecoration(hintText: 'Enter URL'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    String url = _urlController.text;
                    if (!url.startsWith('http://') && !url.startsWith('https://')) {
                      url = 'https://' + url;
                    }
                    _controller.loadUrl(url);
                  },
                  child: Text('Go'),
                ),
              ],
            ),
          ),
          Expanded(
            child: WebView(
              initialUrl: 'https://www.google.com',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
              },
              onPageFinished: (_) {
                _injectAdBlocker();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _injectAdBlocker() {
    _controller.runJavascript('''
      (function() {
        const adSelectors = [
          'iframe[src*="googleadservices"]',
          'iframe[src*="doubleclick"]',
          'iframe[data-ad-client]',
          'ins.adsbygoogle',
          'div[id^="google_ads_iframe_"]',
          'div[id^="div-gpt-ad"]',
          '.ad',
          '.ads',
          '.advert',
          '.advertisement',
          '#ad',
          '#ads',
          '#advert',
          '#advertisement'
        ];

        const css = adSelectors.map(selector => \`\${selector} { display: none !important; }\`).join('\\n');

        const style = document.createElement('style');
        style.type = 'text/css';
        style.appendChild(document.createTextNode(css));
        document.head.appendChild(style);

        const removeAds = () => {
          adSelectors.forEach(selector => {
            document.querySelectorAll(selector).forEach(el => {
              el.style.display = 'none';
              el.remove();
            });
          });
        };

        removeAds();

        const observer = new MutationObserver(() => {
          removeAds();
        });

        observer.observe(document.body, {
          childList: true,
          subtree: true
        });
      })();
    ''');
  }
}
