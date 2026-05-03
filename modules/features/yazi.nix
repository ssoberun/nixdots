{
  self,
  inputs,
  lib,
  ...
}:
{
  perSystem =
    {
      self',
      pkgs,
      lib,
      ...
    }:
    {
      packages.yazi = inputs.wrapper-modules.wrappers.yazi.wrap {
        inherit pkgs;
        settings.yazi = {
          # Original [mgr] table
          manager = {
            ratio = [
              1
              4
              3
            ];
            sort_by = "alphabetical";
            sort_sensitive = false;
            sort_reverse = false;
            sort_dir_first = true;
            sort_translit = false;
            linemode = "none";
            show_hidden = true;
            show_symlink = true;
            scrolloff = 5;
            mouse_events = [
              "click"
              "scroll"
            ];
            title_format = "Yazi: {cwd}";
          };

          # Original [preview] table
          preview = {
            wrap = "no";
            tab_size = 2;
            max_width = 1200;
            max_height = 1000;
            cache_dir = "";
            image_delay = 30;
            image_filter = "triangle";
            image_quality = 75;
            ueberzug_scale = 1;
            ueberzug_offset = [
              0
              0
              0
              0
            ];
          };

          # Original [opener] table
          opener = {
            edit = [
              {
                run = "\${EDITOR:-vi} %s";
                desc = "$EDITOR";
                for = "unix";
                block = true;
              }
              {
                run = "code %s";
                desc = "code";
                for = "windows";
                orphan = true;
              }
              {
                run = "code -w %s";
                desc = "code (block)";
                for = "windows";
                block = true;
              }
            ];
            play = [
              {
                run = "xdg-open %s1";
                desc = "Play";
                for = "linux";
              }
              {
                run = "open %s";
                desc = "Play";
                for = "macos";
              }
              {
                run = "start \"\" %s1";
                orphan = true;
                desc = "Play";
                for = "windows";
              }
              {
                run = "termux-open %s1";
                desc = "Play";
                for = "android";
              }
              {
                run = "mediainfo %s1; echo 'Press enter to exit'; read _";
                block = true;
                desc = "Show media info";
                for = "unix";
              }
              {
                run = "mediainfo %s1 & pause";
                block = true;
                desc = "Show media info";
                for = "windows";
              }
            ];
            open = [
              {
                run = "xdg-open %s1";
                desc = "Open";
                for = "linux";
              }
              {
                run = "open %s";
                desc = "Open";
                for = "macos";
              }
              {
                run = "start \"\" %s1";
                desc = "Open";
                for = "windows";
                orphan = true;
              }
              {
                run = "termux-open %s1";
                desc = "Open";
                for = "android";
              }
            ];
            reveal = [
              {
                run = "xdg-open %d1";
                desc = "Reveal";
                for = "linux";
              }
              {
                run = "open -R %s1";
                desc = "Reveal";
                for = "macos";
              }
              {
                run = "explorer /select,%s1";
                desc = "Reveal";
                for = "windows";
                orphan = true;
              }
              {
                run = "termux-open %d1";
                desc = "Reveal";
                for = "android";
              }
              {
                run = "clear; exiftool %s1; echo 'Press enter to exit'; read _";
                desc = "Show EXIF";
                for = "unix";
                block = true;
              }
            ];
            extract = [
              {
                run = "ya pub extract --list %s";
                desc = "Extract here";
              }
            ];
            download = [
              {
                run = "ya emit download --open %S";
                desc = "Download and open";
              }
              {
                run = "ya emit download %S";
                desc = "Download";
              }
            ];
            pdff = [
              # {
              #   run = "zathura \"$@\"";
              #   desc = "zathura";
              #   block = false;
              #   orphan = true;
              #   for = "unix";
              # }
              {
                run = "sioyek --new-instance \"$@\"";
                desc = "sioyek";
                block = false;
                orphan = true;
                for = "unix";
              }
            ];
          };

          # Original [open] table
          open = {
            rules = [
              {
                mime = "application/pdf";
                use = [
                  "pdff"
                  "reveal"
                ];
              }
              {
                url = "*/";
                use = [
                  "edit"
                  "open"
                  "reveal"
                ];
              }
              {
                mime = "text/*";
                use = [
                  "edit"
                  "reveal"
                ];
              }
              {
                mime = "image/*";
                use = [
                  "open"
                  "reveal"
                ];
              }
              {
                mime = "{audio,video}/*";
                use = [
                  "play"
                  "reveal"
                ];
              }
              {
                mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
                use = [
                  "extract"
                  "reveal"
                ];
              }
              {
                mime = "application/{json,ndjson}";
                use = [
                  "edit"
                  "reveal"
                ];
              }
              {
                mime = "*/javascript";
                use = [
                  "edit"
                  "reveal"
                ];
              }
              {
                mime = "inode/empty";
                use = [
                  "edit"
                  "reveal"
                ];
              }
              {
                mime = "vfs/{absent,stale}";
                use = "download";
              }
              {
                url = "*";
                use = [
                  "open"
                  "reveal"
                ];
              }
            ];
          };

          # Original [tasks] table
          tasks = {
            micro_workers = 10;
            macro_workers = 10;
            bizarre_retry = 3;
            image_alloc = 536870912;
            image_bound = [
              10000
              10000
            ];
            suppress_preload = false;
          };

          # Original [plugin] table
          plugin = {
            fetchers = [
              {
                id = "mime";
                url = "*/";
                run = "mime.dir";
                prio = "high";
              }
              {
                id = "mime";
                url = "local://*";
                run = "mime.local";
                prio = "high";
              }
              {
                id = "mime";
                url = "remote://*";
                run = "mime.remote";
                prio = "high";
              }
            ];
            spotters = [
              {
                url = "*/";
                run = "folder";
              }
              {
                mime = "text/*";
                run = "code";
              }
              {
                mime = "application/{mbox,javascript,wine-extension-ini}";
                run = "code";
              }
              {
                mime = "image/{avif,hei?,jxl}";
                run = "magick";
              }
              {
                mime = "image/svg+xml";
                run = "svg";
              }
              {
                mime = "image/*";
                run = "image";
              }
              {
                mime = "video/*";
                run = "video";
              }
              {
                mime = "vfs/*";
                run = "vfs";
              }
              {
                mime = "null/*";
                run = "null";
              }
              {
                url = "*";
                run = "file";
              }
            ];
            preloaders = [
              {
                mime = "image/{avif,hei?,jxl}";
                run = "magick";
              }
              {
                mime = "image/svg+xml";
                run = "svg";
              }
              {
                mime = "image/*";
                run = "image";
              }
              {
                mime = "video/*";
                run = "video";
              }
              {
                mime = "application/pdf";
                run = "pdf";
              }
              {
                mime = "font/*";
                run = "font";
              }
              {
                mime = "application/ms-opentype";
                run = "font";
              }
            ];
            previewers = [
              {
                url = "*/";
                run = "folder";
              }
              {
                mime = "text/*";
                run = "code";
              }
              {
                mime = "application/{mbox,javascript,wine-extension-ini}";
                run = "code";
              }
              {
                mime = "application/{json,ndjson}";
                run = "json";
              }
              {
                mime = "image/{avif,hei?,jxl}";
                run = "magick";
              }
              {
                mime = "image/svg+xml";
                run = "svg";
              }
              {
                mime = "image/*";
                run = "image";
              }
              {
                mime = "video/*";
                run = "video";
              }
              {
                mime = "application/pdf";
                run = "pdf";
              }
              {
                mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
                run = "archive";
              }
              {
                mime = "application/{debian*-package,redhat-package-manager,rpm,android.package-archive}";
                run = "archive";
              }
              {
                url = "*.{AppImage,appimage}";
                run = "archive";
              }
              {
                mime = "application/{iso9660-image,qemu-disk,ms-wim,apple-diskimage}";
                run = "archive";
              }
              {
                mime = "application/virtualbox-{vhd,vhdx}";
                run = "archive";
              }
              {
                url = "*.{img,fat,ext,ext2,ext3,ext4,squashfs,ntfs,hfs,hfsx}";
                run = "archive";
              }
              {
                mime = "font/*";
                run = "font";
              }
              {
                mime = "application/ms-opentype";
                run = "font";
              }
              {
                mime = "inode/empty";
                run = "empty";
              }
              {
                mime = "vfs/*";
                run = "vfs";
              }
              {
                mime = "null/*";
                run = "null";
              }
              {
                url = "*";
                run = "file";
              }
            ];
          };

          # Original [input] table
          input = {
            cursor_blink = false;
            cd_title = "Change directory:";
            cd_origin = "top-center";
            cd_offset = [
              0
              2
              50
              3
            ];
            create_title = [
              "Create:"
              "Create (dir):"
            ];
            create_origin = "top-center";
            create_offset = [
              0
              2
              50
              3
            ];
            rename_title = "Rename:";
            rename_origin = "hovered";
            rename_offset = [
              0
              1
              50
              3
            ];
            filter_title = "Filter:";
            filter_origin = "top-center";
            filter_offset = [
              0
              2
              50
              3
            ];
            find_title = [
              "Find next:"
              "Find previous:"
            ];
            find_origin = "top-center";
            find_offset = [
              0
              2
              50
              3
            ];
            search_title = "Search via {n}:";
            search_origin = "top-center";
            search_offset = [
              0
              2
              50
              3
            ];
            shell_title = [
              "Shell:"
              "Shell (block):"
            ];
            shell_origin = "top-center";
            shell_offset = [
              0
              2
              50
              3
            ];
          };

          # Original [confirm] table
          confirm = {
            trash_title = "Trash {n} selected file{s}?";
            trash_origin = "center";
            trash_offset = [
              0
              0
              70
              20
            ];
            delete_title = "Permanently delete {n} selected file{s}?";
            delete_origin = "center";
            delete_offset = [
              0
              0
              70
              20
            ];
            overwrite_title = "Overwrite file?";
            overwrite_body = "Will overwrite the following file:";
            overwrite_origin = "center";
            overwrite_offset = [
              0
              0
              50
              15
            ];
            quit_title = "Quit?";
            quit_body = "The following tasks are still running, are you sure you want to quit?";
            quit_origin = "center";
            quit_offset = [
              0
              0
              50
              15
            ];
          };

          # Original [pick] table
          pick = {
            open_title = "Open with:";
            open_origin = "hovered";
            open_offset = [
              0
              1
              50
              7
            ];
          };

          # Original [which] table
          which = {
            sort_by = "none";
            sort_sensitive = false;
            sort_reverse = false;
            sort_translit = false;
          };
        };
      };
    };
}
