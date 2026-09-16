-- Hyprland loads this file when it is started without a config, and it prefers
-- it over hyprland.conf. HyDE loads it too, last, as the override layer below.
-- The block keeps the two apart: hyde.lua sets `hyde` on its first line, so it
-- runs only when this file is the entry point and HyDE has not been loaded.
-- Removing it leaves a session with a cursor and nothing else.
if not hyde then
	local share = os.getenv("XDG_DATA_HOME") or (os.getenv("HOME") .. "/.local/share")
	local entry = share .. "/hypr/hyde.lua"
	local handle = io.open(entry, "r")
	if not handle then
		error("HyDE is not installed at " .. entry .. ". Run install.sh -r, or point Hyprland at your own config.")
	end
	handle:close()
	dofile(entry)
end

-- Your Hyprland configuration. HyDE never overwrites this file.
--
-- It loads after HyDE's own binds, so settings here take precedence. Replacing
-- a bind needs more than that: see below. HyDE's defaults live in
-- ~/.local/share/hypr/lua/ and are overwritten on every update, so edits there
-- do not survive.
--
-- Adding a keybind:
--
--     hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(hyde.sh.gamelauncher()), {
--         description = "[Utilities] game launcher",
--     })
--
-- Replacing one of HyDE's: bind the same combination again and yours takes
-- over, but copy its flags across as well. A bind counts as the same one only
-- when its flags match, and `description` is not a flag — miss one and both
-- binds stay live on that combination. Copy the whole options table from
-- ~/.local/share/hypr/lua/key_binds.lua and change only what you need:
--
--     hl.bind("F9", hl.dsp.exec_cmd(hyde.sh.volumecontrol("-o", "m")), {
--         locked = true,
--         description = "[Hardware Controls|Audio] un/mute output",
--     })
--
-- Press SUPER + / to see what is actually loaded, your own binds included.
-- The full reference is KEYBINDINGS.md in the HyDE repository.
--
-- Other Lua files next to this one can be pulled in with require("name").

hl.config({
    input = {
        kb_layout = "gb",
        touchpad = {
            natural_scroll = true,
        },
    }
})

-- Execute native Hyprland configs directly via Lua API
-- DP-3 (Dell) on the left, eDP-1 (laptop) on the right
hl.monitor({
    output = "DP-3",
    mode = "preferred",
    position = "0x0",
    scale = 1,
})
hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "1920x0",
    scale = 1.67,
})

-- Disable phantom dongle output (LTM LCD on DP-4) — causes mouse loss on workspace 3/4
hl.monitor({ output = "DP-4", disabled = true })
-- Gestures (Hyprland 0.55+ API)
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

-- Custom App Keybindings
-- SUPER + B (HyDE's browser bind) is unbound so only SUPER + F opens the browser
hl.unbind("SUPER + B")
hl.bind("SUPER + F", hl.dsp.exec_cmd("firefox"), {
    description = "[Launcher|Apps] web browser",
})
hl.bind("SUPER + C", hl.dsp.exec_cmd("antigravity-ide"), {
    description = "[Launcher|Apps] Antigravity IDE",
})
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("visual-studio-code-electron"), {
    description = "[Launcher|Apps] Visual Studio Code",
})
hl.bind("SUPER + O", hl.dsp.exec_cmd("opencode-desktop"), {
    description = "[Launcher|Apps] OpenCode",
})
hl.bind("SUPER + N", hl.dsp.window.move({ out_of_group = true }), {
    description = "[Window Management] remove active window from group",
})
-- SUPER + SHIFT + G (HyDE's game launcher) is unbound and repurposed
hl.unbind("SUPER + SHIFT + G")
hl.bind("SUPER + SHIFT + G", hl.dsp.window.move({ out_of_group = true }), {
    description = "[Window Management] remove active window from group",
})

-- Open Dolphin tiled (overrides HyDE's floating rule for org.kde.dolphin)
hl.window_rule({
    name = "tile-dolphin",
    match = { class = "org\\.kde\\.dolphin" },
    tile = true,
    float = false,
})

