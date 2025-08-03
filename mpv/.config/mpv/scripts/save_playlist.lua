-- ~/.config/mpv/scripts/save_playlist.lua
-- This script saves the current MPV playlist to an M3U file in the user's home directory.
-- It is triggered by the 'p' key by default.

-- Define the function to save the playlist.
local function save_playlist()
    -- Get the user's home directory to save the file there.
    local home_dir = os.getenv("HOME")

    -- Define the output file path. You can change the name or location here.
    -- The file will be overwritten if it already exists.
    local output_path = home_dir .. "/mpv_playlist.m3u"

    -- Attempt to open the file for writing ('w').
    local file, err = io.open(output_path, "w")

    -- Check if there was an error opening the file.
    if not file then
        mp.osd_message("Error: Could not save playlist to " .. output_path .. ": " .. err, 5)
        return
    end

    -- Get the current playlist as a table.
    local playlist = mp.get_property_native("playlist")

    -- Check if the playlist is not empty.
    if #playlist > 0 then
        -- Iterate through each entry in the playlist.
        for i, entry in ipairs(playlist) do
            -- Ensure the entry has a filename property.
            if entry.filename then
                -- Write the filename to the M3U file, followed by a newline.
                file:write(entry.filename .. "\n")
            end
        end
        -- Show a success message on the MPV OSD.
        mp.osd_message("Playlist saved to " .. output_path, 3)
    else
        -- Show a message if no playlist was found.
        mp.osd_message("No playlist found to save.", 3)
    end

    -- Close the file. It's important to do this after writing.
    file:close()
end

-- Add a key binding to trigger the save_playlist function.
-- The key 'p' is used here. You can change it to any key you prefer.
-- The second argument "save-playlist" is the name of the command.
mp.add_key_binding("p", "save-playlist", save_playlist)

