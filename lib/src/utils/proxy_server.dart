import 'dart:io';

class ProxyServer {
  late HttpServer proxyServer;

  final List<String> whiteList = [
    "127.0.0.1",
    "localhost",
    "tgk-wcaime.wahlap.com",
    "maimai.bakapiano.com",
    "www.diving-fish.com",
    "open.weixin.qq.com",
    "weixin110.qq.com",
    "res.wx.qq.com",
    "libs.baidu.com",
  ];

  Future<void> startProxyServer() async {
    proxyServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 2233);
    print("Proxy server listening on port 2233");

    await for (var request in proxyServer) {
      handleHttpRequest(request);
    }
  }

  bool checkHostInWhiteList(String? target) {
    if (target == null) return false;
    target = target.split(":")[0];
    return whiteList.contains(target);
  }

  Future<void> onAuthHook(Uri href) async {
    print("Successfully hook auth request!");
    print(href.toString());
  }

  Future<void> handleHttpRequest(HttpRequest request) async {
    try {
      final reqUrl = request.uri;

      if (!checkHostInWhiteList(reqUrl.host)) {
        request.response
          ..statusCode = HttpStatus.badRequest
          ..write("HTTP/1.1 400 Bad Request\r\n\r\n")
          ..close();
        return;
      }

      if (reqUrl
          .toString()
          .startsWith("http://tgk-wcaime.wahlap.com/wc_auth/oauth/callback")) {
        await onAuthHook(reqUrl);
        request.response
          ..statusCode = HttpStatus.found
          ..headers.set(HttpHeaders.locationHeader, "baidu.com")
          ..close();
        return;
      }

      final client = HttpClient();
      try {
        final clientRequest = await client.openUrl(request.method, reqUrl);

        request.headers.forEach((name, values) {
          for (var value in values) {
            clientRequest.headers.add(name, value);
          }
        });

        final clientResponse = await clientRequest.close();

        request.response
          ..statusCode = clientResponse.statusCode
          ..headers.clear();
        clientResponse.headers.forEach((name, values) {
          for (var value in values) {
            request.response.headers.add(name, value);
          }
        });

        await clientResponse.pipe(request.response);
      } catch (e) {
        print("Error handling proxy request: $e");
        request.response
          ..statusCode = HttpStatus.internalServerError
          ..write("An error occurred while processing the request.")
          ..close();
      } finally {
        client.close();
      }
    } catch (e) {
      print("Request handling error: $e");
    }
  }
}
