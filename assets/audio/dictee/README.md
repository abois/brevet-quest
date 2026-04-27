# Dictées (MP3)

Les MP3 sont générés par `tools/generate_dictee.py` à partir de
`tools/dictee_catalog.json`.

```bash
export AZURE_SPEECH_KEY="..."
export AZURE_SPEECH_REGION="westeurope"
python3 tools/generate_dictee.py
```

Le script ne régénère pas les MP3 déjà présents (idempotent).
