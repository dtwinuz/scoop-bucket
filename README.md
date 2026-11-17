# dtwinuz/scoop-bucket

[bitg](https://bitg.uz) uchun [Scoop](https://scoop.sh) bucket. bitg — yozayotganingizda o'zbek matnini 2026-yilgi
yangi lotin alifbosiga (ö ğ ş ç) o'giradigan Windows kiritish usuli.

[![ci](https://github.com/dtwinuz/scoop-bucket/actions/workflows/ci.yml/badge.svg)](https://github.com/dtwinuz/scoop-bucket/actions/workflows/ci.yml)
[![bitg](https://img.shields.io/github/v/release/dtwinuz/bitg?label=bitg)](https://github.com/dtwinuz/bitg/releases/latest)

**[bitg.uz](https://bitg.uz) · [Jonli demo](https://wonmor.io/demo/bitg/) · [bitg repo](https://github.com/dtwinuz/bitg) · [Releases](https://github.com/dtwinuz/bitg/releases)**

<p align="center"><a href="https://wonmor.io/demo/bitg/"><img src="https://raw.githubusercontent.com/dtwinuz/bitg/main/docs/screenshots/try.jpg" width="820" alt="bitg: eski yozuvdagi matn yozish paytida 2026-yilgi lotin alifbosiga o'tadi, inglizcha so'zlar o'zgarmaydi"></a></p>

```powershell
scoop bucket add dtwinuz https://github.com/dtwinuz/scoop-bucket
scoop install dtwinuz/bitg
```

So'ng **Win + Probel** bosing va **bitg** ni tanlang.

bitg tizim klaviaturasi (TSF) bo'lgani uchun Scoop uni o'z papkasiga ochib qo'ymaydi: relizdagi MSI'ni yuklab, SHA-256
ni tekshiradi va Windows o'rnatuvchisi bilan o'rnatadi. Shu sabab Windows bir marta administrator ruxsatini (UAC)
so'raydi.

| Buyruq | Nima qiladi |
|---|---|
| `scoop update bitg` | yangi versiyaga o'tkazadi (MSI eski versiyani o'zi almashtiradi) |
| `scoop uninstall bitg` | dasturni o'chiradi |

Boshqa yo'llar (MSI, winget, Chocolatey): [bitg.uz/yuklab-olish](https://bitg.uz/yuklab-olish/). Muammo bo'lsa:
[bitg.uz/fikr](https://bitg.uz/fikr/) yoki [issues](https://github.com/dtwinuz/bitg/issues).

---

**English.** Scoop bucket for [bitg](https://bitg.uz), a Windows input method that converts Uzbek text to the 2026
Latin alphabet as you type. `scoop bucket add dtwinuz https://github.com/dtwinuz/scoop-bucket`, then
`scoop install dtwinuz/bitg`, then press Win + Space and pick bitg. The manifest downloads the release MSI, checks its
SHA-256 and runs it with Windows Installer (one UAC prompt), because a TSF input method has to be registered system
wide. 64-bit Windows 8.1, 10 or 11.

Manifest o'zi yangilanadi (`autobump` workflow, har 3 soatda): bitg'ning yangi relizi chiqsa, MSI SHA-256 va SLSA
attestation (dtwinuz/bitg `build.yml`, shu teg) bilan tekshiriladi, haqiqiy Scoop bilan Windows'da o'rnatib-o'chirib
sinaladi va faqat shundan keyin main'ga yoziladi. `ci` har o'zgarishda va har dushanba o'sha sinovni qaytaradi.
