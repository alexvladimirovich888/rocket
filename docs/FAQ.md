# ❓ FAQ

### Is there a download yet?
Not yet. The project is in development and the images in the README are concept art. Watch the repository (**Watch → Custom → Releases**) to get notified when the first build ships.

### Can I get banned?
The mod replaces one local visual file. It doesn't inject code, read game memory or touch network traffic, and the hitbox stays exactly the same. Even so, modifying game files is **not officially supported** by Psyonix or Epic Games, and their rules can change. Use the mod at your own risk, ideally in offline modes, Free Play and private matches.

### Do other players see the Roadster?
No. It's client-side only.

### Why the Dominus hitbox?
The Roadster is long and low, and Dominus is the closest standard hitbox to that shape. Building on an existing hitbox means the mod changes nothing about how the car plays.

### Which body does it replace?
The one set in `config/roadster.json` → `replace.targetPackage`. While installed, that body shows up as the Roadster.

### A game update removed the mod
Updates restore original files. Run `scripts\install.ps1` again. If the installer can't find the target package, the update probably renamed it, so please open an issue.

### Mac, Linux, consoles?
Windows PC only for now. Consoles don't allow file changes.

### Is it the real Tesla Roadster?
It's a fan recreation of the next-gen Tesla Roadster, modelled by hand from public photos ([references](REFERENCES.md)). It uses no official CAD data, the model carries no Tesla logos, and the project isn't affiliated with Tesla, Inc.
