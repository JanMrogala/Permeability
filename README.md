| OSTRAVSKÁ UNIVERZITAPŘÍRODOVĚDECKÁ FAKULTAKATEDRA INFORMATIKY A POČÍTAČŮ |
| --- |
|
# Algoritmy kvantifikace propustnosti materiálu pro 3D rastr


DIPLOMOVÁ PRÁCE |
| Autor práce: Bc. Jan MrógalaVedoucí práce: Mgr. Alexej Kolcun, CSc.
 |
| 2022 |

| UNIVERSITY OF OSTRAVAFACULTY OF SCIENCEDEPARTMENT OF INFORMATICS AND COMPUTERS |
| --- |
|
# Material permeability quantification algorithms for 3D raster


MASTER THESIS |
| Author: Bc. Jan MrógalaSupervisor: Mgr. Alexej Kolcun, CSc.
 |
| 2022 |

(Zadání vysokoškolské kvalifikační práce)

**ABSTRAKT**

Český text abstraktu

_Klíčová slova:_

_(klíčová slova vypsaná na řádku, oddělená od sebe čárkami)_

**ABSTRACT**

The text of the abstract.

_Keywords:_

**čestné prohlášení**

Já, níže podepsaný/á student/ka, tímto čestně prohlašuji, že text mnou odevzdané závěrečné práce v písemné podobě je totožný s textem závěrečné práce vloženým v databázi DIPL2.

Ostrava dne

………………………………

podpis studenta/ky

| Poděkování
 |
| --- |
| Prohlašuji, že předložená práce je mým původním autorským dílem, které jsem vypracoval/a samostatně. Veškerou literaturu a další zdroje, z nichž jsem při zpracování čerpal/a, v práci řádně cituji a jsou uvedeny v seznamu použité literatury.

 V Ostravě dne . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . (podpis) |

**OBSAH**

