#!/usr/bin/env python3

#!/usr/bin/env python3
import argparse
import re
from pathlib import Path

# Regex to parse filenames like:
#   "PETG @Voron.ini"
#   "PLA @Mk3 0.6mm.ini"
#   "PET-CF @Mk3 0.4 mm.ini"
FILENAME_RE = re.compile(
    r"""^(?P<filament>.+?)\s*@\s*
        (?P<printer>[^\s.]+)        # Voron | XL | Mk3 (case-insensitive)
        (?:\s+(?P<nozzle>\d+(?:\.\d+)?)\s*mm)?   # optional nozzle like 0.6mm
        \.ini$""",
    re.IGNORECASE | re.VERBOSE
)

# Regex to find/replace the setting line anywhere in the file
SETTING_RE = re.compile(r'(?im)^\s*compatible_printers_condition\s*=\s*.*$')

def detect_printer_token(printer_raw: str) -> str | None:
    p = printer_raw.strip().lower()
    # Be strict per your spec; extend here if you add printers later
    if 'voron' in p:
        return 'VORON'
    if 'xl' in p:
        return 'XL'
    if 'mk3' in p:
        return 'MK3'
    return None

def build_condition(printer_token: str, nozzle: str | None) -> str:
    cond = f"printer_notes=~/.*{printer_token}.*/"
    if nozzle is not None:
        # Keep as numeric literal (no quotes)
        cond += f" and nozzle_diameter[0]=={nozzle}"
    return cond

def process_ini(path: Path, dry_run: bool) -> tuple[bool, str]:
    m = FILENAME_RE.match(path.name)
    if not m:
        return False, f"SKIP (name pattern): {path.name}"

    printer_raw = m.group('printer')
    nozzle = m.group('nozzle')

    printer_token = detect_printer_token(printer_raw)
    if not printer_token:
        return False, f"SKIP (unknown printer): {path.name}"

    new_value = build_condition(printer_token, nozzle)
    new_line = f"compatible_printers_condition = {new_value}"

    try:
        original = path.read_text(encoding='utf-8')
    except Exception as e:
        return False, f"ERROR (read): {path.name}: {e}"

    if SETTING_RE.search(original):
        updated = SETTING_RE.sub(new_line, original)
        action = "replaced"
    else:
        # Append with a newline separator if needed
        sep = "" if original.endswith("\n") else "\n"
        updated = original + sep + new_line + "\n"
        action = "appended"

    if updated == original:
        return True, f"NO CHANGE: {path.name}"

    if dry_run:
        return True, f"DRY-RUN {action.upper()}: {path.name} -> {new_line}"

    # Write backup then new content
    try:
        backup = path.with_suffix(path.suffix + ".bak")
        if not backup.exists():
            backup.write_text(original, encoding='utf-8')
        path.write_text(updated, encoding='utf-8')
        return True, f"{action.upper()}: {path.name} -> {new_line}"
    except Exception as e:
        return False, f"ERROR (write): {path.name}: {e}"

def main():
    parser = argparse.ArgumentParser(description="Set compatible_printers_condition in filament INIs based on filename.")
    parser.add_argument("path", nargs="?", default=".", help="Directory to scan (default: current directory)")
    parser.add_argument("-n", "--dry-run", action="store_true", help="Show changes without writing files")
    parser.add_argument("-r", "--recursive", action="store_true", help="Recurse into subdirectories")
    args = parser.parse_args()

    root = Path(args.path).expanduser().resolve()
    if not root.exists():
        print(f"Path not found: {root}")
        raise SystemExit(2)

    pattern = "**/*.ini" if args.recursive else "*.ini"
    files = sorted(root.glob(pattern))

    if not files:
        print("No .ini files found.")
        return

    ok = 0
    for ini in files:
        success, msg = process_ini(ini, args.dry_run)
        print(msg)
        ok += int(success)

    # Non-zero exit if any failures occurred
    if ok < len(files):
        raise SystemExit(1)

if __name__ == "__main__":
    main()
