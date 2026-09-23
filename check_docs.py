#!/usr/bin/env python3
"""Validate documentation metadata, names, links, and SUMMARY coverage."""

from pathlib import Path
from urllib.parse import unquote
import re

ROOT = Path(__file__).parent
SUMMARY = ROOT / "SUMMARY.md"
LINK = re.compile(r"!?\[[^]]*]\(([^)]+)\)")
NUMBERED_DOC = re.compile(r"\d{2}-[^\s.]+\.md")
IMAGE_NAME = re.compile(r"\d{2}-[a-z0-9]+(?:-[a-z0-9]+)*\.[a-z0-9]+")
DATE = re.compile(r"\d{4}-\d{2}-\d{2}")
TYPES = {"concept", "how-to", "tutorial", "reference", "troubleshooting", "term", "symptom"}


def validate_frontmatter(path: Path, text: str) -> list[str]:
    relative = path.relative_to(ROOT)
    if path == SUMMARY:
        return []
    lines = text.splitlines()
    if not lines or lines[0] != "---":
        return [f"{relative}: missing frontmatter"]
    try:
        end = lines.index("---", 1)
    except ValueError:
        return [f"{relative}: unclosed frontmatter"]

    frontmatter = "\n".join(lines[1:end])
    errors: list[str] = []
    fields = {}
    for name in ("title", "description", "type", "group", "lastUpdated"):
        match = re.search(rf"^{name}:\s*(.+)$", frontmatter, re.MULTILINE)
        if not match:
            errors.append(f"{relative}: missing frontmatter field {name}")
        else:
            fields[name] = match.group(1).strip().strip('"')

    if fields.get("type") not in TYPES:
        errors.append(f"{relative}: invalid type {fields.get('type', '')}")
    if "lastUpdated" in fields and not DATE.fullmatch(fields["lastUpdated"]):
        errors.append(f"{relative}: lastUpdated must use YYYY-MM-DD")
    if not re.search(r"^sidebar:\s*\n  order:\s*\d+\s*$", frontmatter, re.MULTILINE):
        errors.append(f"{relative}: missing numeric sidebar.order")
    return errors


def validate_name(path: Path) -> str | None:
    relative = path.relative_to(ROOT)
    if len(relative.parts) != 2 or relative.parts[0] not in {"Git", "Advanced", "GitHub", "GitLab"}:
        return None
    if relative.as_posix() == "Advanced/README.md" or NUMBERED_DOC.fullmatch(path.name):
        return None
    return f"{relative}: expected NN-title.md"


def main() -> int:
    errors: list[str] = []
    markdown = sorted(ROOT.glob("**/*.md"))
    summary = SUMMARY.read_text(encoding="utf-8")

    for path in markdown:
        text = path.read_text(encoding="utf-8")
        errors.extend(validate_frontmatter(path, text))
        if name_error := validate_name(path):
            errors.append(name_error)
        if text.count("```") % 2:
            errors.append(f"{path.relative_to(ROOT)}: unclosed code fence")
        for line_number, line in enumerate(text.splitlines(), 1):
            if line.endswith((" ", "\t")):
                errors.append(f"{path.relative_to(ROOT)}:{line_number}: trailing whitespace")
            if "[[" in line:
                errors.append(f"{path.relative_to(ROOT)}:{line_number}: Obsidian link")
            for raw_target in LINK.findall(line):
                target = raw_target.split("#", 1)[0]
                if not target or re.match(r"(?:https?|mailto):", target):
                    continue
                resolved = ROOT / unquote(target).lstrip("/") if target.startswith("/") else path.parent / unquote(target)
                if not resolved.exists():
                    errors.append(f"{path.relative_to(ROOT)}:{line_number}: missing {raw_target}")

    for images in (ROOT / "Git" / "images", ROOT / "GitHub" / "images"):
        for path in sorted(images.iterdir()):
            if path.is_file() and not IMAGE_NAME.fullmatch(path.name):
                errors.append(f"{path.relative_to(ROOT)}: expected NN-ascii-kebab-case.ext")

    for path in markdown:
        relative = path.relative_to(ROOT).as_posix()
        if relative in {"README.md", "SUMMARY.md", "Advanced/README.md"}:
            continue
        if f"({relative})" not in summary:
            errors.append(f"SUMMARY.md: missing {relative}")

    if errors:
        print("\n".join(errors))
        return 1
    print(f"OK: {len(markdown)} Markdown files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
