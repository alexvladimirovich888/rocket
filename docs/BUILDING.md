# 🛠️ Building the Roadster from source

This page describes the asset pipeline, from a Blender file to a package the game can load.

> [!NOTE]
> Steps 1–3 are standard 3D work and are stable. Steps 4–5 (UDK import and cooking) are **experimental**. The exact Rocket League packaging workflow is still being worked out and will be documented here in detail with the first in-game build. Pull requests that improve this page are very welcome.

```
┌──────────┐   ┌──────────┐   ┌────────────────┐   ┌──────────────┐   ┌──────────┐
│ Blender  │──►│ FBX/OBJ  │──►│ check_model.py │──►│ UDK + mats   │──►│ .upk     │
│ .blend   │   │ export   │   │ size & tris    │   │ (UE3)        │   │ dist/    │
└──────────┘   └──────────┘   └────────────────┘   └──────────────┘   └──────────┘
```

## Tools

| Tool | Version | Used for |
|---|---|---|
| [Blender](https://www.blender.org/) | 4.x | modelling, UVs, baking |
| Python | 3.9+ | `scripts/check_model.py` |
| Unreal Development Kit (UDK) | 2015 build (UE3) | materials, packaging |
| Texture editor (Krita, GIMP, Photoshop, Substance) | any | textures |
| [Git LFS](https://git-lfs.com/) | any | storing `.blend`, `.fbx`, `.psd` |

## 1. Model at hitbox scale

1. Open `source/blender/` (the `.blend` file is added with the blockout milestone).
2. Import `source/reference/hitbox_dominus.obj`. It's a box with the exact Dominus hitbox size, **1 unit = 1 Unreal unit**.
3. Model so the body fits that box. Small overhangs (spoilers, mirrors) are fine.
4. Orientation: **+X forward, +Z up**, origin at the centre of the hitbox floor.

## 2. UVs and textures

- One UV set for the body textures, plus a second UV set for decals (planned).
- 2048×2048 textures:
  - `T_Roadster_D`, diffuse / base colour
  - `T_Roadster_N`, normal map
  - `T_Roadster_M`, RGB paint mask: **R** = primary paint, **G** = accent paint, **B** = fixed colour (glass, lights)
- Sources go in `source/textures/`.

## 3. Export and check

Export the body as `.obj` (for the checker) and `.fbx` (for UDK):

- Scale **1.0**, Forward **X**, Up **Z**
- Apply modifiers, triangulate

```bash
python scripts/check_model.py exports/roadster.obj
```

The checker compares the bounding box with the hitbox in `config/roadster.json` (±8 %) and the triangle count with the budget (12 000). Fix anything marked `FAIL` before you continue.

## 4. Import into UDK (experimental)

1. Import the FBX as a **Skeletal Mesh**. Car bodies use bones for the wheels and suspension.
2. Import the textures and build a material with **Diffuse**, **Normal** and **paint-mask** parameters.
3. Keep bone names and sockets matching the body you replace, so wheels and boost attach in the right places.

## 5. Package (experimental)

1. Save the package with the name of the body it replaces, then cook it.
2. Rename the result to `Body_Roadster_SF.upk` and place it in `dist/`.
3. Test with `scripts\install.ps1` in **Free Play**.

## Contributing to the pipeline

If you have working experience packaging car bodies for UE3/Rocket League, please open an issue with the **pipeline** label. Getting steps 4–5 rock-solid is the most valuable help right now.
