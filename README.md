# TTS_munchkin

If you have the old asset files of Munchkin Complete Collection V 1.18 or Munchkin Complete Collection V 1.18.1 and you want to have all those files removed, then you can follow the steps below in order to do so. The script should work for Windows (tested on Windows 11), Linux (tested on Ubuntu), and MacOS (tested on Sequoia)

1. [Have Python installed if you haven't already](https://www.python.org/downloads/)
2. [Download this project (this link points to a zip of it)](https://github.com/FVMF/TTS_munchkin/archive/refs/heads/main.zip)
3. Unzip the contents of the file downloaded in step 2 to the Mods subdirectory of Tabletop Simulator
   - For Windows: %USERPROFILE%\Documents\My Games\Tabletop Simulator\Mods\
   - For MacOS: ~/Library/Tabletop Simulator/Mods/
   - For Linux: ~/.local/share/Tabletop Simulator/Mods/
4. Run the script, via the command line:
   ```
   python delete_old_files.py
   ```
   If you have python 3 installed, it could be that you should use:
   ```
   python3 delete_old_files.py
   ```
6. The command line interface should show which files were successfully removed
7. Optionally: you can delete all the files you have downloaded in step 2 and unzipped in step 3 
