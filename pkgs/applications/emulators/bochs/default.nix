{ lib
, stdenv
, fetchurl
, docbook_xml_dtd_45
, docbook_xsl
, libtool
, pkg-config
, curl
, readline
, wget
, libobjc
, enableX11 ? !stdenv.isDarwin
, libGL
, libGLU
, libX11
, libXpm
, enableSdl2 ? true
, SDL2
, enableTerm ? true
, ncurses
, enableWx ? !stdenv.isDarwin
, wxGTK
, gtk3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bochs";
  version = "2.7";

  src = fetchurl {
    url = "mirror://sourceforge/project/${finalAttrs.pname}/${finalAttrs.pname}/${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-oBCrG/3HKsWgjS4kEs1HHA/r1mrx2TSbwNeWh53lsXo=";
  };

  nativeBuildInputs = [
    docbook_xml_dtd_45
    docbook_xsl
    libtool
    pkg-config
  ];

  buildInputs = [
    curl
    readline
    wget
  ] ++ lib.optionals stdenv.isDarwin [
    libobjc
  ] ++ lib.optionals enableX11 [
    libGL
    libGLU
    libX11
    libXpm
  ] ++ lib.optionals enableSdl2 [
    SDL2
  ] ++ lib.optionals enableTerm [
    ncurses
  ] ++ lib.optionals enableWx [
    wxGTK
    gtk3
  ];

  configureFlags = [
    "--with-rfb=no"
    "--with-vncsrv=no"
    "--with-nogui"

    # These will always be "yes" on NixOS
    "--enable-ltdl-install=yes"
    "--enable-readline=yes"
    "--enable-all-optimizations=yes"
    "--enable-logging=yes"
    "--enable-xpm=yes"

    # ... whereas these, always "no"!
    "--enable-cpp=no"
    "--enable-instrumentation=no"

    "--enable-docbook=no" # Broken - it requires docbook2html

    # Dangerous options - they are marked as "incomplete/experimental" on Bochs documentation
    "--enable-3dnow=no"
    "--enable-monitor-mwait=no"
    "--enable-raw-serial=no"

    # These are completely configurable, and they don't depend of external tools
    "--enable-a20-pin"
    "--enable-avx"
    "--enable-busmouse"
    "--enable-cdrom"
    "--enable-clgd54xx"
    "--enable-configurable-msrs"
    "--enable-cpu-level=6" # from 3 to 6
    "--enable-debugger" #conflicts with gdb-stub option
    "--enable-debugger-gui"
    "--enable-evex"
    "--enable-fpu"
    "--enable-gdb-stub=no" # conflicts with debugger option
    "--enable-handlers-chaining"
    "--enable-idle-hack"
    "--enable-iodebug"
    "--enable-large-ramfile"
    "--enable-largefile"
    "--enable-pci"
    "--enable-repeat-speedups"
    "--enable-show-ips"
    "--enable-smp"
    "--enable-vmx=2"
    "--enable-svm"
    "--enable-trace-linking"
    "--enable-usb"
    "--enable-usb-ehci"
    "--enable-usb-ohci"
    "--enable-usb-xhci"
    "--enable-voodoo"
    "--enable-x86-64"
    "--enable-x86-debugger"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "--enable-e1000"
    "--enable-es1370"
    "--enable-ne2000"
    "--enable-plugins"
    "--enable-pnic"
    "--enable-sb16"
  ] ++ lib.optionals enableX11 [
    "--with-x"
    "--with-x11"
  ] ++ lib.optionals enableSdl2 [
    "--with-sdl2"
  ] ++ lib.optionals enableTerm [
    "--with-term"
  ] ++ lib.optionals enableWx [
    "--with-wx"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://bochs.sourceforge.io/";
    description = "An open-source IA-32 (x86) PC emulator";
    longDescription = ''
      Bochs is an open-source (LGPL), highly portable IA-32 PC emulator, written
      in C++, that runs on most popular platforms. It includes emulation of the
      Intel x86 CPU, common I/O devices, and a custom BIOS.
    '';
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
})
# TODO: a better way to organize the options
# TODO: docbook (docbook-tools from RedHat mirrors should help)
