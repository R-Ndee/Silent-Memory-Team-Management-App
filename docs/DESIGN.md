# DESIGN.md

## 1. Design Purpose

Dokumen ini menjadi sumber utama aturan visual dan UX untuk aplikasi.

Design system harus digunakan secara konsisten pada seluruh halaman aplikasi.

Tujuan utama design:

- Mudah dipahami tanpa penjelasan tambahan.
- Nyaman digunakan setiap hari.
- Terlihat profesional tetapi tidak kaku.
- Terlihat seperti aplikasi yang dirancang secara sengaja oleh manusia.
- Tidak terlihat seperti template dashboard atau hasil generasi AI.
- Memprioritaskan readability, hierarchy, usability, dan consistency.
- Tidak menambahkan elemen visual hanya untuk membuat halaman terlihat lebih ramai.

PRD.md menentukan apa yang harus dilakukan aplikasi.

ARCHITECTURE.md menentukan bagaimana aplikasi dibangun.

DATABASE_SCHEMA.md menentukan bagaimana data disimpan.

DESIGN.md menentukan bagaimana aplikasi terlihat dan berinteraksi.

RULES.md menentukan aturan implementasi dan coding.

Jika terdapat konflik antar dokumen, jangan mengambil keputusan sendiri. Identifikasi konflik dan gunakan business requirement sebagai prioritas utama.

---

# 2. Platform Scope

## V1 Platform

V1 adalah aplikasi mobile-first yang dioptimalkan untuk smartphone.

Target utama:

- Android smartphone.
- Portrait orientation.
- Berbagai ukuran layar smartphone.
- Smartphone dengan layar kecil hingga smartphone yang relatif lebar.

Desktop, tablet, dan web bukan target UI V1.

Namun struktur aplikasi dan design system tidak boleh membuat pengembangan platform lain di masa depan menjadi sulit.

Flutter project harus tetap memungkinkan pengembangan:

- Android
- iOS
- Web
- Windows
- macOS

di masa depan jika diperlukan.

Jangan membuat keputusan visual yang secara tidak perlu mengunci aplikasi hanya untuk Android.

---

# 3. Design Direction

Aplikasi harus memiliki karakter:

- Human-designed.
- Clean.
- Professional.
- Practical.
- Calm.
- Modern.
- Trustworthy.
- Functional.
- Data-oriented.
- Tidak terlalu dekoratif.

Design tidak boleh terasa seperti:

- AI-generated dashboard.
- Generic SaaS template.
- Cryptocurrency dashboard.
- Marketing landing page.
- Glassmorphism interface.
- Futuristic interface.
- Excessive material design showcase.

Aplikasi adalah productivity and work management application.

Visual harus membuat pengguna merasa:

"Ini adalah aplikasi kerja yang serius dan rapi."

Bukan:

"Ini adalah demo UI yang dibuat untuk terlihat keren."

---

# 4. Human-Crafted Design Principles

Gunakan hierarchy, typography, spacing, alignment, border, dan color sebagai alat utama untuk membangun interface.

Jangan bergantung pada card untuk semua informasi.

Tidak semua section harus berada di dalam container.

Gunakan kombinasi:

- Flat section.
- List.
- Table-like rows.
- Divider.
- Card.
- Inline information.
- Tabs.
- Bottom sheet.
- Dialog.
- Form section.

Gunakan component berdasarkan kebutuhan informasi.

Jika sebuah elemen dapat ditampilkan dengan lebih sederhana tanpa kehilangan clarity, gunakan versi yang lebih sederhana.

Jangan menambahkan UI hanya karena tersedia component-nya.

---

# 5. Anti-Generic-AI Rules

Jangan menggunakan design pattern berikut secara berlebihan:

- Gradient.
- Glassmorphism.
- Blur.
- Excessive shadows.
- Excessive rounded cards.
- Giant statistics.
- Decorative illustrations.
- Excessive icon usage.
- Excessive badges.
- Excessive floating elements.
- Repetitive card grids.
- Multiple colorful sections.
- Large empty hero areas.
- Decorative background shapes.
- Unnecessary animation.

