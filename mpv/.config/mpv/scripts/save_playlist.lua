-- ~/.config/mpv/scripts/save_playlist.lua

function save_playlist_to_m3u()
    local playlist_path = os.getenv("HOME") .. "/playlist.m3u"
    local playlist_file = io.open(playlist_path, "w")

    if not playlist_file then
        mp.osd_message("Error: Could not open " .. playlist_path .. " for writing.", 3)
        return
    end

    local playlist_entries = mp.get_property_native("playlist")
    if playlist_entries then
        for i, entry in ipairs(playlist_entries) do
            if entry.filename then
                playlist_file:write(entry.filename .. "\n")
            end
        end
        mp.osd_message("Playlist saved to " .. playlist_path, 3)
    else
        mp.osd_message("No playlist found to save.", 3)
    end

    playlist_file:close()
end

mp.add_key_binding("P", "save-playlist", save_playlist_to_m3u)
