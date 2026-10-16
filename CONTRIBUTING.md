# 🤝 Contributing

Thanks for wanting to help build the Roadster! Every kind of help counts: modelling, textures, the UE3 pipeline, docs, testing and translations.

## Where to start

1. Look at the [roadmap](README.md#-roadmap) and open [issues](../../issues).
2. Comment on an issue (or open a new one) to say what you're taking on, so two people don't do the same work.
3. Fork, create a branch, make your change and open a pull request.

## Branches and commits

- Branch names: `feature/hover-pads`, `fix/installer-path`, `docs/building-udk`
- Commit messages in the imperative: `Add paint mask template`, `Fix Steam path detection`

## 3D assets

- Install [Git LFS](https://git-lfs.com/) **before** adding `.blend`, `.fbx`, `.psd` or `.upk` files (`git lfs install`). `.gitattributes` already routes them to LFS.
- Run `python scripts/check_model.py <your.obj>` and paste the output into the PR.
- Only submit **original** work, or work under a licence that allows redistribution. No ripped game assets, no official manufacturer CAD data, no logos.

## Scripts

- PowerShell scripts must stay readable and side-effect-free until the user confirms paths. **No compiled binaries or `.exe` files**, ever.
- Python tools use only the standard library.

## Screenshots

Once a build runs in-game, real screenshots go into `assets/screenshots/`. Please:

- capture at 1920×1080 or higher, in **Free Play** or a private match,
- don't include other players' names,
- name files descriptively: `garage-front.png`, `aerial-boost.png`.

## Code of conduct

Be kind, assume good intent and keep feedback about the work, not the person.