Jangan membuat setiap halaman memiliki struktur:

Header
→ statistic cards
→ large card
→ large card
→ large card
→ activity card

Jika struktur tersebut tidak diperlukan oleh informasi halaman, jangan gunakan.

Tidak semua angka harus ditampilkan sebagai large statistic.

Tidak semua status harus menggunakan badge besar.

Tidak semua button harus menggunakan primary color.

Tidak semua container membutuhkan shadow.

Tidak semua container membutuhkan rounded corners.

---

# 6. Visual Hierarchy

Setiap halaman harus memiliki hierarchy yang jelas.

Prioritas:

1. Page title.
2. Primary information.
3. Primary action.
4. Secondary information.
5. Supporting information.

Gunakan typography dan spacing untuk menentukan hierarchy sebelum menggunakan warna atau decoration.

Primary information harus terlihat tanpa membuat secondary information menjadi tidak terbaca.

---

# 7. Typography

Font utama:

Inter.

Gunakan satu font family secara konsisten.

Jangan menggunakan banyak jenis font hanya untuk membuat halaman terlihat menarik.

Typography hierarchy:

- Display / major number.
- Page title.
- Section title.
- Subsection title.
- Body.
- Secondary body.
- Caption.
- Label.
- Button text.

Gunakan font weight secara terbatas.

Recommended hierarchy:

- Page title: 600–700.
- Section title: 600.
- Body: 400–500.
- Label: 500–600.
- Button: 500–600.
- Caption: 400–500.

Jangan menggunakan bold untuk terlalu banyak teks.

Jika semuanya bold, tidak ada hierarchy.

---

# 8. Typography Readability

Text harus mudah dibaca dalam penggunaan sehari-hari.

Prioritaskan:

- Line height yang nyaman.
- Contrast yang cukup.
- Ukuran font yang sesuai dengan konteks.
- Tidak terlalu banyak uppercase.
- Tidak menggunakan font terlalu kecil untuk informasi penting.

Jangan mengecilkan font hanya untuk memaksa seluruh konten masuk dalam satu layar.

Jika konten panjang, gunakan scrolling.

---

# 9. Color Philosophy

Color palette harus restrained.

Gunakan primary color sebagai identitas aplikasi dan untuk primary action.

Jangan menggunakan primary color pada semua element.

Background harus relatif tenang.

Surface digunakan untuk membedakan area penting.

Text utama harus memiliki contrast yang kuat.

Secondary text harus lebih tenang tetapi tetap terbaca.

Border harus subtle.

Color digunakan untuk hierarchy dan semantic meaning, bukan decoration.

---

# 10. Color Roles

Design system harus menggunakan semantic color tokens.

Minimal token:

- primary
- primaryContainer
- background
- surface
- surfaceVariant
- textPrimary
- textSecondary
- textDisabled
- border
- success
- warning
- error
- info

Jangan hard-code warna langsung pada banyak widget.

Gunakan centralized theme/color tokens agar perubahan warna dapat dilakukan dari satu tempat.

---

# 11. Status Colors

Status performance:

- DONE
- LATE
- VERY_LATE
- NOT_DONE
- NOT_ASSIGNED

Status harus mudah dibedakan tetapi tidak terlalu mencolok.

Gunakan semantic color secara restrained.

Contoh prinsip:

DONE:
- success tone.

LATE:
- warning tone.

VERY_LATE:
- stronger warning tone.

NOT_DONE:
- error tone.

NOT_ASSIGNED:
- neutral tone.

Jangan membuat seluruh card atau halaman menjadi warna status.

Gunakan status color terutama pada:

- Badge.
- Indicator.
- Icon.
- Small label.
- Accent border jika diperlukan.

---

# 12. Shape System

Corner radius harus konsisten tetapi tidak berlebihan.

Gunakan radius berdasarkan hierarchy component.

Recommended:

