{
  git = {
    name = "hkalbasi";
    email = "hamidrezakalbasi@protonmail.com";
  };
  proxychains = {
    enable = true;
    proxies = {
      wifi = {
        enable = true;
        type = "socks5";
        host = "127.0.0.1";
        port = 1089;
      };
    };
  };
}
