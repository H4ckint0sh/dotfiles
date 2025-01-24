import fs from "fs";
import { KarabinerRules } from "./types";
import { createHyperSubLayers, app, open } from "./utils";

const rules: KarabinerRules[] = [
  {
    description: "Hyper Key (⌃⌥⇧⌘)",
    manipulators: [
      {
        description: "right_command -> Hyper Key",
        from: {
          key_code: "caps_lock",
        },
        to: [
          {
            key_code: "left_shift",
            modifiers: ["left_command", "left_control", "left_option"],
          },
        ],
        // If right_command is pressed by itself, homerow will show up
        // Homerow configured under `Clicking - Shorctut`
        to_if_alone: [
          {
            key_code: "escape",
          },
        ],
        type: "basic",
      },
    ],
  },

  {
    description: "left_command -> cmd+v if pressed alone",
    manipulators: [
      {
        from: {
          key_code: "left_command",
        },
        to: [
          {
            key_code: "left_command",
          },
        ],
        to_if_alone: [
          {
            key_code: "v",
            modifiers: ["command"],
          },
        ],
        type: "basic",
      },
    ],
  },

  {
    description: "left_option -> cmd+k if pressed alone to open sesh sessions",
    manipulators: [
      {
        from: {
          key_code: "left_option",
        },
        to: [
          {
            key_code: "left_option",
          },
        ],
        to_if_alone: [
          {
            key_code: "k",
            modifiers: ["command"],
          },
        ],
        type: "basic",
      },
    ],
  },

  {
    description: "left_ctrl -> alt+tab if pressed alone",
    manipulators: [
      {
        from: {
          key_code: "left_control",
        },
        to: [
          {
            key_code: "left_control",
          },
        ],
        to_if_alone: [
          {
            key_code: "tab",
            modifiers: ["option"],
          },
        ],
        type: "basic",
      },
    ],
  },

  {
    description:
      "left_shift -> command+l in tmux for last session if pressed alone",
    manipulators: [
      {
        from: {
          key_code: "left_shift",
        },
        to: [
          {
            key_code: "left_shift",
          },
        ],
        to_if_alone: [
          {
            key_code: "l",
            modifiers: ["command"],
          },
        ],
        type: "basic",
      },
    ],
  },

  ...createHyperSubLayers({
    // All the following combinations require the "hyper" key as well
    a: {
      s: app("Spotify"),
      t: app("Ghostty"),
      semicolon: app("Claude"),
      quote: app("System Settings"),
      b: app("Chromium"),
      m: app("Mail"),
      d: app("Discord"),
      p: app("1Password"),
      f: app("Finder"),
      w: app("Microsoft Word"),
      o: app("Microsoft Outlook"),
    },

    // write the swedish letters more like swedish keyboards
    w: {
      semicolon: {
        to: [
          {
            key_code: "p",
            modifiers: ["option"],
          },
        ],
      },
      quote: {
        to: [
          {
            key_code: "q",
            modifiers: ["option"],
          },
        ],
      },
      open_bracket: {
        to: [
          {
            key_code: "w",
            modifiers: ["option"],
          },
        ],
      },
    },

    // r = "Raycast"
    r: {
      y: open(
        "raycast://extensions/tonka3000/youtube/search-videos?arguments=%7B%22query%22%3A%22%22%7D"
      ),
      b: open("raycast://extensions/nhojb/brew/search"),
    },

    // s = "System" or "Service"
    s: {
      j: {
        to: [
          {
            key_code: "volume_decrement",
          },
        ],
      },
      k: {
        to: [
          {
            key_code: "volume_increment",
          },
        ],
      },
      // Move to left (or up) tab in browsers
      h: {
        to: [
          {
            key_code: "open_bracket",
            modifiers: ["left_command", "left_shift"],
          },
        ],
      },
      // Move to right (or down) tab in browsers
      l: {
        to: [
          {
            key_code: "close_bracket",
            modifiers: ["left_command", "left_shift"],
          },
        ],
      },
      u: {
        to: [
          {
            key_code: "display_brightness_decrement",
          },
        ],
      },
      i: {
        to: [
          {
            key_code: "display_brightness_increment",
          },
        ],
      },
    },

    u: {
      // Lock screen
      i: {
        to: [
          {
            key_code: "q",
            modifiers: ["right_control", "right_command"],
          },
        ],
      },
      // Dismiss notifications on macos
      k: open(
        "btt://execute_assigned_actions_for_trigger/?uuid=92B63395-5930-463A-9301-57BA344D6981"
      ),
    },
  }),
];

fs.writeFileSync(
  "karabiner.json",
  JSON.stringify(
    {
      global: {
        show_in_menu_bar: false,
      },
      profiles: [
        {
          complex_modifications: {
            rules,
          },
          fn_function_keys: [
            {
              from: { key_code: "f6" },
              to: [{ consumer_key_code: "rewind" }],
            },
            {
              from: { key_code: "f7" },
              to: [{ consumer_key_code: "play_or_pause" }],
            },
            {
              from: { key_code: "f8" },
              to: [{ consumer_key_code: "fast_forward" }],
            },
            {
              from: { key_code: "f9" },
              to: [{ consumer_key_code: "volume_decrement" }],
            },
            {
              from: { key_code: "f10" },
              to: [{ consumer_key_code: "volume_increment" }],
            },
            {
              from: { key_code: "f11" },
              to: [{ key_code: "f11" }],
            },
            {
              from: { key_code: "f12" },
              to: [{ key_code: "f12" }],
            },
          ],
          name: "Default",
          selected: true,
          virtual_hid_keyboard: { keyboard_type_v2: "ansi" },
        },
      ],
    },
    null,
    2
  )
);