- Small controls: 8–10px.
- Inputs: 10–12px.
- Buttons: 10–12px.
- Cards: 12–16px.
- Large surfaces: 16–20px.

Jangan menggunakan radius ekstrem pada seluruh UI.

Hindari membuat semua component terlihat seperti pill.

Pill shape hanya digunakan jika memang sesuai dengan component, terutama:

- Status badge.
- Filter chip.
- Small category indicator.

---

# 13. Borders

Border digunakan untuk:

- Memisahkan section.
- Menentukan boundary input.
- Membuat hierarchy.
- Mengurangi kebutuhan shadow.

Border harus subtle.

Jangan menggunakan border tebal pada seluruh component.

---

# 14. Elevation and Shadow

Shadow digunakan secara hemat.

Prioritas:

1. Dialog.
2. Bottom sheet.
3. Floating element jika diperlukan.
4. Component yang memang membutuhkan elevation.

Card biasa tidak harus memiliki shadow.

Jika border sudah cukup untuk membedakan surface, gunakan border tanpa shadow.

Hindari heavy shadow.

---

# 15. Spacing System

Spacing harus menggunakan sistem yang konsisten.

Base spacing:

4px.

Gunakan kelipatan yang konsisten:

- 4px
- 8px
- 12px
- 16px
- 20px
- 24px
- 32px
- 40px

Jangan menggunakan spacing acak tanpa alasan.

Spacing harus digunakan untuk membentuk hierarchy.

Contoh:

Page title
→ larger spacing
→ section
→ smaller spacing
→ related content

Related content harus lebih dekat dibandingkan section yang berbeda.

---

# 16. Mobile Layout

Layout dioptimalkan untuk smartphone portrait.

Content harus menggunakan available width secara efisien.

Gunakan horizontal padding yang nyaman.

Jangan membuat content terlalu mepet dengan edge layar.

Recommended base horizontal padding:

16px.

Gunakan 20–24px untuk section tertentu jika diperlukan.

---

# 17. Wider Smartphone Handling

Aplikasi harus tetap nyaman pada smartphone dengan layar lebih lebar.

Prinsip:

> Tambahkan ruang, bukan memperbesar seluruh UI secara berlebihan.

Jangan melakukan scaling seluruh interface hanya karena layar lebih lebar.

Typography tidak boleh membesar secara ekstrem.

Button tidak boleh menjadi terlalu besar.

Input tidak boleh menjadi terlalu lebar tanpa alasan.

Content tertentu dapat menggunakan maximum width agar text tetap nyaman dibaca.

Gunakan:

- SafeArea.
- Expanded.
- Flexible.
- ConstrainedBox.
- LayoutBuilder.
- Responsive padding.

jika memang diperlukan.

---

# 18. Short Screen Handling

Jangan mengasumsikan seluruh smartphone memiliki tinggi layar yang sama.

Untuk layar pendek:

- Content harus dapat scroll.
- Jangan memaksa semua content masuk satu layar.
- Jangan mengurangi font secara ekstrem.
- Jangan menghilangkan informasi penting.
- Bottom navigation harus tetap accessible.

Form panjang harus menggunakan scrolling.

---

# 19. Safe Area

UI harus menghormati:

- Status bar.
- Navigation gesture area.
- Camera notch.
- Display cutout.

Gunakan SafeArea jika diperlukan.

Tidak boleh ada content penting yang tertutup system UI.

---

# 20. Touch Target

Semua interactive element harus nyaman disentuh.

Target sentuh minimal harus mengikuti standar platform dan accessibility yang wajar.

Jangan membuat button atau icon button terlalu kecil hanya untuk menghemat ruang.

Icon button harus memiliki area touch yang cukup walaupun icon visualnya kecil.

---

# 21. Navigation

V1 menggunakan mobile navigation.

Primary navigation menggunakan bottom navigation.

Bottom navigation hanya berisi halaman utama yang paling sering digunakan.

Jangan memasukkan terlalu banyak item ke bottom navigation.

Halaman sekunder dapat diakses melalui:

