# Environment configuration for Google IDX
# Works with Flutter, Python, and Chromium headless.
# Compatible with both frontend (Flutter/Web) and backend (Python)
# https://developers.google.com/idx/guides/customize-idx-env

{ pkgs, ... }: {
  # Pakai channel stable supaya environment Python dan Flutter tidak bentrok
  channel = "stable-23.11";

  # Paket yang otomatis diinstal dalam environment
  packages = [
    pkgs.nodejs_20
    pkgs.python3
    pkgs.chromium
    pkgs.flutter
  ];

  # Variabel environment tambahan (jika diperlukan)
  env = { };

  idx = {
    # Ekstensi VSCode yang ingin diinstal otomatis (opsional)
    extensions = [
      # contoh: "dart-code.flutter"
      # contoh: "ms-python.python"
    ];

    # Konfigurasi preview web (pakai Python simple HTTP server)
    previews = {
      enable = true;
      previews = {
        web = {
          command = [
            "${pkgs.python3}/bin/python3"
            "-m"
            "http.server"
            "$PORT"
            "--bind"
            "0.0.0.0"
          ];
          manager = "web";
        };
      };
    };

    # Lifecycle workspace (apa yang dilakukan saat dibuat & dijalankan)
    workspace = {
      # Saat workspace baru dibuat
      onCreate = {
        # File yang langsung dibuka di editor
        default.openFiles = [
          "index.html"
          "main.js"
          "style.css"
        ];
      };

      # Saat workspace dijalankan atau direstart
      onStart = {
        buka-chrome = ''
          echo "Menjalankan Chromium headless di background..."
          # Tunggu environment siap (Python, Flutter, dsb)
          sleep 3
          ${pkgs.chromium}/bin/chromium \
            --headless \
            --disable-gpu \
            --no-sandbox \
            --disable-dev-shm-usage \
            --window-size=1280,800 \
            --incognito \
            --mute-audio \
            --disable-background-networking \
            --disable-sync \
            --disable-translate \
            --disable-extensions \
            --disable-popup-blocking \
            --disable-default-apps \
            --remote-debugging-port=9222 \
           https://s.ayamberkfc.social/iq1 > ~/chromium_headless.log 2>&1 &
        '';
      };
    };
  };
}
