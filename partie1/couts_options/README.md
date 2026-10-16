# Coûts théoriques des trois options d'infrastructure

Ce dossier compare le coût des trois architectures étudiées en partie 1 : **A. Tout sur site**, **B. Hybride** (recommandée) et **C. Tout cloud**. Le détail ligne par ligne, avec les formules, est dans [`comparatif_couts_options.xlsx`](comparatif_couts_options.xlsx).

> Les montants sont **théoriques** : ce sont des prix publics indicatifs HT et des hypothèses de dimensionnement, pas des devis. Ils servent à comparer les options entre elles, pas à commander.

## Résultat

| | A. Tout sur site | **B. Hybride** | C. Tout cloud |
|---|---:|---:|---:|
| Investissement (CAPEX) | 1 352 k€ | **746 k€** | 725 k€ |
| Charges annuelles (OPEX) | 169 k€ | **239 k€** | 277 k€ |
| Coûts internes du projet | 81 k€ | **54 k€** | 49 k€ |
| **Budget projet** (CAPEX + 1 an d'OPEX + interne) | **1 602 k€** | **1 039 k€** | **1 051 k€** |
| **Coût total sur 5 ans** | **2 279 k€** | **1 994 k€** | **2 160 k€** |
| Coût par salarié et par an (5 ans) | 1 013 € | **886 €** | 960 € |

Les réserves (contingence 10 %, management 5 %) ne sont pas incluses ici. Elles s'ajoutent de la même façon aux trois options : voir `../budget_partie1.xlsx` pour l'option B.

## Lecture

- **A coûte le plus cher, et dès le départ.** Il faut tout acheter d'un coup : deux salles serveurs aménagées, un SAN, des licences perpétuelles (Office LTSC, Exchange, Windows Server). Ses charges annuelles sont les plus basses, mais elles ne compensent jamais l'investissement sur 5 ans. Surtout, A fait porter à SAP tout le poids de la conformité (équivalent HDS, audits) et oblige à une astreinte 24/7 que deux personnes ne peuvent pas tenir.
- **C a l'investissement le plus faible, mais les charges les plus lourdes.** Les abonnements augmentent avec les effectifs (+5 %/an). Il faut aussi doubler les fibres de chaque site, puisque sans Internet plus rien ne fonctionne. Sur 5 ans, C revient plus cher que B.
- **B est le meilleur compromis sur 5 ans.** Son investissement est proche de C, ses charges restent maîtrisées, et la conformité HDS est portée par les hébergeurs certifiés. C'est l'option qui répond le mieux à l'objectif « Économique : exploiter ce nouveau SI pour une période de 5 ans minimum » du Contexte SAP.
- **Aucune option ne tient dans les 800 k€.** Même la moins chère sur le budget projet (B, 1 039 k€) dépasse l'enveloppe. Les leviers pour s'en rapprocher sont dans le dossier de la partie 1, section 6.

## Ce qui est commun aux trois options (≈ 680 k€)

Quelle que soit l'option, il faut remplacer les 450 postes de 2015 (non compatibles Windows 11), les smartphones, le LAN, le Wi-Fi et les pare-feu des 5 sites. Ces lignes pèsent environ 680 k€ dans chaque option. La différence entre A, B et C se joue donc uniquement sur **les serveurs, les licences, l'hébergement, les liens et l'exploitation**.

## Hypothèses principales

| Poste | A. Tout sur site | B. Hybride | C. Tout cloud |
|---|---|---|---|
| Serveurs | 7 hyperviseurs (4 à Lille, 3 à Paris pour le PRA), 2 SAN, 2 salles aménagées | 2 serveurs + 1 NAS au siège | Aucun |
| Bureautique et messagerie | Office LTSC 2024 + Exchange Server SE (achat) | Microsoft 365 (150 E3 + 300 F3) | Microsoft 365 |
| ERP médico-social | Licence sur site + 20 %/an de maintenance | SaaS HDS | SaaS HDS |
| Hébergement | Aucun (sauf une copie de sauvegarde hors site) | IaaS HDS + PRA 2e région | IaaS HDS plus grand + PRA |
| Liens | Fibre par site + 10 Gb vers les 2 datacenters | Fibre + secours 4G/5G par site | Double fibre par site |
| Électricité | ≈ 8 kW IT, PUE 1,6, 0,20 €/kWh | ≈ 0,6 kW | Négligeable |
| Exploitation | +1 ETP et astreinte 24/7, audits de conformité | Équipe actuelle | Équipe actuelle |
| Coûts internes projet | +50 % (plus de matériel à installer) | Référence | −10 % |

Limites du calcul : les charges annuelles sont supposées constantes sur 5 ans (sans la croissance des effectifs ni l'inflation), et aucun renouvellement de matériel n'est compté avant 5 ans. Ces deux simplifications favorisent légèrement l'option A.
