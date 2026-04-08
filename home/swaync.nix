{ ... }:
{
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 8;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = true;
      notification-window-width = 400;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;
      widgets = [
        "title"
        "dnd"
        "notifications"
      ];
      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
      };
    };
    style = ''
      * {
        font-family: "Monofur Nerd Font", "Regular";
        font-size: 14px;
      }

      .control-center {
        background: rgba(20, 20, 35, 0.9);
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, 0.2);
        color: #ffffff;
      }

      .notification-row {
        outline: none;
      }

      .notification {
        background: rgba(255, 255, 255, 0.12);
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, 0.2);
        margin: 6px;
        padding: 0;
      }

      .notification-content {
        padding: 10px;
        color: #ffffff;
      }

      .notification-default-action,
      .notification-action {
        border-radius: 8px;
        margin: 4px;
        padding: 6px;
        background: rgba(255, 255, 255, 0.08);
        color: #ffffff;
      }

      .notification-default-action:hover,
      .notification-action:hover {
        background: rgba(255, 255, 255, 0.18);
      }

      .close-button {
        background: rgba(255, 255, 255, 0.1);
        border-radius: 8px;
        color: #ffffff;
        margin: 4px;
        padding: 2px 6px;
      }

      .close-button:hover {
        background: rgba(255, 80, 80, 0.6);
      }

      .widget-title {
        color: #ffffff;
        margin: 8px;
        font-size: 16px;
      }

      .widget-title button {
        background: rgba(255, 255, 255, 0.12);
        border-radius: 8px;
        border: 1px solid rgba(255, 255, 255, 0.2);
        color: #ffffff;
        padding: 4px 12px;
      }

      .widget-title button:hover {
        background: rgba(255, 255, 255, 0.18);
      }

      .widget-dnd {
        color: #ffffff;
        margin: 8px;
      }

      .widget-dnd > switch {
        background: rgba(255, 255, 255, 0.12);
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, 0.2);
      }

      .widget-dnd > switch:checked {
        background: rgba(255, 100, 100, 0.4);
      }

      .widget-dnd > switch slider {
        background: rgba(255, 255, 255, 0.8);
        border-radius: 10px;
      }
    '';
  };
}
