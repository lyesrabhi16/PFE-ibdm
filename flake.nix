{
  description = "IBDM dev environment (Django API + Flutter app)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true; # msodbcsql18 and the Android SDK are unfree
      };
      odbcDriver = pkgs.unixODBCDrivers.msodbcsql18;
    in {
      devShells.${system} = {
        # nix develop          -> backend + demo tooling
        default = pkgs.mkShell {
          packages = with pkgs; [
            python312 pipenv
            unixodbc odbcDriver
            openssl
            docker-compose
            nodejs_22 pnpm
          ];
          shellHook = ''
            # Register the SQL Server ODBC driver for pyodbc / mssql-django
            export ODBCSYSINI="$PWD/.nix-odbc"
            mkdir -p "$ODBCSYSINI"
            DRV=$(ls ${odbcDriver}/lib/libmsodbcsql-18*.so* | head -1)
            printf "[ODBC Driver 18 for SQL Server]\nDescription=Microsoft ODBC Driver 18 for SQL Server\nDriver=%s\n" "$DRV" > "$ODBCSYSINI/odbcinst.ini"
            echo "IBDM backend shell: $(python --version), docker compose demo -> docker compose -f demo/compose.yaml up --build"
          '';
        };

        # nix develop .#app    -> Flutter toolchain for frontend/ibdm (large download)
        app = pkgs.mkShell {
          packages = [ pkgs.flutter pkgs.chromium ];
          CHROME_EXECUTABLE = "${pkgs.chromium}/bin/chromium";
        };
      };
    };
}
