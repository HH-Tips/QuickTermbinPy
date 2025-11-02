# qtb - Quick Termbin Py

`qtb` è un semplice e leggero strumento a riga di comando per scaricare file e "paste" dal servizio [termbin.com](https://termbin.com) direttamente nel tuo terminale.
Disponibile in [Python](https://github.com/HH-Tips/QuickTermbinPy) e [Java](https://github.com/HH-Tips/QuickTermbin).

---

## Installazione

Per installare lo strumento, puoi clonare questa repository e compilare il sorgente, oppure scaricare il file `QuickTermbin.jar` più recente dalla pagina [Releases](https://github.com/HH-Tips/QuickTermbin/releases).

Assicurati che l'eseguibile sia in una cartella inclusa nel `PATH` del tuo sistema per poterlo richiamare da qualsiasi posizione.

oppure installalo lanciando il seguente comando (consigliato):
```bash
curl -sL https://raw.githubusercontent.com/HH-Tips/QuickTermbinPy/refs/heads/main/install.sh | sudo bash
```
---

## Utilizzo

Il comando base richiede semplicemente l'ID del file da scaricare. Di default l'output sarà un file/cartella che ha per nome l'ID.

```bash
qtb <id> [-o <output_path>] [-b64] [-u]
```

### Opzioni disponibili

| Opzione            | Descrizione                                                     |
| ------------------ | --------------------------------------------------------------- |
| `-o <output_path>` | Salva l'output nel percorso specificato.                         |
| `-b64`             | Esegue la decodifica **Base64** del contenuto prima di salvarlo. |
| `-u`               | Decodifica il contenuto (Base64) e lo **decomprime** (unzip).   |
| `-h`               | Mostra il messaggio di aiuto.                                   |

---

## Esempi

**Scaricare un file e salvarlo in `./paste_id`**
```bash
qtb paste_id
```

**Scaricare un file e salvarlo in una directory specifica**
```bash
qtb paste_id -o ./output/mio_file.txt
```

**Scaricare un file codificato in Base64 (es. un'immagine) e decodificarlo**
```bash
qtb immagine_id -o immagine_scaricata.png -b64
```

**Scaricare, decodificare e decomprimere un archivio .zip**
```bash
qtb archivio_id -o ./cartella_output/ -u
```

---

## Licenza


Questo progetto è rilasciato sotto la licenza MIT. Vedi il file [`LICENSE`](https://github.com/HH-Tips/QuickTermbinPy/blob/main/LICENSE) per maggiori dettagli.

