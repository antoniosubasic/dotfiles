{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  unzip,
  openjdk17,
  desktop-file-utils,
  copyDesktopItems,
  makeDesktopItem,
  scale ? null,
}:

stdenv.mkDerivation rec {
  pname = "sqldeveloper";
  version = "24.3.1.347.1826";

  src = fetchurl {
    url = "https://download.oracle.com/otn_software/java/sqldeveloper/sqldeveloper-${version}-no-jre.zip";
    sha1 = "38cab3650bcc67cd8af4f7ca54a6a5413bbba61c";
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
    desktop-file-utils
    copyDesktopItems
  ];

  buildInputs = [
    openjdk17
  ];

  unpackPhase = ''
    runHook preUnpack
    unzip -q $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/sqldeveloper,share/pixmaps,share/icons/hicolor/48x48/apps}

    cp -r sqldeveloper/* $out/share/sqldeveloper/

    chmod +x $out/share/sqldeveloper/sqldeveloper.sh

    makeWrapper $out/share/sqldeveloper/sqldeveloper.sh $out/bin/sqldeveloper \
      --set JAVA_HOME "${openjdk17}" \
      --set _JAVA_AWT_WM_NONREPARENTING 1 \
      --prefix PATH : "${openjdk17}/bin" \
      ${lib.optionalString (scale != null) "--set GDK_SCALE \"${toString scale}\""}

    if [ -f $out/share/sqldeveloper/doc/icon.png ]; then
      cp $out/share/sqldeveloper/doc/icon.png $out/share/pixmaps/sqldeveloper.png
      cp $out/share/sqldeveloper/doc/icon.png $out/share/icons/hicolor/48x48/apps/sqldeveloper.png
    fi

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem rec {
      name = "sqldeveloper";
      exec = name;
      icon = name;
      desktopName = "Oracle SQL Developer";
      comment = "Oracle SQL Developer - Database IDE";
      categories = [
        "Development"
        "Database"
        "IDE"
      ];
      startupWMClass = "oracle-sqldeveloper";
      mimeTypes = [ "application/sql" ];
    })
  ];

  meta = with lib; {
    description = "Oracle SQL Developer - A free integrated development environment for Oracle Database";
    longDescription = ''
      Oracle SQL Developer is a free, integrated development environment that
      simplifies the development and management of Oracle Database in both
      traditional and Cloud deployments. SQL Developer offers complete
      end-to-end development of your PL/SQL applications, a worksheet for
      running queries and scripts, a DBA console for managing the database,
      a reports interface, a complete data modeling solution, and a migration
      platform for moving your 3rd party databases to Oracle.
    '';
    homepage = "https://www.oracle.com/database/sqldeveloper/";
    downloadPage = "https://www.oracle.com/database/sqldeveloper/technologies/download/";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
}
