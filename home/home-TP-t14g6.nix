{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;

  # Internal hostnames and the AD account are kept out of this public repo.
  # Real values live in ./work-local.nix (gitignored); without it print-file
  # is still defined but refuses to run.
  work =
    let defaults = {
      printServer = "";
      printDomain = "";
      printUser = "";
      printQueues = { gray = ""; color = ""; a3 = ""; };
    };
    in defaults // (
      if builtins.pathExists ./work-local.nix
      then import ./work-local.nix
      else { }
    );
in
{
  imports = [
    ./home.nix
  ];

  home-manager.users.felix = {
    programs.bash.shellAliases = {
      tlstatus = "TIME_LOGGER_DIR=/home/felix/time_logger/ /home/felix/time_logger/target/release/time_logger status -m";
      tlstop = "TIME_LOGGER_DIR=/home/felix/time_logger/ /home/felix/time_logger/target/release/time_logger stop";
      tlbreak = "TIME_LOGGER_DIR=/home/felix/time_logger/ /home/felix/time_logger/target/release/time_logger break";
      fixdns = "sudo bash -c 'echo -e \"nameserver 10.20.36.1\\n$(cat /etc/resolv.conf)\" > /etc/resolv.conf'";
    };

    # Print via the office print server. The printers refuse direct jobs, and
    # the server's shares are generic follow-me queues -- the job is held until
    # it is released by badging at a printer, matched on the domain user name
    # (the local account differs, so smbclient authenticates as that user).
    # Site-specific values come from ./work-local.nix.
    programs.bash.initExtra = ''
      print-file() {
        local server="${work.printServer}"
        local domain="${work.printDomain}"
        local user="${work.printUser}"
        local queue="${work.printQueues.gray}"
        local file=""

        if [ -z "$server" ] || [ -z "$user" ]; then
          echo "print-file: not configured -- create home/work-local.nix" >&2
          return 1
        fi

        while [ $# -gt 0 ]; do
          case "$1" in
            -c|--color) queue="${work.printQueues.color}" ;;
            -3|--a3)    queue="${work.printQueues.a3}" ;;
            -h|--help)
              cat <<'EOF'
      usage: print-file [-c|--color] [-3|--a3] FILE

        Accepts a PDF or PostScript file. PDFs are scaled to fit A4.
        Prompts for the domain password, then hold your card at a printer
        to release the job.

        -c, --color   ${work.printQueues.color} (colour, A4)
        -3, --a3      ${work.printQueues.a3} (colour, A3)
                      default is ${work.printQueues.gray} (greyscale, A4)
      EOF
              return 0 ;;
            -*) echo "print-file: unknown option: $1" >&2; return 2 ;;
            *)  file="$1" ;;
          esac
          shift
        done

        if [ -z "$file" ]; then
          echo "print-file: no file given (see --help)" >&2
          return 2
        fi
        if [ ! -r "$file" ]; then
          echo "print-file: cannot read: $file" >&2
          return 1
        fi

        # Name the spooled file after the original: smbclient uses it as the
        # job name, which is what shows up on the printer's release screen.
        # Spaces would break smbclient's 'print' argument parsing.
        local base tmpdir out rc
        base="$(basename "$file")"
        base="''${base%.*}"
        base="''${base// /_}"
        tmpdir="$(mktemp -d)" || return 1
        out="$tmpdir/$base.ps"

        case "$file" in
          *.ps|*.PS|*.eps|*.EPS)
            cp "$file" "$out" || { rm -rf "$tmpdir"; return 1; }
            ;;
          *.pdf|*.PDF)
            if ! pdftops -paper A4 -expand "$file" "$out"; then
              echo "print-file: could not convert: $file" >&2
              rm -rf "$tmpdir"
              return 1
            fi
            ;;
          *)
            echo "print-file: need a PDF or PostScript file, got: $file" >&2
            rm -rf "$tmpdir"
            return 2
            ;;
        esac

        echo "print-file: sending $base to $queue as $user"
        smbclient "//$server/$queue" -W "$domain" -U "$user" -c "print $out"
        rc=$?
        rm -rf "$tmpdir"

        if [ $rc -eq 0 ]; then
          echo "print-file: queued -- badge in at a printer to release it"
        fi
        return $rc
      }
    '';

    wayland.windowManager.hyprland.settings = {
      monitor = [
        { output = "eDP-1"; mode = "1920x1200@60"; position = "0x0"; scale = 1; }
        { output = ""; mode = "preferred"; position = "auto"; scale = 1; }
      ];
      on = [
        {
          _args = [
            "hyprland.start"
            (mkLuaInline ''
              function()
                hl.exec_cmd("brave https://zabbix.muc.boerse-go.de/ https://outlook.office.com/ https://stock3.atlassian.net/jira/your-work https://monkeytype.com/ https://open.spotify.com/ http://bgtop.dc1.boerse-go.de/snapshots.php?autoRefresh=60&limit=500")
                hl.exec_cmd("teams-for-linux --force-dark-mode")
                hl.exec_cmd("TIME_LOGGER_DIR=/home/felix/time_logger/ /home/felix/time_logger/target/release/time_logger start")
              end'')
          ];
        }
      ];
    };
  };
}