- Profile.
- More menu.
- Contextual navigation.
- App bar action.

Navigation harus konsisten di seluruh aplikasi.

---

# 22. App Bar

App bar digunakan untuk:

- Page title.
- Back navigation.
- Important page action.
- Contextual action.

Jangan memenuhi app bar dengan terlalu banyak icon.

Page title harus menjelaskan konteks halaman dengan jelas.

Contoh:

"Performance"

bukan:

"Data"

Jika halaman memiliki konteks role, gunakan subtitle atau hierarchy jika diperlukan.

Contoh:

"Performance"
"Member"

---

# 23. Page Titles

Setiap halaman harus memiliki title yang jelas.

Nama halaman harus menggambarkan fungsi.

Contoh:

- Member Dashboard
- My Performance
- My Assignments
- My Payroll
- Admin Dashboard
- Member Management
- Jobdesk Management
- Assignment Management
- Performance Monitoring
- Crew Activities
- Payroll Management

Jangan menggunakan nama abstrak seperti:

- Overview.
- Data.
- Management.
- Workspace.

jika nama tersebut tidak menjelaskan fungsi halaman.

---

# 24. Forms

Form harus sederhana dan jelas.

Setiap input harus memiliki:

- Label.
- Appropriate input type.
- Validation.
- Error state.
- Optional helper text jika diperlukan.

Jangan mengandalkan placeholder sebagai satu-satunya label.

Form panjang harus dibagi menjadi logical sections.

Primary action harus mudah ditemukan.

---

# 25. Buttons

Gunakan button hierarchy.

### Primary

Untuk aksi utama halaman.

Contoh:

- Submit Performance.
- Save.
- Approve Payroll.

### Secondary

Untuk aksi pendukung.

Contoh:

- Cancel.
- Filter.
- View Details.

### Destructive

Untuk aksi yang memiliki konsekuensi serius.

Contoh:

- Disable Account.
- Cancel Assignment.
- Delete jika benar-benar diperbolehkan.

Jangan menggunakan primary button untuk semua aksi.

---

# 26. Cards

Card digunakan ketika grouping informasi memang membantu comprehension.

Gunakan card untuk:

- Summary.
- Important information.
- Distinct data group.
- Actionable information.

Jangan menggunakan card untuk setiap text block.

Card harus memiliki internal spacing yang konsisten.

Card tidak harus memiliki shadow.

---

# 27. Lists

List digunakan untuk:

- Activity history.
- Member list.
- Assignment list.
- Performance history.
- Crew history.

List item harus memiliki hierarchy.

Contoh:

Primary:
Jobdesk name

Secondary:
Date / member / supporting information

Trailing:
Status / amount / action

Jangan menampilkan semua metadata sekaligus jika tidak diperlukan.

---

# 28. Data-Dense Screens

Halaman seperti:

- Performance monitoring.
- Assignment management.
- Payroll.
- Member management.

harus memprioritaskan readability.

Jangan mengubah semua data menjadi giant cards.

Gunakan:

- Compact rows.
- Section headers.
- Filters.
- Search.
- Tabs jika diperlukan.
- Grouping.
- Status indicators.

Jika data terlalu banyak untuk satu layar, gunakan scrolling.

---

# 29. Performance UI

Member harus dapat dengan cepat mengetahui:

- Apa tugas hari ini.
- Sudah submit atau belum.
- Status pekerjaan.
- Riwayat performance.
- Achievement.

Dashboard member harus berorientasi pada action.

Jangan memenuhi dashboard member dengan data admin yang tidak relevan.

---

# 30. Admin UI

Admin harus dapat dengan cepat melihat:

- Member.
- Assignment.
- Performance status.
- Crew activity.
- Payroll status.
- Operational alerts.

Admin UI boleh lebih data-dense daripada Member UI.

Namun tetap harus menggunakan hierarchy yang jelas.

---

# 31. Payroll UI

Payroll memiliki sensitivitas tinggi.

Member hanya dapat melihat payroll setelah payroll approved.

