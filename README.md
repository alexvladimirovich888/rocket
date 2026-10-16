<div align="center">

<img src="assets/banner.png" alt="Roadster for Rocket League, concept banner" width="100%">

# Roadster for Rocket League

**A fan-made flying roadster car body for Rocket League. Client-side and visual only.**

[![Status](https://img.shields.io/badge/status-in%20development-orange?style=for-the-badge)](#-roadmap)
[![Version](https://img.shields.io/badge/version-0.1.0--alpha-blueviolet?style=for-the-badge)](CHANGELOG.md)
[![Platform](https://img.shields.io/badge/platform-Windows%20PC-0078D6?style=for-the-badge&logo=windows&logoColor=white)](docs/INSTALL.md)
[![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)](LICENSE)

[![Blender](https://img.shields.io/badge/Blender-4.x-F5792A?logo=blender&logoColor=white)](https://www.blender.org/)
[![Unreal Engine 3](https://img.shields.io/badge/Unreal%20Engine-3%20%2F%20UDK-0E1128?logo=unrealengine&logoColor=white)](docs/BUILDING.md)
[![Python](https://img.shields.io/badge/tools-Python%203.9%2B-3776AB?logo=python&logoColor=white)](scripts/check_model.py)
[![PowerShell](https://img.shields.io/badge/installer-PowerShell-5391FE?logo=powershell&logoColor=white)](scripts/install.ps1)

**English** · [Русский](README.ru.md)

</div>

---

> [!IMPORTANT]
> **This project is in early development. There is no playable package yet.**
> The images below are **concept art**, not in-game screenshots. Real screenshots will replace them as soon as the first build runs in-game. Watch or star the repo to get notified.

> [!WARNING]
> Only download builds from this repository's **[Releases](../../releases)** page. The mod is a single `.upk` file plus PowerShell scripts you can read. It **never** ships as an `.exe`. If someone sends you a "Roadster mod" installer `.exe`, don't run it. See [SECURITY.md](SECURITY.md).

## ✨ What is this?

**Roadster** swaps the look of a Rocket League car for a fan recreation of the **next-generation electric Roadster**: the sharp wedge nose, long glass canopy, full-width red light bar, rear wing and the four rear thruster nozzles that let it "fly". In Rocket League every car flies anyway. This one finally looks like it was built for it.

- 🏎️ **New body mesh.** A low, long roadster silhouette with an open-feel cabin and glowing underbody hover pads.
- 🎨 **Paintable.** An RGB paint mask, so your in-game primary and accent colours still apply.
- 🔥 **Real thrusters as boost.** The four rear nozzles in the diffuser are where the boost trail comes out.
- 🪽 **Rear wing.** The big rear wing raises in the air (planned animation).
- 📦 **Dominus hitbox.** The model is built around an existing hitbox, so gameplay doesn't change at all.
- 👁️ **Client-side only.** Only you see the Roadster. Opponents see your normal car.
- ♻️ **Reversible.** The installer backs up the original file, and one command restores it.

## 🖼️ Concept art

> [!NOTE]
> These are design concepts drawn for the project, **not screenshots from the game.**

<div align="center">

<img src="assets/concept/flight.png" alt="Concept: Roadster in an aerial hit" width="100%">

<sub><b>Aerial mode.</b> Boost thruster, hover pads and the target silhouette.</sub>

<br><br>

<img src="assets/concept/rear.png" alt="Concept: rear thruster package" width="100%">

<sub><b>Rear thruster package.</b> Full-width light bar, raised wing and four boost nozzles.</sub>

<br><br>

<table>
  <tr>
    <td width="50%"><img src="assets/concept/blueprint.png" alt="Concept: body layout over the Dominus hitbox"></td>
    <td width="50%"><img src="assets/concept/paints.png" alt="Concept: paint variants"></td>
  </tr>
  <tr>
    <td align="center"><sub><b>Body layout</b> over the Dominus hitbox</sub></td>
    <td align="center"><sub><b>Paint variants</b> through the RGB mask</sub></td>
  </tr>
</table>

</div>

## 📊 Specs

| | Target |
|---|---|
| **Hitbox preset** | Dominus · 127.93 × 83.28 × 31.30 uu |
| **Body mesh (LOD0)** | ≤ 12 000 triangles |
| **Textures** | 2048² Diffuse · Normal · RGB paint mask |
| **Wheels** | Uses your equipped wheels |
| **Gameplay changes** | None (visual only) |
| **Platform** | Windows PC (Epic Games and Steam installs) |

## 🚀 Installation

> [!CAUTION]
> Modifying game files is done **at your own risk**. Use the mod in **offline modes, Free Play and private matches**. A game update or the launcher's **Verify** button replaces the file with the original.

Once a release is published:

1. Download `Body_Roadster_SF.upk` from **[Releases](../../releases)** and put it in the `dist/` folder.
2. **Close Rocket League.**
3. Open PowerShell in the repository folder and run:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts\install.ps1
   ```

   If the game is installed somewhere unusual, add the path:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts\install.ps1 -GamePath "D:\Games\rocketleague"
   ```

4. Start the game, go to the **Garage** and pick the **Dominus** body.

**Uninstall:**

```powershell
powershell -ExecutionPolicy Bypass -File scripts\uninstall.ps1
```

The full guide, with troubleshooting, is in **[docs/INSTALL.md](docs/INSTALL.md)**.

## 🛠️ Building from source

```
Blender (.blend) ──► FBX export ──► check_model.py ──► UDK import & materials ──► cooked .upk ──► dist/
```

Check your mesh against the hitbox before importing it into UDK:

```bash
python scripts/check_model.py exports/roadster.obj
```

Example output:

```
  Roadster mesh check  roadster.obj · preset Dominus · tolerance ±8%

  PASS  length    127.40 uu   target  127.93 uu   (-0.4%)
  PASS  width      82.10 uu   target   83.28 uu   (-1.4%)
  PASS  height     32.05 uu   target   31.30 uu   (+2.4%)
  PASS  tris       10984      budget   12000
```

Full pipeline: **[docs/BUILDING.md](docs/BUILDING.md)**.

## 📁 Repository layout

```
rocket-league-roadster-mod/
├── assets/              # banner and concept art used in this README
├── config/
│   └── roadster.json    # mod manifest: hitbox, target package, budgets
├── dist/                # built .upk goes here (not committed)
├── docs/
│   ├── INSTALL.md       # installation and uninstall
│   ├── BUILDING.md      # Blender → UDK → .upk pipeline
│   ├── REFERENCES.md    # design features to match
│   └── FAQ.md
├── scripts/
│   ├── install.ps1      # backup + install (Windows)
│   ├── uninstall.ps1    # restore original
│   └── check_model.py   # mesh size & triangle checker
└── source/
    ├── blender/         # .blend source files (Git LFS)
    ├── textures/        # PSD/PNG texture sources (Git LFS)
    └── reference/       # hitbox reference meshes
```

## 🗺️ Roadmap

- [x] Concept art and target specs
- [x] Repository, manifest, installer and uninstaller with backup
- [x] Mesh checker (`check_model.py`) plus CI
- [ ] Blockout mesh in Blender at hitbox scale
- [ ] High-poly sculpt and bake
- [ ] Game-ready LOD0 (≤ 12k tris) and UVs
- [ ] Textures: Diffuse / Normal / RGB paint mask
- [ ] First in-game test build 🎯 **real screenshots land here**
- [ ] Boost from the four rear nozzles, rear wing animation, hover-pad glow
- [ ] Decal UV layout
- [ ] `v1.0.0` release

## 🤝 Contributing

3D artists, texture artists and people who know the UE3/UDK pipeline are all very welcome. Read **[CONTRIBUTING.md](CONTRIBUTING.md)** to get started, then open an issue to say what you'd like to work on.

## ❓ FAQ

<details>
<summary><b>Can I get banned for this?</b></summary>
<br>
The mod only changes a local visual file and doesn't touch gameplay, memory or the network. Even so, modifying game files is not officially supported by Psyonix or Epic Games, so use it at your own risk and preferably offline. See <a href="docs/FAQ.md">docs/FAQ.md</a>.
</details>

<details>
<summary><b>Will other players see my Roadster?</b></summary>
<br>
No. Everything is client-side. Other players see the car you actually have equipped.
</details>

<details>
<summary><b>Does it work on PlayStation, Xbox, Switch or Mac?</b></summary>
<br>
No. PC (Windows) only, because console files can't be modified.
</details>

<details>
<summary><b>Is this an official Tesla model?</b></summary>
<br>
No. It's a fan-made model recreated by hand from public photos of the next-gen Tesla Roadster. It doesn't use official CAD data, and the model carries no Tesla logos or badges. Design references are listed in <a href="docs/REFERENCES.md">docs/REFERENCES.md</a>.
</details>

## ⚖️ Disclaimer

This is an unofficial fan project. It is **not affiliated with, endorsed by or sponsored by** Psyonix, Epic Games or Tesla, Inc. *Rocket League* is a trademark of Psyonix LLC. All other trademarks belong to their respective owners. The code in this repository is released under the [MIT License](LICENSE). No game files are distributed here.

<div align="center">
<br>
<sub>Made with 🚀 by fans. If you like the idea, leave a ⭐</sub>
</div>
