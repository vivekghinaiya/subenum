# 🔍 Subdomain Enumeration Script

A colorful, automated, and efficient **Bash script** for performing **passive subdomain enumeration** using multiple tools. It collects subdomains, deduplicates them, probes for live hosts, and outputs everything in an organized, timestamped folder — making it ideal for recon workflows, bug bounty hunting, and red team engagements.

---

## 🚀 Features

- ✅ Passive enumeration using:
  - `assetfinder`
  - `amass` (passive)
  - `subfinder`
  - `findomain`
  - `crt.sh` + `jq`
  - `github-subdomains`
- 🌐 Live domain probing via `httpx`
- 🎨 Colorful and informative terminal output
- 🗂️ Organized output in `results_<domain>_<timestamp>` format
- 📊 Summary of total and live subdomains at the end

---

## 📂 Output Files

- `all_subdomains.txt` – All unique subdomains
- `live_subdomains.txt` – Subdomains with active HTTP/S responses

---

## 🛠️ Requirements

Make sure the following tools are installed and accessible in your `$PATH`:

- [`assetfinder`](https://github.com/tomnomnom/assetfinder)
- [`amass`](https://github.com/owasp-amass/amass)
- [`subfinder`](https://github.com/projectdiscovery/subfinder)
- [`findomain`](https://github.com/findomain/findomain)
- [`httpx`](https://github.com/projectdiscovery/httpx)
- [`github-subdomains`](https://github.com/gwen001/github-subdomains)
- `jq`, `curl`, `sed`, `sort`, `anew` (optional but helpful)

To install tools on Kali/Parrot:

```bash
sudo apt install amass jq curl sed findomain
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/tomnomnom/assetfinder@latest
