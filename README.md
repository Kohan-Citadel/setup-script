## What is it?
ksetup.ps1 is a powershell script to automatically remove old fixes (winedll, dgvoodoo) from your game folder and install everything needed to play Kohan: Ahriman's Gift on modern OSs:
* The latest version of [cnc-ddraw](https://github.com/FunkyFr3sh/cnc-ddraw/?tab=readme-ov-file#cnc-ddraw), a DirectX9 repacement that fixes the lag and display issues when playing Kohan on newer OSs
* The latest version of [OpenSpy Client](https://github.com/anzz1/openspy-client?tab=readme-ov-file#openspy-client), a patch to restore functionality the GameSpy server browser by using OpenSpy's open-source rebuild of the entire backend
* The latest version of [Kohan Gold](https://github.com/Kohan-Citadel/kohangold-KG-/?tab=readme-ov-file#kohan-gold), a community balance mod aimed at fixing issues while leaving the "feel" of the game unchanged
## How to use it
1. Download ksetup.ps1
2. Move the script into your Kohan game folder. For the Steam version, this is usually ```C:\Program Files (x86)\Steam\steamapps\common\Kohan Ahrimans Gift```
3. Right-click on the script and select "Run with Powershell"
4. On the Windows Security dialogue that pops up, click on "Open" to allow the script to run
5. Once the script finishes, you may have to open Kohan multiple (up to 10) times before the OpenSpy Client starts working. Once it does, your game should resume launching normally.
