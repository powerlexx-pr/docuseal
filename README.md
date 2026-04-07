# 📝 DocuSeal - UCM Edition (UCMXLAPUBLICA)

A highly customized, self-hosted version of **DocuSeal** and a companion **Census App** designed for institutional voting and the constitutional processes of the **UCMXLAPUBLICA** platform at the Complutense University of Madrid.

## Key Features & Enhancements

This fork has been hardened and rebranded to meet the specific legal and security requirements of university referendums.

### Institutional Security
- **Domain Lockdown (@ucm.es):** Strict validation at both Frontend (HTML5 Pattern) and Backend (Rails Model) levels. Only official Complutense University email addresses are allowed to participate.
- **Anti-Fraud System:** Implemented a **unique vote per document** restriction. The system prevents a single email from signing the same form multiple times using scoped database validation.
- **Cross-Platform Validation:** Integration with the `censo-app` ensures that a student who votes physically at a table cannot vote online, and vice versa.

### Real-Time Census Control (Censo-App)
This edition includes a custom-built **Census Companion App** (Python/Flask) designed for poll workers at physical voting tables:
- **Instant Search:** Verify if a student has already voted online (via DocuSeal) by simply entering their email.
- **Physical Vote Registration:** Allows poll workers to mark a student as "voted in person," which instantly blocks their ability to vote via the web platform.
- **Shared Integrity:** Both systems share the same PostgreSQL 18 backend, ensuring zero latency in double-vote prevention.

### Referendum Visual Mode
- **Branding Injection:** Full white-label experience.
  - Removed "Powered by DocuSeal" branding from web interfaces and emails.
  - Custom association logo and favicon integrated into the core build.
  - Dynamic tab titles set to `UCMXLAPUBLICA`.
- **Custom UI Theme:** A specialized "Referendum Mode" featuring the corporate green theme (`#00bf63`) and high-contrast white typography for accessibility.
- **Privacy-First Completion Screen:** A redesigned "Thank You" page that hides the user's email and displays clear association instructions.

## Deployment & Installation

This version is optimized to run via **Docker Compose** as a multi-container stack.

## License

Distributed under the AGPLv3 License with Section 7(b) Additional Terms. See [LICENSE](https://github.com/docusealco/docuseal/blob/master/LICENSE) and [LICENSE_ADDITIONAL_TERMS](https://github.com/docusealco/docuseal/blob/master/LICENSE_ADDITIONAL_TERMS) for more information.
Unless otherwise noted, all files © 2023-2026 DocuSeal LLC. Asmableas Informatica y Derecho UCMXLAPUBLICA