Sebelum approved:

Jangan menampilkan nominal payroll yang belum final kepada member.

Member dapat melihat status seperti:

- Processing.
- Waiting for approval.
- Payroll approved.

Setelah approved:

Tampilkan:

- Payroll period.
- Performance amount.
- Crew amount.
- Bonus.
- Deduction.
- Net payroll.

Nominal harus memiliki hierarchy yang jelas.

---

# 32. Status and Badge Design

Badge harus compact.

Badge digunakan untuk informasi status, bukan sebagai decoration.

Contoh:

DONE
LATE
VERY_LATE
NOT_DONE
APPROVED
LOCKED
ACTIVE
INACTIVE

Badge harus memiliki:

- Background semantic yang subtle.
- Text yang readable.
- Radius yang sesuai.
- Padding yang cukup.

Jangan membuat badge terlalu besar.

---

# 33. Empty States

Empty state harus informatif.

Jangan hanya menampilkan:

"No Data"

Gunakan:

- Apa yang kosong.
- Kenapa kosong jika relevan.
- Apa yang dapat dilakukan pengguna.

Contoh:

"No performance submitted today."

Jika ada action:

"Submit today's performance"

Gunakan ilustrasi hanya jika benar-benar membantu.

---

# 34. Loading States

Loading state harus terasa natural.

Gunakan:

- Progress indicator.
- Skeleton jika memang berguna.
- Disabled state pada action saat proses berlangsung.

Jangan membuat loading animation berlebihan.

---

# 35. Error States

Error harus jelas dan actionable.

Jangan hanya:

"Something went wrong."

Jika memungkinkan jelaskan:

- Apa yang gagal.
- Apakah data tersimpan atau tidak.
- Apa yang dapat dilakukan pengguna.

Contoh:

"Performance could not be submitted. Please check your connection and try again."

---

# 36. Confirmation

Gunakan confirmation untuk aksi yang memiliki konsekuensi.

Contoh:

- Disable member.
- Cancel assignment.
- Approve payroll.
- Lock payroll.
- Correct historical data.

Jangan meminta confirmation untuk aksi biasa yang dapat dibatalkan dengan mudah.

---

# 37. Destructive Actions

Destructive action harus memiliki visual distinction.

Contoh:

- Disable account.
- Cancel assignment.
- Emergency correction.

Destructive action tidak boleh menjadi primary visual focus kecuali memang konteksnya membutuhkan.

---

# 38. Animation

Animation harus subtle dan functional.

Gunakan animation untuk:

- Page transition.
- State change.
- Loading.
- Feedback.
- Bottom sheet.
- Dialog.

Jangan menggunakan animation hanya untuk decoration.

Hindari:

- Excessive bouncing.
- Constant floating animation.
- Decorative particles.
- Excessive transitions.

Animation harus tidak mengganggu task utama.

---

# 39. Icons

Gunakan satu icon family yang konsisten.

Icon harus:

- mudah dikenali.
- memiliki visual weight yang konsisten.
- digunakan berdasarkan fungsi.

Jangan menggunakan icon hanya sebagai decoration.

Jangan mencampur terlalu banyak icon style.

---

# 40. Illustration

Illustration bukan bagian utama design system.

Gunakan hanya jika membantu:

- Empty state.
- Onboarding.
- Important system state.

Jangan menggunakan illustration di setiap halaman.

---

# 41. Images

Image digunakan jika memiliki fungsi nyata.

Contoh:

- Profile photo.
- Event image.
- Reference material.

Jangan menggunakan stock image sebagai decoration hanya agar halaman terlihat lebih hidup.

---

# 42. Accessibility

UI harus mempertimbangkan:

- Text contrast.
- Touch target.
- Readability.
- Dynamic text jika memungkinkan.
- Status tidak hanya dibedakan berdasarkan warna.

Contoh:

LATE tidak boleh hanya menggunakan warna kuning.

Gunakan kombinasi:

- Color.
- Text.
- Icon atau indicator.

