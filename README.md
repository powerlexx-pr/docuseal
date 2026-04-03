# 📝 DocuSeal - UCM Edition (Derecho x La Pública)

A highly customized, self-hosted version of **DocuSeal** designed for institutional voting of the **UCMXLAPUBLICA** platform association at the Complutense University of Madrid.

## Key Features & Enhancements

This fork has been hardened and rebranded to meet the specific legal and security requirements of university.

### Institutional Security
- **Domain Lockdown (@ucm.es):** Strict validation at both Frontend (HTML5 Pattern) and Backend (Rails Model) levels. Only official Complutense University email addresses are allowed to participate.
- **Anti-Fraud System:** Implemented a **unique vote per document** restriction. The system prevents a single email from signing the same form multiple times using scoped database validation.

### Referendum Visual Mode
- **Branding Injection:** Full white-label experience.
  - Removed "Powered by DocuSeal" branding from web interfaces and emails.
  - Custom association logo and favicon integrated into the core build.
  - Dynamic tab titles set to `UCMXLAPUBLICA`.
- **Custom UI Theme:** A specialized "Referendum Mode" for the April 16th vote, featuring the corporate green theme (`#00bf63`) and high-contrast white typography for accessibility.
- **Privacy-First Completion Screen:** A redesigned "Thank You" page that hides the user's email and displays clear, association-specific instructions.

## Deployment & Installation

This version is optimized to run via **Docker Compose** behind a reverse proxy (like **Caddy**).

## License

Distributed under the AGPLv3 License with Section 7(b) Additional Terms. See [LICENSE](https://github.com/docusealco/docuseal/blob/master/LICENSE) and [LICENSE_ADDITIONAL_TERMS](https://github.com/docusealco/docuseal/blob/master/LICENSE_ADDITIONAL_TERMS) for more information.
Unless otherwise noted, all files © 2023-2026 DocuSeal LLC. Asmableas Informatica y Derecho UCMXLAPUBLICA


