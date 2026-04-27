#!/usr/bin/env python3
"""
Génère les MP3 de dictée pour Brevet Quest via Azure Neural TTS.

Azure Speech Services : 500 000 caractères/mois gratuits (tier F0)
sur les voix neural — largement suffisant pour les ~30 phrases.

Usage:
    export AZURE_SPEECH_KEY="..."              # clé de ta ressource Speech
    export AZURE_SPEECH_REGION="westeurope"    # ex: westeurope, francecentral
    python3 tools/generate_dictee.py

Options:
    --force   Régénérer tous les MP3 (par défaut on saute les fichiers existants)
    --voice   Override la voix (défaut: fr-FR-DeniseNeural)
    --rate    Vitesse SSML (ex: -10%, défaut: -8% — un peu plus lent qu'une voix
              normale pour qu'on ait le temps de noter)

Voix françaises adaptées à la dictée :
  fr-FR-DeniseNeural               — femme adulte claire (défaut, idéal pour brevet)
  fr-FR-VivienneMultilingualNeural — femme très naturelle
  fr-FR-HenriNeural                — homme adulte
  fr-FR-JosephineNeural            — femme posée
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import time
import xml.sax.saxutils as xml_escape
from pathlib import Path
from urllib import error, request

ROOT = Path(__file__).resolve().parent.parent
CATALOG = ROOT / "tools" / "dictee_catalog.json"
OUT_DIR = ROOT / "assets" / "audio" / "dictee"

DEFAULT_VOICE = "fr-FR-DeniseNeural"
DEFAULT_REGION = "westeurope"
DEFAULT_RATE = "-8%"
OUTPUT_FORMAT = "audio-24khz-96kbitrate-mono-mp3"


def _ssml(voice: str, text: str, rate: str) -> str:
    """Construit le SSML pour synthétiser `text` avec la voix `voice`."""
    safe = xml_escape.escape(text)
    return f"""<speak version='1.0' xml:lang='fr-FR'
                  xmlns:mstts='https://www.w3.org/2001/mstts'>
        <voice name='{voice}'>
            <prosody rate='{rate}' pitch='0%'>{safe}</prosody>
        </voice>
    </speak>"""


def _synthesize(endpoint: str, key: str, voice: str, text: str, rate: str) -> bytes:
    """Appelle Azure TTS REST et renvoie le binaire MP3."""
    body = _ssml(voice, text, rate).encode("utf-8")
    req = request.Request(
        endpoint,
        data=body,
        method="POST",
        headers={
            "Ocp-Apim-Subscription-Key": key,
            "Content-Type": "application/ssml+xml",
            "X-Microsoft-OutputFormat": OUTPUT_FORMAT,
            "User-Agent": "BrevetQuest-Dictee",
        },
    )
    try:
        with request.urlopen(req, timeout=30) as resp:
            return resp.read()
    except error.HTTPError as exc:
        msg = exc.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"HTTP {exc.code} {exc.reason}: {msg}") from exc


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--force", action="store_true",
                        help="Régénérer tous les MP3, même ceux déjà présents")
    parser.add_argument("--voice", default=None,
                        help=f"Voix Azure (défaut: {DEFAULT_VOICE})")
    parser.add_argument("--region", default=None,
                        help=f"Région Azure (défaut: {DEFAULT_REGION})")
    parser.add_argument("--rate", default=DEFAULT_RATE,
                        help=f"Vitesse SSML (défaut: {DEFAULT_RATE})")
    args = parser.parse_args()

    key = os.environ.get("AZURE_SPEECH_KEY")
    if not key:
        print("❌ AZURE_SPEECH_KEY non défini.", file=sys.stderr)
        print("   export AZURE_SPEECH_KEY='...'", file=sys.stderr)
        return 1

    region = (
        args.region
        or os.environ.get("AZURE_SPEECH_REGION")
        or DEFAULT_REGION
    )

    if not CATALOG.exists():
        print(f"❌ Catalogue introuvable: {CATALOG}", file=sys.stderr)
        return 1

    catalog = json.loads(CATALOG.read_text(encoding="utf-8"))
    phrases: dict = catalog["phrases"]
    catalog_voice = catalog.get("voice")
    voices_map: dict = catalog.get("voices", {})

    default_voice = args.voice or catalog_voice or DEFAULT_VOICE
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    def resolve(raw):
        """Une phrase peut être une string ou {text, voice: alias}."""
        if isinstance(raw, dict):
            t = raw.get("text", "")
            alias = raw.get("voice")
            v = voices_map.get(alias, default_voice) if alias else default_voice
            return t, v
        return raw, default_voice

    total = len(phrases)
    total_chars = sum(len(resolve(v)[0]) for v in phrases.values())
    print(f"📖 {total} phrases ({total_chars} caractères au total)")
    print(f"🎙️  Voix par défaut: {default_voice}  |  Région: {region}")
    if voices_map:
        print(f"🎭 Voix supplémentaires: {', '.join(voices_map.keys())}")
    print(f"📂 Sortie: {OUT_DIR}")
    print()

    endpoint = f"https://{region}.tts.speech.microsoft.com/cognitiveservices/v1"

    generated, skipped, failed = 0, 0, 0
    for i, (key_name, raw) in enumerate(phrases.items(), 1):
        text, chosen_voice = resolve(raw)
        dest = OUT_DIR / f"{key_name}.mp3"
        if dest.exists() and not args.force:
            print(f"  [{i:02d}/{total}] ↷ {key_name}.mp3 (déjà présent)")
            skipped += 1
            continue

        voice_tag = "" if chosen_voice == default_voice else f" [{chosen_voice}]"
        print(f"  [{i:02d}/{total}] ⏳ {key_name}.mp3{voice_tag} — «{text}»")
        try:
            audio = _synthesize(
                endpoint, key, chosen_voice, text, rate=args.rate,
            )
            dest.write_bytes(audio)
            generated += 1
            time.sleep(0.15)
        except Exception as exc:  # noqa: BLE001
            print(f"     ❌ {exc}", file=sys.stderr)
            failed += 1

    print()
    print(f"✅ Généré: {generated}   ↷ Sautés: {skipped}   ❌ Échecs: {failed}")
    if failed:
        return 1
    print()
    print("Terminé ! Prochaine étape :")
    print("  flutter build apk --debug")
    print("  flutter install --debug")
    return 0


if __name__ == "__main__":
    sys.exit(main())