---

# 43. Interaction Feedback

Setelah user melakukan action, aplikasi harus memberikan feedback yang jelas.

Contoh:

Submit performance
→ Loading
→ Success feedback
→ Status berubah menjadi submitted.

Jika gagal:
→ Error feedback.

Jangan membuat user menebak apakah action berhasil.

---

# 44. Offline and Network States

Karena aplikasi bergantung pada Firebase, network state harus diperhatikan.

Jika network bermasalah:

- Jangan menganggap data berhasil disimpan jika belum confirmed.
- Tampilkan error yang jelas.
- Jangan membuat duplicate submission karena user menekan button berkali-kali.
- Disable submit button selama request sedang berlangsung jika diperlukan.

---

# 45. Responsive Principle for Future Platforms

V1 tetap mobile-first.

Namun design system tidak boleh mengandung keputusan yang membuat future desktop implementation sulit.

Jika desktop version dibuat di masa depan:

Mobile UI tidak harus dipaksa menjadi desktop UI.

Desktop dapat memiliki:

- Sidebar.
- Multi-column layout.
- Data table.
- Larger content area.
- Different information density.

Namun:

- Color tokens.
- Typography system.
- Component semantics.
- Status system.
- Business terminology.

harus tetap konsisten.

---

# 46. Design Tokens

Semua nilai visual utama harus centralized.

Minimal token:

### Color

- primary
- primaryContainer
- background
- surface
- surfaceVariant
- textPrimary
- textSecondary
- textDisabled
- border
- success
- warning
- error
- info

### Typography

- display
- pageTitle
- sectionTitle
- body
- bodySmall
- label
- caption
- button

### Spacing

- 4
- 8
- 12
- 16
- 20
- 24
- 32
- 40

### Radius

- small
- medium
- large
- pill

### Elevation

- none
- subtle
- dialog

AI Agent harus menggunakan design tokens daripada hard-coded values sebanyak mungkin.

---

# 47. Component Consistency

Component yang memiliki fungsi sama harus terlihat dan berperilaku sama.

Contoh:

Semua primary button harus memiliki:

- typography yang konsisten.
- height yang konsisten.
- radius yang konsisten.
- interaction state yang konsisten.

Semua status badge harus mengikuti semantic status system.

Jangan membuat versi baru dari component yang sebenarnya sudah tersedia hanya karena perbedaan kecil.

---

# 48. Component Variation

Component boleh memiliki variation jika konteks memang berbeda.

Contoh:

Button:

- Primary.
- Secondary.
- Destructive.
- Text.

Card:

- Summary.
- Information.
- Actionable.

Namun jangan membuat banyak variation tanpa kebutuhan nyata.

---

# 49. Screen Composition

Setiap screen harus memiliki tujuan utama.

Sebelum membuat screen, AI Agent harus dapat menjawab:

1. Apa tujuan screen ini?
2. Siapa penggunanya?
3. Apa informasi paling penting?
4. Apa primary action?
5. Apa secondary action?
6. Apa yang harus terlihat tanpa scrolling?
7. Apa yang dapat diletakkan setelah scrolling?

Jika tidak ada jawaban jelas, screen harus dievaluasi sebelum implementasi.

---

# 50. Design Reference

Screenshot atau hasil design dari Stitch dapat digunakan sebagai visual reference.

Namun screenshot bukan source of truth.

Priority:

1. PRD.md untuk product requirement.
2. DESIGN.md untuk design system.
3. Screenshot reference untuk visual direction.
4. AI Agent judgment hanya digunakan jika tidak bertentangan dengan tiga hal di atas.

Jangan menyalin layout screenshot secara buta.

Gunakan screenshot untuk memahami:

- visual mood.
- spacing character.
- typography character.
- color relationship.
- component treatment.
- overall polish.

---

# 51. Stitch Usage

Stitch digunakan sebagai design exploration/reference tool.

Stitch bukan implementation authority.

Jika Stitch menghasilkan halaman yang tidak konsisten:

