## What is it?
ksetup.bat is a simple script to automatically remove old fixes (winedll, dgvoodoo) from your game folder and install everything needed to play Kohan: Ahriman's Gift on modern OSs:
* The latest version of [cnc-ddraw](https://github.com/FunkyFr3sh/cnc-ddraw/?tab=readme-ov-file#cnc-ddraw), a DirectX9 repacement that fixes the lag and display issues when playing Kohan on newer OSs
* The latest version of [Khaldun.net OpenSpy Client](https://github.com/Kohan-Citadel/khaldun.net-client?tab=readme-ov-file#khaldunnet-client), a patch to restore functionality to the GameSpy server browser by using OpenSpy's open-source rebuild of the entire backend
* The latest version of [Kohan Gold](https://github.com/Kohan-Citadel/kohangold-KG-/?tab=readme-ov-file#kohan-gold), a community balance mod aimed at fixing issues while leaving the "feel" of the game unchanged
* The Kohan mod launcher to allow playing the game with mods
## How to use it
1. Download ksetup.bat
2. Move ksetup.bat from your Downloads into your Kohan game folder. For the Steam version, this is usually ```C:\Program Files (x86)\Steam\steamapps\common\Kohan Ahrimans Gift```
3. Double-click ksetup.bat to run it. You should see a warning like this one: 
<img width="468" height="346" alt="image" src="https://github.com/user-attachments/assets/a6ca70e9-c3f2-46b0-8e47-460a518661f0" />
 
4. Click on "Run" to allow the setup script to run
5. Once the script finishes, you may have to open Kohan multiple (up to 10) times before the Khaldun.net OpenSpy Client starts working. Once it does, your game should resume launching normally.
