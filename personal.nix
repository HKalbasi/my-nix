{
  git = {
    name = "hkalbasi";
    email = "hamidrezakalbasi@protonmail.com";
  };
  proxychains = {
    enable = true;
    proxies = {
      wifi = {
        enable = false;
        type = "socks5";
        host = "192.168.1.150";
        port = 10808;
      };
      wifi2 = {
        enable = true;
        type = "socks5";
        host = "192.168.1.11";
        port = 10808;
      };
    };
  };
}
