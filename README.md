# Projet SAP – Un SI efficient et résilient

Projet fil rouge CESI, formation **Administrateur Systèmes et Réseaux** : refonte complète du système d'information de la *Société d'Accompagnement de la Personne* (SAP), une entreprise fictive du secteur social.

## Le contexte en bref

- **5 sites** : Lille (siège), Paris, Lyon, Toulouse, Marseille.
- **450 salariés** (+5 %/an) : éducateurs, psychologues, chefs de service, administratifs, souvent en mobilité.
- **1 750 usagers** suivis et 3 500 dossiers par mois, avec des **données de santé**.
- **Existant de 2015 en fin de vie** : postes, serveurs (ESXi 5.5, Windows 2012 R2, Exchange 2010), réseau, pas de PRA.
- **Exigences** : HDS, RGPD, ISO 27001, ISO 22301, ITIL, disponibilité 99,9 %, PRA/PCA, accès distant sécurisé, GreenIT.
- **Contraintes projet** : 8 mois, une enveloppe de 800 k€, une équipe de 2 personnes (le RSI et l'alternant).

## Les trois missions

| # | Mission | Livrables | État |
|---|---|---|---|
| 1 | [**Modéliser** les infrastructures systèmes et réseaux](partie1/README.md) | Schéma global, équipements à renouveler, budget, implantation | En cours |
| 2 | **Déployer** les infrastructures systèmes et réseaux | Configuration serveurs et services, adressage, routage, maquette | À venir |
| 3 | **Maintenir et sécuriser** les infrastructures | Bonnes pratiques, prévention des incidents, maintenance, supervision | À venir |

Le pilotage, transverse aux trois missions, couvre le RACI, le tableau de bord d'avancement, l'étude des risques et la planification.

## Solution retenue

Une **architecture hybride** : les données de santé et les applications critiques sont confiées à des hébergeurs certifiés HDS (IaaS sur deux régions pour le PRA, Microsoft 365, ERP médico-social en SaaS), et chaque site reçoit un réseau neuf et redondé (pare-feu SD-WAN en HA, double lien, cœur 10G, Wi-Fi 6). Seul le siège de Lille garde un petit cluster local. Le détail et les alternatives étudiées sont dans la [partie 1](partie1/README.md).

## Organisation du dépôt

```
.
├── README.md                          ce fichier
└── partie1/
    ├── README.md                      dossier de la mission 1
    ├── schema_infrastructure.drawio   schéma global (diagrams.net)
    └── budget_partie1.xlsx            budget avec hypothèses modifiables
```

## Outils

- Schémas : [diagrams.net](https://app.diagrams.net) (fichiers `.drawio`)
- Maquette réseau : Cisco Packet Tracer
- Maquette serveurs : VirtualBox, VMware Workstation ou Proxmox (Windows Server, pfSense/OPNsense, Zabbix, GLPI)