AI Agent harus mengikuti DESIGN.md.

Jika screenshot Stitch memiliki component yang bertentangan dengan DESIGN.md:

DESIGN.md memiliki prioritas.

Jangan menambahkan component hanya karena Stitch menghasilkan component tersebut.

---

# 52. AI-Generated UI Prevention

AI Agent harus mengevaluasi setiap screen sebelum dianggap selesai.

Checklist:

- Apakah terlalu banyak card?
- Apakah terlalu banyak rounded container?
- Apakah terlalu banyak shadow?
- Apakah ada gradient yang tidak diperlukan?
- Apakah terlalu banyak warna?
- Apakah semua section terlihat sama?
- Apakah typography hierarchy jelas?
- Apakah primary action jelas?
- Apakah informasi penting mudah ditemukan?
- Apakah ada decorative element yang tidak memiliki fungsi?
- Apakah halaman terasa seperti template?
- Apakah layout terlalu kosong?
- Apakah layout terlalu padat?
- Apakah spacing terasa intentional?

Jika jawabannya tidak baik, perbaiki sebelum melanjutkan.

---

# 53. Design Quality Standard

Sebuah screen dianggap selesai hanya jika:

- Visual hierarchy jelas.
- Typography readable.
- Spacing konsisten.
- Interactive elements mudah digunakan.
- Status mudah dipahami.
- Tidak ada unnecessary decoration.
- Tidak terlihat seperti generic AI dashboard.
- Tidak ada duplicated visual patterns yang tidak diperlukan.
- Screen memiliki purpose yang jelas.
- UI tetap nyaman pada smartphone dengan width berbeda.

---

# 54. Final Design Philosophy

Aplikasi harus terasa:

- sederhana ketika digunakan.
- lengkap ketika dibutuhkan.
- profesional tanpa menjadi kaku.
- modern tanpa menjadi futuristik.
- clean tanpa menjadi kosong.
- colorful tanpa menjadi ramai.
- polished tanpa menjadi dekoratif.
- konsisten tanpa menjadi monoton.

Prinsip utama:

> Design for clarity, not decoration.

> Use hierarchy before decoration.

> Use whitespace intentionally.

> Use color semantically.

> Use components because they solve a problem, not because they look good.

> Do not make every section a card.

> Do not make every page look identical.

> Do not optimize for screenshots. Optimize for real daily use.

> The application should look intentionally designed by a human, not automatically generated by an AI.

---

# 55. Implementation Priority

Jika terdapat keterbatasan waktu atau konflik implementasi, prioritaskan:

1. Usability.
2. Readability.
3. Information hierarchy.
4. Consistency.
5. Accessibility.
6. Responsive behavior across smartphone widths.
7. Visual polish.
8. Decorative details.

Jangan mengorbankan usability demi visual.

Jangan mengorbankan data readability demi aesthetic.

Jangan menambahkan visual complexity hanya untuk membuat aplikasi terlihat lebih sophisticated.

---

# 56. Design Change Policy

Perubahan visual setelah V1 diperbolehkan.

Namun perubahan harus dilakukan melalui centralized design tokens dan reusable components jika memungkinkan.

Jangan melakukan perubahan warna, typography, radius, spacing, atau component style secara acak di setiap screen.

Jika design system berubah:

1. Update DESIGN.md.
2. Update centralized theme/tokens.
3. Update reusable components.
4. Propagate perubahan ke screen yang terdampak.

Tujuan akhirnya adalah menjaga seluruh aplikasi tetap konsisten meskipun design berkembang.

---

# 57. Final Scope

V1:

- Mobile-first.
- Smartphone portrait.
- Android primary target.
- Responsive across smartphone widths.
- Firebase backend.
- Human-crafted visual direction.
- Professional productivity application.
- Minimal unnecessary decoration.
- Strong typography and spacing hierarchy.
- Consistent design tokens.
- Reusable components.
- Future platform expansion remains possible.

Desktop UI is explicitly out of scope for V1 but must remain possible for future versions.