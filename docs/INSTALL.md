# 🚀 Installation guide

> [!IMPORTANT]
> The first playable build hasn't been released yet. This guide describes how installation will work. Until a release appears, `install.ps1` will stop with *"Mod package not built yet"*. That's expected.

## Requirements

- Windows 10 or 11
- Rocket League on PC (Epic Games or Steam)
- PowerShell 5.1+ (already part of Windows)

## 1. Get the files

**Option A, download ZIP:** on the repository page click **Code → Download ZIP** and unpack it anywhere, for example `Documents\rocket-league-roadster-mod`.

**Option B, git:**

```powershell
git clone https://github.com/YOUR_GITHUB_USERNAME/rocket-league-roadster-mod.git
```

Then download `Body_Roadster_SF.upk` from the **Releases** page and put it into the `dist\` folder.

## 2. Close the game

The installer refuses to run while `RocketLeague.exe` is open.

## 3. Run the installer

Open PowerShell in the repository folder (in Explorer: **Shift + right-click → Open PowerShell window here**) and run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\install.ps1
```

The script will:

1. find the game in the default Epic or Steam folder,
2. copy the original body package to `backup\`,
3. copy the Roadster package into `TAGame\CookedPCConsole\`.

### Game in a custom folder?

Point the script at the folder that **contains** `TAGame`:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\install.ps1 -GamePath "D:\Games\rocketleague"
```

Not sure where the game is? In the Epic Games Launcher open **Library → Rocket League → ⋯ → Manage** and use the folder icon next to *Installation*.

## 4. Play

Start the game, open the **Garage** and pick the **Dominus** body. You'll see the Roadster in its place.

## Uninstall

```powershell
powershell -ExecutionPolicy Bypass -File scripts\uninstall.ps1
```

Lost the `backup\` folder? Use **Verify** in your launcher:

- **Epic:** Library → Rocket League → ⋯ → Manage → **Verify**
- **Steam:** Library → right-click Rocket League → Properties → Installed Files → **Verify integrity of game files**

## Troubleshooting

| Message | What to do |
|---|---|
| `Rocket League is running` | Close the game completely, including from the system tray. |
| `Rocket League not found` | Pass `-GamePath` (see above). |
| `Mod package not built yet` | Put `Body_Roadster_SF.upk` into `dist\`. |
| `Target package ... not found` | A game update may have renamed the file. Check `config\roadster.json` and open an issue. |
| *running scripts is disabled on this system* | Use the full `powershell -ExecutionPolicy Bypass -File ...` command shown above. |
| The car looks like the normal Dominus | A game update restored the file. Run the installer again. |