**[ÚVOD 9](#_Toc132174469)**

**[1](#_Toc132174470)****Cíle práce 10**

[1.1Definice pojmů 10](#_Toc132174471)

[1.1.1Propustnost 11](#_Toc132174472)

[1.1.2Úplná propustnost 11](#_Toc132174473)

[1.1.3Částečná propustnost 12](#_Toc132174474)

[1.1.4Kritické místo propustnosti 12](#_Toc132174475)

**[2](#_Toc132174476)****Analýza kritických míst 13**

[2.1Algoritmy hledání cesty v bludišti 13](#_Toc132174477)

[2.1.1Vyplňování slepých konců (breadth-first search) 13](#_Toc132174478)

[2.1.2Prohledávání do hloubky (depth-first search) 14](#_Toc132174479)

**[3](#_Toc132174480)****Analýza kvality propustnosti 15**

**[4](#_Toc132174481)****Matematická morfologie 16**

**[5](#_Toc132174482)****Podobnost mezi algoritmy vyplňování a řešení bludiště 18**

**[6](#_Toc132174483)****Algoritmus pro vyhledávání kritických míst propustnosti ve 2D 19**

[6.1Zamyšlení nad přístupem k problému. 19](#_Toc132174484)

[6.2Základní postup pro řešení problému 21](#_Toc132174485)

[6.3Další možné řešení problému 21](#_Toc132174486)

**[ZÁVĚR 23](#_Toc132174487)**

**[RESUMÉ 24](#_Toc132174488)**

**[SUMMARY 25](#_Toc132174489)**

**[SEZNAM POUŽITÉ LITERATURY 26](#_Toc132174490)**

**[SEZNAM OBRÁZKŮ 28](#_Toc132174491)**

**[SEZNAM TABULEK 29](#_Toc132174492)**

**[SEZNAM PŘÍLOH 30](#_Toc132174493)**

**ÚVOD**

Tato práce navazuje na mou bakalářskou práci, která se věnovala algoritmům pro vyplňování 3D rastru [4]. Předchozí práce se zaměřila na popis a porovnání různých vyplňovacích algoritmů, zatímco tato práce se soustředí na jejich využití při řešení konkrétního problému – permeability materiálu.

Tento problém je velmi zajímavý, protože právě pomocí vyplňovacích algoritmů můžeme detekovat permeabilitu materiálu. Konkrétněji, můžeme posoudit, zda je materiál v určitém stavu propustný, nebo nikoli. Z tohoto důvodu je tento problém ideální pro využití vyplňovacích algoritmů.

Pro praktickou aplikaci algoritmů je podobně jako v předešlé práci zvolena sada CT snímků, znázorňujících 3D pórovitý propustný materiál.

1.
# Cíle práce

Hlavním cílem této práce je nalezení způsobu, jak vyhodnotit permeabilitu propustného pórovitého materiálu. Důležitou roli pro vyřešení tohoto problému hrají právě vyplňovací algoritmy.

Vedlejším stanoveným cílem je porovnání algoritmů pro řešení bludiště a vyplňovacích algoritmů.

Pro aplikaci algoritmů je zvolen program Octave, ve kterém budou zdrojové kódy pro algoritmy napsány.

  1.
## Definice pojmů

Pro pochopení problému permeability materiálu a jaký problém se konkrétně snažíme vyřešit si nejdříve nadefinujeme několik pojmů. Pro zjednodušení se budeme zatím bavit pouze o 2D oblasti. Pro 3D oblast se základní myšlenky těchto pojmů nemění. Nejmenším obrazovým bodem, se kterým pracujeme a bereme jej v úvahu, je pixel.

    1.
### Propustnost

Chápejme propustnost materiálu v našem případě jako cestu z bodu A do bodu B přes oblast C. Pro ujasnění chápejme tyto body jako pixely v rastrové mřížce, zde je takto znázorňujeme pouze pro zjednodušení.

![Shape1](RackMultipart20230413-1-mnjxud_html_daada84fa9ca3683.gif)

_Obrázek 1- znázornění propustnosti materiálu_

    1.
### Úplná propustnost

Pro úplnou propustnost platí, že z bodu A existuje v dané oblasti cesta jak do bodu B tak do bodu C.

![Shape2](RackMultipart20230413-1-mnjxud_html_c9fbef87064efa5b.gif)

_Obrázek 2- znázornění úplné propustnosti_

    1.
### Částečná propustnost

Mějme hlavní oblast G obsahující podoblasti E a F, které nejsou propojeny. Částečná propustnost nastává, když z bodu A existuje cesta do bodu B, ovšem nikoli do bodu D.

G

![Shape3](RackMultipart20230413-1-mnjxud_html_af621f246dcf4212.gif) ![Shape6](RackMultipart20230413-1-mnjxud_html_5dbf5d8952564a25.gif) ![Shape4](RackMultipart20230413-1-mnjxud_html_2d6e5740e62337de.gif)

_Obrázek 3- znázornění částečné propustnosti_

    1.
### Kritické místo propustnosti

Pokud v oblasti C existuje místo D, které po uzavření znemožňuje propustnost zároveň z bodu A do bodu B, jedná se o kritické místo v dané oblasti.

![Shape7](RackMultipart20230413-1-mnjxud_html_64d4a6217d9b56b8.gif)

_Obrázek 4- znázornění kritického místa propustnosti_

1.
# Analýza kritických míst

Zásadním pojmem, který jsme si definovali, bylo kritické místo propustnosti. Abychom mohli analyzovat vlastnosti tohoto místa, musíme nejdříve nalézt cestu mezi body A a B. V našem případě využíváme vyplňovací algoritmy, ovšem můžeme na to taktéž nahlížet jako na problém hledání cesty bludištěm.

  1.
## Algoritmy hledání cesty v bludišti

Za vyřešení bludiště se dá považovat nalezení cesty z počáteční buňky bludiště do cíle. Případně nás může zajímat nalezená cesta.

Základní rozdělení těchto algoritmů je podle toho, zda řešící algoritmus pracuje s celým bludištěm, nebo pouze „simuluje" průchod bludištěm za určitých pravidel. [5]

Pro lepší představu zmíníme několik existujících algoritmů, a jejich principy.

    1.
### Vyplňování slepých konců (breadth-first search)

Algoritmus pracuje tak, že začne od vstupu do bludiště a postupně prochází jednotlivé chodby. Algoritmus označuje (vyplňuje) slepé cesty, které nevedou k cíli. Následně se vrací na poslední navštívenou křižovatku, ze které se na slepou cestu vydal. Poté pokračuje po jiné nevyzkoušené cestě a opakuje tento postup, dokud nenajde cestu k východu z bludiště. [5]

Jedná se o jednoduchý algoritmus, za jehož největší nevýhodu můžeme pokládat nutnost prohledat celé bludiště.

U tohoto algoritmu můžeme pozorovat podobnost s řádkovým semínkovým vyplňováním právě ve využití zapamatování křižovatky (kritického pixelu), ke kterému se algoritmus vrací.

![Shape8](RackMultipart20230413-1-mnjxud_html_af4985046de6607e.gif)

_Obrázek 5- průběh algoritmu slepých konců, převzato z [5]_

    1.
### Prohledávání do hloubky (depth-first search)

Prohledávání do hloubky prohledává graf postupně podle jednotlivých větví, tedy prochází do hloubky jednu větev, dokud nenarazí na uzel bez nezpracovaných sousedů. Poté se vrací zpět k poslednímu uzlu, u kterého existuje nezpracovaný soused a opakuje proces prohledávání do hloubky. Prohledávání do hloubky nemusí najít nejkratší cestu k cílovému uzlu, ale může najít řešení rychleji než vyplňování slepých konců, pokud je cílový uzel hlouběji v grafu.

![Shape9](RackMultipart20230413-1-mnjxud_html_48035a496b0cff56.gif)

_Obrázek 6- Postup prohledávání do hloubky, převzato z_

_[https://www.simplilearn.com/tutorials/data-structure-tutorial/dfs-algorithm](https://www.simplilearn.com/tutorials/data-structure-tutorial/dfs-algorithm)_

1.
# Analýza kvality propustnosti

Matematická morfologie

Zmínka o **dijkstrově** algoritmu, jak je reprezentován grafem, ale my graf nepoužijeme. Něco čerpat z wikipedie. Sedláček teorie grafů – 71, eulerovské grafy, využití silně. Zmínit teorii grafů ještě před bludištěm. Zmínit od pavly g. Reprezentaci. jakub černý – toky v sítích a další věci o reprezentaci grafů – maximální tok, minimální řez – to je to co dělám, ale v jiném kontextu [http://kam.mff.cuni.cz/~kuba/ka/toky.pdf](http://kam.mff.cuni.cz/~kuba/ka/toky.pdf) - kuba

V praktické ještě rozlišovat mezi dílčímí propustnostmi, od někud z leva se dostaneme do prava. Potom možná od někud z leva do všech v pravo, případně pokud jsou ty v levo propojené

Kód nachází minimální řez, je to modifikace. V závěru. Existuje potenciál pro paralelizaci. Jak se dá pokračovat.

deriv ![Shape10](RackMultipart20230413-1-mnjxud_html_540a5d8c7676eddc.gif)

1.
# derivace (pod kurzorem) du do gvemd
2. Matematická morfologie

Jelikož tato práce využívá některé koncepty matematické morfologie, bylo by vhodné popsat, o co se vlastně jedná.

Matematická morfologie je matematická teorie, která se zabývá analýzou geometrických transformací, jako jsou eroze, dilatace, otevření a uzavření, aplikovaných na obrazy nebo jiné geometrické objekty. Tato teorie byla poprvé navržena Georgesem Matheronem v roce 1962 a později rozvinuta Jeanem Serra v 70. letech 20. století.

Základní myšlenkou matematické morfologie je aplikace geometrických transformací na obrazová data za účelem získání informací o struktuře, tvaru a topologii objektů v obraze. Eroze a dilatace jsou základními operacemi matematické morfologie, které slouží k úpravě tvaru objektů v obraze. Eroze objektu je proces odstraňování jeho okrajů, zatímco dilatace je proces přidávání nových okrajů do objektu. Tyto operace mohou být použity k odstranění šumu z obrazu, oddělení objektů od pozadí a detekci hran v obraze.

Otevření a uzavření jsou dalšími základními operacemi matematické morfologie. Otevření spočívá v aplikaci eroze následované dilatací na objekt, což může být použito ke snížení šumu a vylepšení hran objektů. Uzavření je opačný proces, kdy se nejprve použije dilatace a následně eroze na objekt, což může být použito ke spojení neúplných objektů a vyplnění malých děr v obraze.

Matematická morfologie může být také použita pro segmentaci obrazů, což znamená rozdělení obrazu na samostatné objekty nebo regiony. K tomuto účelu se používají různé techniky, jako je thresholding, který rozděluje obraz na základě intenzity pixelů, nebo watershed transformace, která rozděluje obraz na základě topografických vlastností.

Dalším využitím matematické morfologie je extrakce rysů z obrazů, což zahrnuje detekci hrany, výpočet vzdáleností, průměrů a dalších geometrických vlastností objektů v obraze. Tyto rysy mohou být použity pro klasifikaci objektů a detekci změn v obraze.

V současné době se matematická morfologie používá v různých oblastech, jako jsou medicína, průmyslová kontrola kvality, robotika a geografické informační systémy. V medicíně se matematická morfologie používá k analýze zobrazovacích metod, jako jsou MRI a CT skenování, k detekci anomálií a k vylepšení kvality obrazu. V průmyslové kontrole kvality se matematická morfologie používá k inspekci výrobků a ke kontrole jejich kvality, což může být důležité pro prevenci vad a zlepšení výrobních procesů. V robotice se matematická morfologie používá pro navigaci a detekci překážek v prostoru, což je důležité pro autonomní řízení robotů. V geografických informačních systémech se matematická morfologie používá pro analýzu terénu a detekci vodních toků a silnic v mapách.

V závěru lze říci, že matematická morfologie je důležitou matematickou teorií, která se zabývá analýzou geometrických transformací aplikovaných na obrazová data. Tato teorie má mnoho aplikací v různých oblastech, jako jsou medicína, průmyslová kontrola kvality, robotika a geografické informační systémy. Díky své všestrannosti a účinnosti se matematická morfologie stává stále více významnou v moderních technologiích a má potenciál pro další výzkum a vývoj.

Zásadním pojmem je strukturní element (Obr. 1).

![Shape11](RackMultipart20230413-1-mnjxud_html_6dc35219c5fff1e7.gif)

_Obrázek 7 - příklad strukturních elementů [2]_

1.
# Podobnost mezi algoritmy vyplňování a řešení bludiště

Mezi algoritmy řešení bludiště a algoritmy výplně vybrané oblasti existuje nějaká podobnost. Obě tyto metody se zaměřují na prohledávání a navigaci ve dvourozměrném prostoru za účelem nalezení cesty nebo oblasti zájmu.

V algoritmech řešení bludiště je cílem najít cestu z počátečního bodu do koncového bodu v bludišti, a přitom se vyhnout překážkám nebo slepým uličkám. Algoritmus obvykle používá vyhledávací strategii, jako je prohledávání do hloubky nebo do šířky, k prozkoumání bludiště a nalezení cesty k cíli.

V algoritmech výplně vybrané oblasti je cílem vyplnit oblast zájmu, jako je uzavřený tvar nebo oblast ohraničená konturami, konkrétní barvou nebo texturou. Algoritmus obvykle začíná se semenným bodem uvnitř oblasti zájmu a iterativně přidává sousední body k výplňovému souboru na základě nějakých předdefinovaných kritérií.

Oba algoritmy, řešení bludiště i výplně vybrané oblasti, zahrnují průchod dvourozměrným prostorem a prozkoumávání sousedních buněk nebo pixelů. Oba také zahrnují použití datových struktur, jako jsou zásobníky nebo fronty, pro udržování navštívených buněk nebo pixelů a pro řízení procesu prohledávání nebo výplně.

Existují však také některé klíčové rozdíly mezi algoritmy řešení bludiště a výplně vybrané oblasti. Algoritmy řešení bludiště se obvykle zaměřují na nalezení jediné cesty z počátečního bodu do koncového bodu, zatímco algoritmy výplně vybrané oblasti se zaměřují na vyplnění celé oblasti zájmu. Algoritmy řešení bludiště mohou také zahrnovat složitější vyhledávací strategie, jako je například A\* nebo Dijkstrův algoritmus, pro nalezení optimální cesty, zatímco algoritmy výplně vybrané oblasti mohou používat jednodušší kritéria, jako je práh barvy nebo intenzity.

1.
# Algoritmus pro vyhledávání kritických míst propustnosti ve 2D

  1.
## Zamyšlení nad přístupem k problému.

Způsoby, jak vyhledat kritická místa propustnosti můžeme vymyslet více. Nejjednodušší algoritmus, který by se dal použít, by mohl při vyplňování zároveň prohledávat okolní čtyři sousední pixely zrovna vyplňovaného pixelového bodu. Narážíme zde ovšem na více problémů. Ten první je, že by nestačilo prosté kontrolování sousedního okolí pixelu, ale bylo by nutné prohledávat větší oblast, jelikož nemůžeme předpokládat, že v materiálu je kritické místo propustnosti o velikosti 1 pixelu. Další problematická situace nastává při určité konfiguraci hraniční oblasti.

![Shape12](RackMultipart20230413-1-mnjxud_html_cfba4b88f6441844.gif) ![Shape13](RackMultipart20230413-1-mnjxud_html_a9086d09f15dac1d.gif)

_Obrázek 8: 4 směry hledání Obrázek 9: 8 směrů hledání_

Problémový případ:

![Shape14](RackMultipart20230413-1-mnjxud_html_3ee300e7dfdba856.gif)

_Obrázek 10: problém 4 směrů hledání_

Velký problém, na který narážíme u jednoduchého prohledávání sousedních pixelů je ten, že existují případy, kdy je kritické místo těžko detekovatelné. Příklad můžeme vidět na obrázcích výše. Pokud bychom vyhledávali pouze do 4 směru, tak nedetekujeme kritické místo mezi dvěma obdélníky. Ovšem i když zařídíme, abychom prohledávali ne do čtyř, ale do osmi směrů, negarantujeme tím úspěšnou detekci. Tyto případy jsou tedy důvodem, proč využití této jednoduché metody není dobrý nápad. Další způsoby, jak prohledávat okolí jednoho bodu, jistě existují, ovšem komplexnost začíná růst jak z implementačního hlediska, tak výpočetního. Přesuneme se tedy na další možnost řešení daného problému.

  1.
## Základní postup pro řešení problému

1. Nalezení všech unikátních počátečních ploch na stěně materiálu, které propojují jednu stěnu materiálu se stěnou opačnou.
2. Extrakce celého propojujícího prostoru mezi stěnami pomocí algoritmu vyplnění.
3. Aplikace algoritmu na vyhledávání kritických míst propustnosti.
4. Souřadnicový výstup se zaznačenými kritickými místy v materiálu.

  1.
## Další možné řešení problému

Pokud nejsme reálně schopni využít prohledávání sousedního okolí kolem pixelového bodu, což by byl nejjednodušší přístup, vymyslíme jiný.

Následující přístup využívá teorie matematické morfologie, a to konkrétně dilatace. Myšlenka spočívá v tom, že místo toho, abychom zkoumali jednotlivé pixely, zda se nejedná o kritické místa, raději postupně dilatujeme hraniční body. Tento přístup je méně výhodný v tom, že bude nutné opakované vyplňování zkoumané oblasti, abychom zjistili, zda došlo k uzavření materiálu. Tato operace rozšiřování bude opakována tak dlouho, až dojde k uzavření. Jakmile zjistíme, že již nelze materiálem prostoupit na jeho druhý konec, víme, že jsme zaplnili místo, které je kritické. Následně stačí si toto místo vyhledat (například pomocí průniku předchozí a poslední vyplněné oblasti před uzavřením) a označit. Tímto způsobem získáme souřadnici (souřadnice, je-li takovýchto míst více) kritického místa v propustném materiálu. Problémem tohoto přístupu je ovšem to, že nalezneme kritická místa, které nemusejí být zásadní pro celkovou propustnost materiálu. Jinak řečeno, výsledkem by byly i souřadnice kritických míst, vedoucích do různých "kapes" v materiálu. My ovšem stojíme pouze o úzká místa, která ovlivňují pouze celkovou propustnost materiálu.

![Shape15](RackMultipart20230413-1-mnjxud_html_20fa475259d8ecc6.gif)

_Obrázek 11- průběh navrhované metody hledání kritických míst_

Poznámka: Analýza kritických míst, můžeme se na to podívat jako hledání cesty bludistem. Začínáme z bodu A do bodu B. Existuje uplna nebo castecna propustnost. Zmínit práce na algoritmy hledání bludiště. Naše řešení bude trochu jiné a bude spočívat v tom, že aplikujeme vyplňovací algoritmus. Dát to do konextu až po tom. Hledání cesty můžeme chápuat jako variantu vyplňovacích algoritmů. Problém je vlastně hledání cesty. K vyplnění jsou použity výsledky mé bc práce.

Kvalita té propustnosti – kritická místa. Jak silná je propustnost, nebo jak silná je překážka, která nám brání. K analýze této problematiky použijeme matematickou morfologii.

Jít více do hloubky k věcem které používáme v mat morfologii, uvést kdyžtak na konec. Popsat ty operace, které používám a zmínit, že octave to má. Vztah mezi dilatací a erozí, zmínit že nejsou vzájemně inverzní. Urychlení procesu. Přemýšlet nad vztahem mezi pamatováním kroků a potom zkusit erozi. Morfologické operace kvůli síly propustnosti

**ZÁVĚR**

**RESUMÉ**

**SUMMARY**

**SEZNAM POUŽITÉ LITERATURY**

1. **S. Haj Ibrahim, J. Skibinski, G. J. Oliver, T. Wejrzanowski**. _Microstructure effect on the permeability of the tape-cast open-porous materials_. Materials & Design Vol. 167, April 2019
2. **M. Šonka, V. Hlaváč, R. Boyle**. _Image Processing, Analysis and Machine Vision_. Springer 2015.
3. **P. Grossmanová**. _Model 3D prostoru_. Ostrava, 2019. Diplomová práce. Ostravská univerzita. Přírodovědecká fakulta. Katedra informatiky a počítačů.
4. **J. Mrógala**. _Algoritmy vyplňování pro 3D rastr_. Ostrava, 2021. Bakalářská práce. Ostravská univerzita. Přírodovědecká fakulta. Katedra informatiky a počítačů.
5. **P. Matějka**. _Algoritmy pro generování a řešení bludišť_. Brno, 2012. Diplomová práce. Masarykova univerzita. Fakulta informatiky.
6. SEZNAM POUŽITÝCH SYMBOLŮ

| ABC |
 |
 | Význam první zkratky. |
| --- | --- | --- | --- |
| B |
 |
 | Význam druhé zkratky. |
| C |
 |
 | Význam třetí zkratky. |
|
 |
 |
 |
 |

**SEZNAM OBRÁZKŮ**

**SEZNAM TABULEK**

**SEZNAM PŘÍLOH**

27