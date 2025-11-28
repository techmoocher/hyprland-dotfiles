import os
from datetime import datetime
from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer, get_options
from kitty.rgb import to_color
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_title,
    draw_attributed_string,
    draw_tab_with_powerline,
)


MACOS_ICON = " "
LINUX_ICON = " "
DISTROS_ICONS = {
    "Unknown": " ",
    "Ubuntu": " ",
    "Debian": " ",
    "Kali": " ",
    "Arch": "󰣇 ",
    "Elementary": " ",
    "Mint": "󰣭 ",
    "Gentoo": " ",
    "Manjaro": "󱘊 ",
    "openSUSE": " ",
    "Fedora": " ",
    "Pop!_OS": " ",
    "Zorin": " ",
    "Endeavour": " ",
    "CentOS": " ",
}
LEFT_HALF_CIRCLE = ""
RIGHT_HALF_CIRCLE = ""
CHARGING_ICON = "󰂄 "
CHARGING_FULL_ICONS = "󱐋 "
BATTERY_ERROR_ICON = "󰂑 " 
UNPLUGGED_ICONS = {
    10: "󰂃 ",
    20: "󰁻 ",
    30: "󰁼 ",
    40: "󰁽 ",
    50: "󰁾 ",
    60: "󰁿 ",
    70: "󰂀 ",
    80: "󰂁 ",
    90: "󰂂 ",
    100: "󰁹 ",
}
ACTIVE_TAB_ICON = "✿ "
INACTIVE_TAB_ICON = "❀ "
DATE_TIME_ICON = "󰃰 "
TERMINAL_ICON = " "
CPU_ICON = " "
MEM_ICON = " "
REFRESH_TIME = 1

# ICON & HOSTNAME
# def _get_icon_and_hostname() -> dict:
#     def _get_logo() -> str:
#         _os = os.popen("uname -o").read().strip()
#         match _os:
#             case "Darwin":
#                 return MACOS_ICON

#             case "GNU/Linux":
#                 distro = os.popen('hostnamectl | grep "Operating System"').read().strip()

#                 for name, icon in DISTROS_ICONS.items():
#                     if name.lower() in distro.lower():
#                         return icon

#                 return LINUX_ICON

#             case _:
#                 return DISTROS_ICONS["Unknown"]

#     cell = {
#         "icon": ""
#         "bg_color": "",
#         "text": "",
#     }

#     cell["icon"] = _get_logo()

#    return cell

# PROCESS
def _get_active_process_name_cell() -> dict:
    cell = {
        "icon": TERMINAL_ICON,
        "icon_bg_color": "#AFFFA0",
        "text": "",
    }
    boss = get_boss()

    # No boss instance found
    if not boss:
        cell["text"] = "ERR 1"
        return cell

    active_window = boss.active_window
    # No active window found
    if not active_window:
        cell["text"] = "ERR 2"
        return cell

    # No process is associated with the active window.
    if not active_window.child:
        cell["text"] = "ERR 3"
        return cell

    foreground_processes = active_window.child.foreground_processes
    # No foreground process found.
    if not foreground_processes or not foreground_processes[0]["cmdline"]:
        cell["text"] = "ERR 4"
        return cell
    long_process_name = foreground_processes[0]["cmdline"][0]
    cell["text"] = long_process_name.rsplit("/", 1)[-1]

    return cell

# DATETIME
def _get_datetime_cell() -> dict:
    date_time = datetime.now().strftime("%m-%d-%Y %I:%M %p")
    return {
        "icon": DATE_TIME_ICON,
        "icon_bg_color": "#96D7FF",
        "text": date_time
    }

# BATTERY
def _get_battery_cell() -> dict:
    cell = {
        "icon": "",
        "icon_bg_color": "#FFE196",
        "text": ""
    }

    paths = [f"/sys/class/power_supply/BAT{n}" for n in range(6)]
    done = False
    for path in paths:
        try:
            with open(f"{path}/status", "r") as f:
                status = f.read().strip()
            with open(f"{path}/capacity", "r") as f:
                percent = int(f.read())

            if status == "Charging":
                cell["icon"] = CHARGING_ICON
            else:
                cell["icon"] = UNPLUGGED_ICONS[min(UNPLUGGED_ICONS.keys(), key=lambda x: abs(percent - x))]

            cell["text"] = str(percent) + "%"
            done = True
            break

        except FileNotFoundError:
            continue

    if not done:
        cell["icon"] = BATTERY_ERROR_ICON
        cell["text"] = "ERR"

    return cell

def _create_cells() -> list[dict]:
    # return [_get_weather_cell(), _get_active_process_name_cell(), _get_battery_cell(), _get_datetime_cell()]
    return [_get_active_process_name_cell(), _get_battery_cell(), _get_datetime_cell()]

def _draw_right_status(screen: Screen, is_last: bool, draw_data: DrawData) -> int:
    if not is_last:
        return 0
    draw_attributed_string(Formatter.reset, screen)

    cells = _create_cells()
    right_status_length = 0
    for c in cells:
        right_status_length += 3 + len(c["icon"]) + len(c["text"])

    screen.cursor.x = screen.columns - right_status_length

    for c in cells:
        icon_bg_color = as_rgb(int(to_color(c["icon_bg_color"])))

        screen.cursor.fg = icon_bg_color
        screen.draw(LEFT_HALF_CIRCLE)
        screen.cursor.bg = icon_bg_color
        screen.cursor.fg = as_rgb(int(to_color("#2D2D41")))
        screen.draw(c["icon"])

        #screen.cursor.bg = as_rgb(int(to_color("#FFD7E1")))
        screen.cursor.bg = as_rgb(int(to_color("#2D2D41")))
        screen.cursor.fg = as_rgb(int(to_color("#EBEBEB")))
        screen.draw(f" {c['text']} ")

    return screen.cursor.x

def _redraw_tab_bar(_) -> None:
    tm = get_boss().active_tab_manager
    if tm is not None:
        tm.mark_tab_bar_dirty()

timer_id = None

def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global timer_id
    if timer_id is None:
        timer_id = add_timer(_redraw_tab_bar, REFRESH_TIME, True)
    draw_tab_with_powerline(draw_data, screen, tab, before, max_title_length, index, is_last, extra_data)
    _draw_right_status(screen, is_last, draw_data)
    return screen.cursor.x
